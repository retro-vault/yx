/* z80-stub.c -- debugging stub for the Z80

   This stub is based on the SH stub by Ben Lee and Steve Chamberlain. 

   Modifications for the Z80 by Leonardo Etcheverry <letcheve@fing.edu.uy>, 2010.
   
   - Building the stub -
   # sdcc --no-std-crt0 -mz80 --model-large --no-peep --stack-auto --code-loc 0x0000 --data-loc 0x9000 z80-stub.c -o z80-stub
   # srec_cat z80-stub -Intel -output z80-stub.bin -Binary

   # (optional, create a 16K rom file for the z80 qemu target)
   # cat z80-stub.bin /dev/zero | dd bs=1k count=16 > /opt/qemu-z80/share/qemu/zx-rom.bin
*/

 

/* Remote communication protocol.

   A debug packet whose contents are <data>
   is encapsulated for transmission in the form:

        $ <data> # CSUM1 CSUM2

        <data> must be ASCII alphanumeric and cannot include characters
        '$' or '#'.  If <data> starts with two characters followed by
        ':', then the existing stubs interpret this as a sequence number.

        CSUM1 and CSUM2 are ascii hex representation of an 8-bit 
        checksum of <data>, the most significant nibble is sent first.
        the hex digits 0-9,a-f are used.

   Receiver responds with:

        +       - if CSUM is correct and ready for next packet
        -       - if CSUM is incorrect

   <data> is as follows:
   All values are encoded in ascii hex digits.

        Request         Packet

        read registers  g
        reply           XX....X         Each byte of register data
                                        is described by two hex digits.
                                        Registers are in the internal order
                                        for GDB, and the bytes in a register
                                        are in the same order the machine uses.
                        or ENN          for an error.

        write regs      GXX..XX         Each byte of register data
                                        is described by two hex digits.
        reply           OK              for success
                        ENN             for an error

        write reg       Pn...=r...      Write register n... with value r...,
                                        which contains two hex digits for each
                                        byte in the register (target byte
                                        order).
        reply           OK              for success
                        ENN             for an error
        (not supported by all stubs).

        read mem        mAA..AA,LLLL    AA..AA is address, LLLL is length.
        reply           XX..XX          XX..XX is mem contents
                                        Can be fewer bytes than requested
                                        if able to read only part of the data.
                        or ENN          NN is errno

        write mem       MAA..AA,LLLL:XX..XX
                                        AA..AA is address,
                                        LLLL is number of bytes,
                                        XX..XX is data
        reply           OK              for success
                        ENN             for an error (this includes the case
                                        where only part of the data was
                                        written).

        cont            cAA..AA         AA..AA is address to resume
                                        If AA..AA is omitted,
                                        resume at same address.

        step            sAA..AA         AA..AA is address to resume
                                        If AA..AA is omitted,
                                        resume at same address.

        last signal     ?               Reply the current reason for stopping.
                                        This is the same reply as is generated
                                        for step or cont : SAA where AA is the
                                        signal number.

        There is no immediate reply to step or cont.
        The reply comes when the machine stops.
        It is           SAA             AA is the "signal number"

        or...           TAAn...:r...;n:r...;n...:r...;
                                        AA = signal number
                                        n... = register number
                                        r... = register contents
        or...           WAA             The process exited, and AA is
                                        the exit status.  This is only
                                        applicable for certains sorts of
                                        targets.
        kill request    k

        toggle debug    d               toggle debug flag (see 386 & 68k stubs)
        reset           r               reset -- see sparc stub.
        reserved        <other>         On other requests, the stub should
                                        ignore the request and send an empty
                                        response ($#<checksum>).  This way
                                        we can extend the protocol and GDB
                                        can tell whether the stub it is
                                        talking to uses the old or the new.
        search          tAA:PP,MM       Search backwards starting at address
                                        AA for a match with pattern PP and
                                        mask MM.  PP and MM are 4 bytes.
                                        Not supported by all stubs.

        general query   qXXXX           Request info about XXXX.
        general set     QXXXX=yyyy      Set value of XXXX to yyyy.
        query sect offs qOffsets        Get section offsets.  Reply is
                                        Text=xxx;Data=yyy;Bss=zzz
        console output  Otext           Send text to stdout.  Only comes from
                                        remote target.

        Responses can be run-length encoded to save space.  A '*' means that
        the next character is an ASCII encoding giving a repeat count which
        stands for that many repititions of the character preceding the '*'.
        The encoding is n+29, yielding a printable character where n >=3 
        (which is where rle starts to win).  Don't use an n > 126. 

        So 
        "0* " means the same as "0000".  */

#include <string.h>
#include "serial.h"

/* external NMI FF clear */
#define NMI_FF_CLR         0x10

/* Z80 instruction opcodes */
#define RST18_INST     0xDF
#define BREAK_INST     RST18_INST
#define SSTEP_INSTR    BREAK_INST

/*
 * BUFMAX defines the maximum number of characters in inbound/outbound
 * buffers. At least NUMREGBYTES*2 are needed for register packets.
 */
#define BUFMAX 256

/* Z80 registers (should match the constants used in gdb  */

/* registers constants */
#define R_A     0
#define R_F     1

// 16 bit registers
#define R_BC    2
#define R_DE    4  
#define R_HL    6  
#define R_IX    8  
#define R_IY    10  
#define R_SP    12  

#define R_I     14
#define R_R     15

#define R_AX    16
#define R_FX    17
#define R_BCX   18
#define R_DEX   20
#define R_HLX   22

#define R_PC    24

/*
 * Number of bytes for registers
 */
#define NUMREGBYTES 26 // 6(1byte) + 10(2bytes)

/*
 * Forward declarations
 */
static int hex (char);
static char *mem2hex (char *, char *, int);
static char *hex2mem (char *, char *, int);
static int hexToInt (char **, int *);
static char *getpacket (void);
static void putpacket (char *);
static int computeSignal (int exceptionVector);
static void handle_exception (int exceptionVector);

int handle_monitor_command(char *cmdstr);
char read_port(char in_port) __naked;
void write_port(char out_port, char out_data) __naked;

void init_serial();

void putDebugChar (char);
char getDebugChar (void);

char cc_holds(char cond);

char payload_str[BUFMAX];

#define catch_exception_random catch_exception_255 /* Treat all odd ones like 255 */

void breakpoint() __naked;
void INIT ();

#define MONITOR_STACK_SIZE    1024
/* Z80 stack grows downwards (BOTTOM as in an abstract "stack", not
   as in memory address) */
#define MONITOR_STACK_BOTTOM  0xB000 // (MONITOR_STACK_SIZE + MONITOR_STACK)
#define Z80_NMI               0x66
#define Z80_RST18_VEC         8

short monitor_sp;

char intcause; /* TODO: initialize */
char in_nmi;   /* Set when handling an NMI, so we don't reenter */
int dofault;   /* Non zero, bus errors will raise exception */

char read_ch;  /* TODO: byte read from serial port, for now it's a global */

/* debug > 0 prints ill-formed commands in valid packets & checksum errors */
int remote_debug;

volatile struct {
  char a;
  char f;
  short bc;
  short de;
  short hl;
  short ix;
  short iy;
  short sp;
  char i;
  char r;
  char ax;
  char fx;
  short bcx;
  short dex;
  short hlx;
  short pc; } registers;

typedef struct
  {
    char *memAddr;
    char oldInstr;
  }
stepData;

stepData instrBuffer;
char stepped;
static const char hexchars[] = "0123456789abcdef";
static char remcomInBuffer[BUFMAX];
static char remcomOutBuffer[BUFMAX];

struct buffer
{
  void* base;
  int n_fetch;
  int n_used;
  signed char data[4];
} ;

struct tab_elt
{
  unsigned char val;
  unsigned char mask;
  void * (*fp)(void *pc, struct tab_elt *inst);
  unsigned char inst_len;
} ;

/* PSEUDO EVAL FUNCTIONS */
void *rst         (void *pc, const struct tab_elt *inst);
void *pref_cb     (void *pc, const struct tab_elt *inst);
void *pref_ed     (void *pc, const struct tab_elt *inst);
void *pref_ind    (void *pc, const struct tab_elt *inst);
void *pref_xd_cb  (void *pc, const struct tab_elt *inst);
void *pe_djnz     (void *pc, const struct tab_elt *inst);
void *pe_jp_nn    (void *pc, const struct tab_elt *inst);
void *pe_jp_cc_nn (void *pc, const struct tab_elt *inst);
void *pe_jp_hl    (void *pc, const struct tab_elt *inst);
void *pe_jr       (void *pc, const struct tab_elt *inst);
void *pe_jr_cc    (void *pc, const struct tab_elt *inst);
void *pe_ret      (void *pc, const struct tab_elt *inst);
void *pe_ret_cc   (void *pc, const struct tab_elt *inst);
void *pe_rst      (void *pc, const struct tab_elt *inst);
void *pe_dummy    (void *pc, const struct tab_elt *inst);
/* end of pseudo eval functions */

/* Table to disassemble machine codes without prefix.  */
const struct tab_elt opc_main[] =
{
  { 0x00, 0xFF, pe_dummy    ,  1 }, // "nop",           
  { 0x01, 0xCF, pe_dummy    ,  3 }, // "ld %s,0x%%04x", 
  { 0x02, 0xFF, pe_dummy    ,  1 }, // "ld (bc),a",     
  { 0x03, 0xCF, pe_dummy    ,  1 }, // "inc " ,         
  { 0x04, 0xC7, pe_dummy    ,  1 }, // "inc %s",        
  { 0x05, 0xC7, pe_dummy    ,  1 }, // "dec %s",        
  { 0x06, 0xC7, pe_dummy    ,  2 }, // "ld %s,0x%%02x", 
  { 0x07, 0xFF, pe_dummy    ,  1 }, // "rlca",          
  { 0x08, 0xFF, pe_dummy    ,  1 }, // "ex af,af'",     
  { 0x09, 0xCF, pe_dummy    ,  1 }, // "add hl,",       
  { 0x0A, 0xFF, pe_dummy    ,  1 }, // "ld a,(bc)" ,    
  { 0x0B, 0xCF, pe_dummy    ,  1 }, // "dec ",          
  { 0x0F, 0xFF, pe_dummy    ,  1 }, // "rrca",          
  { 0x10, 0xFF, pe_djnz     ,  2 }, // "djnz ",         
  { 0x12, 0xFF, pe_dummy    ,  1 }, // "ld (de),a",     
  { 0x17, 0xFF, pe_dummy    ,  1 }, // "rla",           
  { 0x18, 0xFF, pe_jr       ,  2 }, // "jr ",           
  { 0x1A, 0xFF, pe_dummy    ,  1 }, // "ld a,(de)",     
  { 0x1F, 0xFF, pe_dummy    ,  1 }, // "rra",           
  { 0x20, 0xE7, pe_jr_cc    ,  2 }, // "jr %s,",        
  { 0x22, 0xFF, pe_dummy    ,  3 }, // "ld (0x%04x),hl",
  { 0x27, 0xFF, pe_dummy    ,  1 }, // "daa",           
  { 0x2A, 0xFF, pe_dummy    ,  3 }, // "ld hl,(0x%04x)",
  { 0x2F, 0xFF, pe_dummy    ,  1 }, // "cpl",           
  { 0x32, 0xFF, pe_dummy    ,  3 }, // "ld (0x%04x),a", 
  { 0x37, 0xFF, pe_dummy    ,  1 }, // "scf",           
  { 0x3A, 0xFF, pe_dummy    ,  3 }, // "ld a,(0x%04x)", 
  { 0x3F, 0xFF, pe_dummy    ,  1 }, // "ccf",           
                                    //                  
  { 0x76, 0xFF, pe_dummy    ,  1 }, // "halt",          
  { 0x40, 0xC0, pe_dummy    ,  1 }, // "ld %s,%s",      
                                    //                  
  { 0x80, 0xC0, pe_dummy    ,  1 }, // "%s%s",          
                                    //                  
  { 0xC0, 0xC7, pe_ret_cc   ,  1 }, // "ret ",          
  { 0xC1, 0xCF, pe_dummy    ,  1 }, // "pop",           
  { 0xC2, 0xC7, pe_jp_cc_nn ,  3 }, // "jp ",           
  { 0xC3, 0xFF, pe_jp_nn    ,  3 }, // "jp 0x%04x",     
  { 0xC4, 0xC7, pe_jp_cc_nn ,  3 }, // "call ",         
  { 0xC5, 0xCF, pe_dummy    ,  1 }, // "push",          
  { 0xC6, 0xC7, pe_dummy    ,  2 }, // "%s0x%%02x",     
  { 0xC7, 0xC7, pe_rst      ,  1 }, // "rst 0x%02x",    
  { 0xC9, 0xFF, pe_ret      ,  1 }, // "ret",           
  { 0xCB, 0xFF, pref_cb     ,  2 }, // "",              
  { 0xCD, 0xFF, pe_jp_nn    ,  3 }, // "call 0x%04x",   
  { 0xD3, 0xFF, pe_dummy    ,  2 }, // "out (0x%02x),a",
  { 0xD9, 0xFF, pe_dummy    ,  1 }, // "exx",           
  { 0xDB, 0xFF, pe_dummy    ,  2 }, // "in a,(0x%02x)", 
  { 0xDD, 0xFF, pref_ind    ,  0 }, // "ix",            
  { 0xE3, 0xFF, pe_dummy    ,  1 }, // "ex (sp),hl",    
  { 0xE9, 0xFF, pe_jp_hl    ,  1 }, // "jp (hl)",
  { 0xEB, 0xFF, pe_dummy    ,  1 }, // "ex de,hl",      
  { 0xED, 0xFF, pref_ed     ,  0 }, // "",              
  { 0xF3, 0xFF, pe_dummy    ,  1 }, // "di",            
  { 0xF9, 0xFF, pe_dummy    ,  1 }, // "ld sp,hl",      
  { 0xFB, 0xFF, pe_dummy    ,  1 }, // "ei",            
  { 0xFD, 0xFF, pref_ind    ,  0 }, // "iy",            
  { 0x00, 0x00, pe_dummy    ,  1 }, // "????"
} ;

/* ED prefix opcodes table.
   Note the instruction length _doesn't_ include the ED prefix)
*/
const struct tab_elt opc_ed[] =
{
  { 0x70, 0xFF, pe_dummy, 1 }, // "in f,(c)"       
  { 0x70, 0xFF, pe_dummy, 1 }, // "xx"             
  { 0x40, 0xC7, pe_dummy, 1 }, // "in %s,(c)"      
  { 0x71, 0xFF, pe_dummy, 1 }, // "out (c),0"      
  { 0x70, 0xFF, pe_dummy, 1 }, // "xx"             
  { 0x41, 0xC7, pe_dummy, 1 }, // "out (c),%s"     
  { 0x42, 0xCF, pe_dummy, 1 }, // "sbc hl,"        
  { 0x43, 0xCF, pe_dummy, 3 }, // "ld (0x%%04x),%s"
  { 0x44, 0xFF, pe_dummy, 1 }, // "neg"            
  { 0x45, 0xFF, pe_ret  , 1 }, // "retn"           
  { 0x46, 0xFF, pe_dummy, 1 }, // "im 0"           
  { 0x47, 0xFF, pe_dummy, 1 }, // "ld i,a"         
  { 0x4A, 0xCF, pe_dummy, 1 }, // "adc hl,"        
  { 0x4B, 0xCF, pe_dummy, 3 }, // "ld %s,(0x%%04x)"
  { 0x4D, 0xFF, pe_ret  , 1 }, // "reti"           
  { 0x4F, 0xFF, pe_dummy, 1 }, // "ld r,a"         
  { 0x56, 0xFF, pe_dummy, 1 }, // "im 1"           
  { 0x57, 0xFF, pe_dummy, 1 }, // "ld a,i"         
  { 0x5E, 0xFF, pe_dummy, 1 }, // "im 2"           
  { 0x5F, 0xFF, pe_dummy, 1 }, // "ld a,r"         
  { 0x67, 0xFF, pe_dummy, 1 }, // "rrd"            
  { 0x6F, 0xFF, pe_dummy, 1 }, // "rld"            
  { 0xA0, 0xE4, pe_dummy, 1 }, // ""               
  { 0xC3, 0xFF, pe_dummy, 1 }, // "muluw hl,bc"    
  { 0xC5, 0xE7, pe_dummy, 1 }, // "mulub a,%s"     
  { 0xF3, 0xFF, pe_dummy, 1 }, // "muluw hl,sp"    
  { 0x00, 0x00, pe_dummy, 1 }  // "xx"             
};

/* table for FD and DD prefixed instructions */
const struct tab_elt opc_ind[] =
{
  { 0x24, 0xF7, pe_dummy   , 1 }, // "inc %s%%s"            
  { 0x25, 0xF7, pe_dummy   , 1 }, // "dec %s%%s"            
  { 0x26, 0xF7, pe_dummy   , 2 }, // "ld %s%%s,0x%%%%02x"   
  { 0x21, 0xFF, pe_dummy   , 3 }, // "ld %s,0x%%04x"        
  { 0x22, 0xFF, pe_dummy   , 3 }, // "ld (0x%%04x),%s"      
  { 0x2A, 0xFF, pe_dummy   , 3 }, // "ld %s,(0x%%04x)"      
  { 0x23, 0xFF, pe_dummy   , 1 }, // "inc %s"               
  { 0x2B, 0xFF, pe_dummy   , 1 }, // "dec %s"               
  { 0x29, 0xFF, pe_dummy   , 1 }, // "%s"                   
  { 0x09, 0xCF, pe_dummy   , 1 }, // "add %s,"              
  { 0x34, 0xFF, pe_dummy   , 2 }, // "inc (%s%%+d)"         
  { 0x35, 0xFF, pe_dummy   , 2 }, // "dec (%s%%+d)"         
  { 0x36, 0xFF, pe_dummy   , 3 }, // "ld (%s%%+d),0x%%%%02x"
                        
  { 0x76, 0xFF, pe_dummy   , 1 }, // "h"                    
  { 0x46, 0xC7, pe_dummy   , 2 }, // "ld %%s,(%s%%%%+d)"    
  { 0x70, 0xF8, pe_dummy   , 2 }, // "ld (%s%%%%+d),%%s"    
  { 0x64, 0xF6, pe_dummy   , 1 }, // "%s"                   
  { 0x60, 0xF0, pe_dummy   , 1 }, // "ld %s%%s,%%s"         
  { 0x44, 0xC6, pe_dummy   , 1 }, // "ld %%s,%s%%s"         
                        
  { 0x86, 0xC7, pe_dummy   , 2 }, // "%%s(%s%%%%+d)"        
  { 0x84, 0xC6, pe_dummy   , 1 }, // "%%s%s%%s"             
                            
  { 0xE1, 0xFF, pe_dummy   , 1 }, // "pop %s"               
  { 0xE5, 0xFF, pe_dummy   , 1 }, // "push %s"              
  { 0xCB, 0xFF, pref_xd_cb , 0 }, // "%s"                   
  { 0xE3, 0xFF, pe_dummy   , 1 }, // "ex (sp),%s"           
  { 0xE9, 0xFF, pe_dummy   , 1 }, // "jp (%s)"              
  { 0xF9, 0xFF, pe_dummy   , 1 }, // "ld sp,%s"             
  { 0x00, 0x00, pe_dummy   , 1 }, // "?"                    
};

void
INIT (void)
{
   __asm

     jp    _RESET
     nop
     nop
     nop
     nop
     nop
     push  hl               ;; RST 08, used for breakpoints
     ld    hl,#08           ;; 08 means a breakpoint was hit, pass it to sr routine
     jp    _sr              ;; TODO maybe change to saveRegisters, semantics

    __endasm;
}

void
RESET (void) __naked
{

#ifdef MONITOR
  reset_hook ();
#endif

  in_nmi = 0;
  dofault = 1;
  stepped = 0;

  breakpoint();

  while (1)
    ;
}

char highhex(int  x)
{
  return hexchars[(x >> 4) & 0xf];
}

char lowhex(int  x)
{
  return hexchars[x & 0xf];
}

/*
 * Routines to handle hex data
 */
static int
hex (char ch)
{
  if ((ch >= 'a') && (ch <= 'f'))
    return (ch - 'a' + 10);
  if ((ch >= '0') && (ch <= '9'))
    return (ch - '0');
  if ((ch >= 'A') && (ch <= 'F'))
    return (ch - 'A' + 10);
  return (-1);
}

/* convert the memory, pointed to by mem into hex, placing result in buf */
/* return a pointer to the last char put in buf (null) */
static char *
mem2hex (char *mem, char *buf, int count)
{
  int i;
  int ch;
  for (i = 0; i < count; i++)
    {
      ch = *mem++;
      *buf++ = highhex (ch);
      *buf++ = lowhex (ch);
    }
  *buf = 0;
  return (buf);
}

/* convert the hex array pointed to by buf into binary, to be placed in mem */
/* return a pointer to the character after the last byte written */

static char *
hex2mem (char *buf, char *mem, int count)
{
  int i;
  unsigned char ch;
  for (i = 0; i < count; i++)
    {
      ch = hex (*buf++) << 4;
      ch = ch + hex (*buf++);
      *mem++ = ch;
    }
  return (mem);
}

/**********************************************/
/* WHILE WE FIND NICE HEX CHARS, BUILD AN INT */
/* RETURN NUMBER OF CHARS PROCESSED           */
/**********************************************/
static int
hexToInt (char **ptr, int *intValue)
{
  int numChars = 0;
  int hexValue;

  *intValue = 0;

  while (**ptr)
    {
      hexValue = hex (**ptr);
      if (hexValue >= 0)
        {
          *intValue = (*intValue << 4) | hexValue;
          numChars++;
        }
      else
        break;

      (*ptr)++;
    }

  return (numChars);
}

/*
 * Routines to get and put packets
 */

/* scan for the sequence $<data>#<checksum>     */

char *
getpacket (void)
{
  unsigned char *buffer = &remcomInBuffer[0];
  unsigned char checksum;
  unsigned char xmitcsum;
  int count;
  char ch;

  while (1)
    {
      /* wait around for the start character, ignore all other characters */
      while ((ch = getDebugChar ()) != '$')
        ;

retry:
      checksum = 0;
      xmitcsum = -1;
      count = 0;

      /* now, read until a # or end of buffer is found */
      while (count < BUFMAX - 1)
        {
          ch = getDebugChar ();
          if (ch == '$')
            goto retry;
          if (ch == '#')
            break;
          checksum = checksum + ch;
          buffer[count] = ch;
          count = count + 1;
        }
      buffer[count] = 0;

      if (ch == '#')
        {
          ch = getDebugChar ();
          xmitcsum = hex (ch) << 4;
          ch = getDebugChar ();
          xmitcsum += hex (ch);

          if (checksum != xmitcsum)
            {
              putDebugChar ('-');       /* failed checksum */
            }
          else
            {
              putDebugChar ('+');       /* successful transfer */

              /* if a sequence char is present, reply the sequence ID */
              if (buffer[2] == ':')
                {
                  putDebugChar (buffer[0]);
                  putDebugChar (buffer[1]);

                  return &buffer[3];
                }

              return &buffer[0];
            }
        }
    }
}


/* send the packet in buffer. */

static void
putpacket (char *buffer)
{
  int checksum;

  /*  $<packet info>#<checksum>. */
  do
    {
      char *src = buffer;
      putDebugChar ('$');
      checksum = 0;

      while (*src)
        {
          int runlen;

          /* Do run length encoding */
          for (runlen = 0; runlen < 100; runlen ++) 
            {
              if (src[0] != src[runlen]) 
                {
                  if (runlen > 3) 
                    {
                      int encode;
                      /* Got a useful amount */
                      putDebugChar (*src);
                      checksum += *src;
                      putDebugChar ('*');
                      checksum += '*';
                      checksum += (encode = runlen + ' ' - 4);
                      putDebugChar (encode);
                      src += runlen;
                    }
                  else
                    {
                      putDebugChar (*src);
                      checksum += *src;
                      src++;
                    }
                  break;
                }
            }
        }


      putDebugChar ('#');
      putDebugChar (highhex(checksum));
      putDebugChar (lowhex(checksum));
    }
  while  (getDebugChar() != '+');
}


/*
 * This function translates the trap (intcause) into a unix compatible
 * signal value.
 */
static int
computeSignal (int exceptionVector)
{
  int sigval;
  switch (exceptionVector)
    {
    case Z80_NMI:
      sigval = 5; 
      break;

    case Z80_RST18_VEC:
      sigval = 5;
      break;

    default:
      sigval = 7;               /* "software generated"*/
      break;
    }
  return (sigval);
}

void
doSStep (void)
{
  char *instrMem;
  char *nextInstrMem;
  unsigned short opcode;

  struct tab_elt *p;

  instrMem = (char *) registers.pc;

  opcode = *instrMem;
  stepped = 1;

  for (p = opc_main; p->val != (opcode & p->mask); ++p)
    ;

  nextInstrMem = (char *) p->fp(instrMem, p);

  instrMem = nextInstrMem;
  instrBuffer.memAddr = instrMem;
  instrBuffer.oldInstr = *instrMem;
  *instrMem = SSTEP_INSTR;
}


/* Undo the effect of a previous doSStep.  If we single stepped,
   restore the old instruction. */
void
undoSStep (void)
{
  if (stepped)
    { char *instrMem;
      instrMem = instrBuffer.memAddr;
      *instrMem = instrBuffer.oldInstr;
    }
  stepped = 0;
}

/*
This function does all exception handling.  It only does two things -
it figures out why it was called and tells gdb, and then it reacts
to gdb's requests.

When in the monitor mode we talk a human on the serial line rather than gdb.

*/
void
gdb_handle_exception (int exceptionVector)
{
  int sigval, stepping;
  int addr, length;
  char *ptr;

  /* reply to host that an exception has occurred */
  sigval = computeSignal (exceptionVector);
  remcomOutBuffer[0] = 'S';
  remcomOutBuffer[1] = highhex(sigval);
  remcomOutBuffer[2] = lowhex (sigval);
  remcomOutBuffer[3] = 0;

  putpacket (remcomOutBuffer);

  /*
   * Exception 0x08 means a RST 18 instruction (breakpoint) inserted in
   * place of code
   * 
   * Backup PC by one instruction, this instruction will later
   * be replaced by the original instruction at the breakpoint
   */
  if (exceptionVector == 0x08)
    registers.pc -= 1;

  /*
   * Do the thangs needed to undo
   * any stepping we may have done!
   */
  undoSStep ();

  stepping = 0;

  while (1)
    {
      remcomOutBuffer[0] = 0;
      ptr = getpacket ();

      switch (*ptr++)
        {
        case '?':
          remcomOutBuffer[0] = 'S';
          remcomOutBuffer[1] = highhex (sigval);
          remcomOutBuffer[2] = lowhex (sigval);
          remcomOutBuffer[3] = 0;
          break;
        case 'd':
          remote_debug = !(remote_debug);       /* toggle debug flag */
          break;
        case 'g':               /* return the value of the CPU registers */
          mem2hex ((char *) registers, remcomOutBuffer, NUMREGBYTES);
          break;
        case 'G':               /* set the value of the CPU registers - return OK */
          hex2mem (ptr, (char *) registers, NUMREGBYTES);
          strcpy (remcomOutBuffer, "OK");
          break;

          /* mAA..AA,LLLL  Read LLLL bytes at address AA..AA */
        case 'm':
          dofault = 0;
          /* TRY, TO READ %x,%x.  IF SUCCEED, SET PTR = 0 */
          if (hexToInt (&ptr, &addr))
            if (*(ptr++) == ',')
              if (hexToInt (&ptr, &length))
                {
                  ptr = 0;
                  mem2hex ((char *) addr, remcomOutBuffer, length);
                }
          if (ptr)
            strcpy (remcomOutBuffer, "E01");

          break;

          /* MAA..AA,LLLL: Write LLLL bytes at address AA.AA return OK */
        case 'M':
          /* TRY, TO READ '%x,%x:'.  IF SUCCEED, SET PTR = 0 */
          if (hexToInt (&ptr, &addr))
            if (*(ptr++) == ',')
              if (hexToInt (&ptr, &length))
                if (*(ptr++) == ':')
                  {
                    hex2mem (ptr, (char *) addr, length);
                    ptr = 0;
                    strcpy (remcomOutBuffer, "OK");
                  }
          if (ptr)
            strcpy (remcomOutBuffer, "E02");

          break;

          /* cAA..AA    Continue at address AA..AA(optional) */
          /* sAA..AA   Step one instruction from AA..AA(optional) */
        case 's':
          stepping = 1;
        case 'c':
          {
            /* tRY, to read optional parameter, pc unchanged if no parm */
            if (hexToInt (&ptr, &addr))
              registers.pc = addr;
              //registers[R_PC] = addr;
            if (stepping)
              doSStep ();
          }
          return;
          break;

          /* kill the program */
        case 'k':               /* do nothing */
          break;

        case 'q':
          /* is this a monitor command? */
          // if (!strncmp("qRcmd", ptr, strlen("qRcmd")))
          if (*ptr=='R')
            {
              if (!handle_monitor_command(ptr + strlen("Rcmd,")))
                {
                  // monitor command was sucessful. 
                  // handle_monitor_command wrote an Output response to the
                  // command in remcomOutBuffer, so we send it now.
                  putpacket(remcomOutBuffer);

                  // then we set up another OK packet which will be
                  // sent as the final response packet.
                  strcpy (remcomOutBuffer, "OK");
                }
              else
                strcpy (remcomOutBuffer, "E01");
            }
          break;
        }                       /* switch */

      /* reply to the request */
      putpacket (remcomOutBuffer);
    }
}

#define GDBCOOKIE 0x5ac 
static int ingdbmode;
void handle_exception(int exceptionVector)
{
  gdb_handle_exception (exceptionVector);
}

void
gdb_mode (void)
{
  ingdbmode = GDBCOOKIE;
  breakpoint();
}
/* This function will generate a breakpoint exception.  It is used at the
   beginning of a program to sync up with a debugger and can be used
   otherwise as a quick means to stop program execution and "break" into
   the debugger. */
void
breakpoint (void) __naked
{
  __asm              
  nop                
  nop                
  nop                
  rst 0x18             
  nop                
  nop                
  jp  __clock   /* TODO: b000? */     
  nop                
  nop                
  __endasm;          
}

void 
sr() __naked
 {
   /* saveRegisters routine */
  saveRegisters:
   __asm
     ld    (#_intcause), hl          ;; argument passed in hl signals the exception cause

     pop   hl                        ;; recover original hl before hitting the breakpoint
     ld    (#_registers + R_HL), hl

     pop  hl                         ; get the PC saved as the returned address when the breakpoint hit
     ld   (#_registers + R_PC), hl
     push hl


    ;;; REMINDER  we need to save AF before using add hl,sp or some other flag modifying instruction.
    ;;; TRTD would be to save it in some variable instead of using the user stack.

     push  af                        ;; preserve AF since add hl, sp will mess the flags
     ld    hl,#0000                  ;; save the stack pointer
     add   hl, sp
     inc   hl                        ;; take into account the "extra" push generated
     inc   hl                        ;; by the breakpoint trap.
     inc   hl                        ;; and the extra push generated by the previous push af
     inc   hl                                     
     ld    (#_registers + R_SP), hl
     pop   af                        ;; restore AF


     ;; swap in the monitor stack
     ld   sp, #MONITOR_STACK_BOTTOM

     push  af                        ;; dirty trick to save AF
     pop   hl
     ld    a,h
     ld    (#_registers + R_A), a   
     ld    a,l
     ld    (#_registers + R_F), a    

     ld    (#_registers + R_BC), bc
     ld    (#_registers + R_DE), de
     ld    (#_registers + R_IX), ix
     ld    (#_registers + R_IY), iy

     ;; save I and R
     push  af
     ld    a, i
     ld    (#_registers + R_I), a    ; yes, A
     ld    a, r
     ld    (#_registers + R_R), a    ; yes, A
     pop   af


     ;; alternate register set
     exx
     ex   af,af'                     ;;'

     ld    (#_registers + R_HLX), hl

     push  af ;; dirty trick to save AF
     pop   hl
     ld    a,h
     ld    (#_registers + R_AX), a   
     ld    a,l
     ld    (#_registers + R_FX), a    

     ld    (#_registers + R_BCX), bc
     ld    (#_registers + R_DEX), de

     ;; switch back to original reg set
     ex   af,af'                     ;;'
     exx




     ld    hl, (#_intcause)
     push  hl
     call  _handle_exception              
     pop   af      
     jp    _rr
   __endasm;

 }

 void rr() __naked
 {
   __asm
     ld    a, (#_registers + R_A) ;; restore AF
     ld    b, a
     ld    a, (#_registers + R_F)
     ld    c, a
     push  bc                              
     pop   af

     ld    hl, (#_registers + R_HL)
     ld    bc, (#_registers + R_BC)      
     ld    de, (#_registers + R_DE)          
     ld    ix, (#_registers + R_IX)      
     ld    iy, (#_registers + R_IY)          

     ;; restore I and R
     push  af
     ld    a, (#_registers + R_I)
     ld    i, a
     ld    a, (#_registers + R_R)
     ld    r, a
     pop   af                     ;; do not forget to restore A and F

     exx
     ex    af, af'                         ;'

     ld    a, (#_registers + R_AX) ;; restore AFX
     ld    b, a
     ld    a, (#_registers + R_FX)
     ld    c, a
     push  bc
     pop   af

     ld    hl, (#_registers + R_HLX)
     ld    bc, (#_registers + R_BCX)      
     ld    de, (#_registers + R_DEX)          

     ;; switch back to original reg set
     ex    af, af'                         ;'
     exx             

                                           ; TODO: consider never restoring the SP, it is safer for the debugger
     ld    hl, (#_registers + R_SP)        ; restore the stack pointer
     push  af                              ; do not overwrite the restored AF
     dec   hl                              ; remember we lied to the client by not taking
     dec   hl                              ; the extra push generated by the breakpoint trap
     pop   af                          
                                           ; (see the saveRegister (sr) routine)
     ld    sp, hl

     ;; put the (new?) PC back in the stack as the return address
     ld    hl, (#_registers + R_PC)
     ex    (sp), hl
     ld    hl, (#_registers + R_HL)

     ;; we might have interrupted the inferior with a NMI,
     ;; so we use retn just in case.
     out (NMI_FF_CLR), a ;; clear the external NMI FF
     retn
  __endasm;
}

void 
handleError (char theSSR);

void 
init_serial (void)
{
	/* no need to do anything here */
}

int
getDebugCharReady (void)
{
	/* always ready */
	return 1;
}

char 
getDebugChar (void)
{
	char read_ch;
	
	while (rs232_getb(&read_ch));

	return read_ch;
}

int 
putDebugCharReady (void)
{
	/* PC always ready to receive */
 	return 1;
}

void
putDebugChar (char ch)
{
	while (!putDebugCharReady());
	rs232_putb(ch);  
	return;
}

void 
handleError (char theSSR)
{
  theSSR=theSSR;
  // SSR1 &= ~(SCI_ORER | SCI_PER | SCI_FER);
}

// --------------------

static void *
pe_dummy (void *pc, const struct tab_elt *inst)
{
  char *cpc = (char *)pc;
  return (cpc + inst->inst_len);
}

void *
pe_rst (void *pc, const struct tab_elt *inst)
{
  char *cpc = (char *)pc;
  char opcode = *cpc;
  
  char rst_mask            = ~(inst->mask);
  unsigned char rst        = (opcode & rst_mask);
  unsigned char target_rst = (rst >> 3) & 0x07;
  
  return (target_rst * 8);
}

void *
pref_cb (void *pc, const struct tab_elt *inst)
{
  char *cpc = (char *)pc;
  // all CB prefixed instructions have the same length (2 bytes)
  return (cpc + inst->inst_len);
}

void *
pref_ind (void *pc, const struct tab_elt *inst)
{
  struct tab_elt *p;
  char *cpc = (char *)pc;

  for (p = opc_ind; p->val != (cpc[1] & p->mask); ++p)
    ;
  return (cpc + 
          1   + // FD or DD  prefix
          p->inst_len);
}

void *
pref_xd_cb (void *pc, const struct tab_elt *inst)
{
  char *cpc = (char *)pc;
  return cpc + inst->inst_len;
}

static void *
pref_ed (void *pc, const struct tab_elt *inst)
{
  struct tab_elt *p;
  char *cpc = (char *)pc;

  for (p = opc_ed; p->val != (cpc[1] & p->mask); ++p)
    ;
  return (cpc + 
          1   + // ED prefix
          p->inst_len);
}
// -------------------- 

//---------- CONTROL JUMP INSTRUCTIONS PSEUDO EVAL FUNCTIONS ----------
void *
pe_djnz (void *pc, const struct tab_elt *inst)
{
  char *cpc = (char *)pc;
  short b = ((unsigned short)registers.bc >> 8);

  if (b - 1 == 0)
    return (cpc + inst->inst_len); 
  else
    {    // result of dec wasn't Z, so we jump e
      short e = cpc[1];
      return (cpc + e + 2);
    }
}

void *
pe_jp_nn (void *pc, const struct tab_elt *inst)
{
  char *cpc = (char *)pc;
  short nn  = *(short *)(cpc+1); // immediate nn for the jp
  return (nn);
}

void *
pe_jp_cc_nn (void *pc, const struct tab_elt *inst)
{
  char *cpc = (char *)pc;
  short e = 0;

  char opcode = *cpc;
  char condition_mask = ~(inst->mask);
  unsigned char condition = (opcode & condition_mask);
  condition = (condition >> 3) & 0x07;

  if (cc_holds(condition))
    {
      // jump is effective
      // pc will jump to the immediate address
      return pe_jp_nn(pc, inst);
    }
  else
    { // conditional jump won't take place
      // move PC to the next instruction
      return (cpc + inst->inst_len);
    }
}

void *
pe_jp_hl (void *pc, const struct tab_elt *inst)
{
  char *jp_addr  = (char *) registers.hl;
  return (jp_addr);
}

void *
pe_jr (void *pc, const struct tab_elt *inst)
{
  char *cpc = (char *)pc;
  int e =  cpc[1]; //  relative offset for the jump
  return (cpc + e + 2);
}

// condition codes values (000, 001, 010, ... 111)
enum { 
  cond_NZ, 
  cond_Z, 
  cond_NC,
  cond_C,
  cond_PO,
  cond_PE,
  cond_P,
  cond_M
};

char cc_holds(char cond)
{
// Z80 FLAG BITFIELD: SZ5H3PNC
#define SIGN_FLAG_MASK     0x80 // (1 << 7) 
#define ZERO_FLAG_MASK     0x40 // (1 << 6) 
#define PARITY_FLAG_MASK   0x04 // (1 << 2) 
#define CARRY_FLAG_MASK    0x01 // (1 << 0)  

  char flags = registers.f;
  char holds = 0;
  switch (cond)
    {
    case cond_NZ:
      holds = !(flags & ZERO_FLAG_MASK);
      break;
    case cond_Z:
      holds =  (flags & ZERO_FLAG_MASK);
      break;
    case cond_NC:
      holds = !(flags & CARRY_FLAG_MASK);
      break;
    case cond_C:
      holds =  (flags & CARRY_FLAG_MASK);
      break;
    case cond_PO:
      holds = !(flags & PARITY_FLAG_MASK);
      break;
    case cond_PE:
      holds =  (flags & PARITY_FLAG_MASK);
      break;
    case cond_P:
      holds = !(flags & SIGN_FLAG_MASK);
      break;
    case cond_M:
      holds =  (flags & SIGN_FLAG_MASK);
      break;
    }
  return holds;
}

void *
pe_jr_cc (void *pc, const struct tab_elt *inst)
{
  char *cpc = (char *)pc;
  short e = 0;

  char opcode = *cpc;
  char condition_mask = ~(inst->mask);
  unsigned char condition = (opcode & condition_mask);
  condition = (condition >> 3) & 0x07;

  if (cc_holds(condition))
    {
      // jump is effective
      e =  cpc[1]; //  relative offset for the jump
    }

  return (cpc + e + 2);
}

void *
pe_ret (void *pc, const struct tab_elt *inst)
{
  void *ret_addr = (void *) *((short *)registers.sp); // get the return address from the TOS
  return ret_addr;
}

void *
pe_ret_cc (void *pc, const struct tab_elt *inst)
{
  char *cpc = (char *)pc;
  char opcode = *cpc;
  char condition_mask = ~(inst->mask);
  unsigned char condition = (opcode & condition_mask);
  condition = (condition >> 3) & 0x07;
  
  if (cc_holds(condition))
    {
      // ret is effective
      return pe_ret(pc, inst);
    }
  else
    { // conditional ret won't take place
      // move PC to the next instruction
      return (cpc + inst->inst_len);
    }
}

int
handle_monitor_command(char *qRcmd_payload)
{
  /* build the command string from the qRcmd message payload */
  // char payload_str[BUFMAX];
  char *cmdstr = payload_str;
  hex2mem(qRcmd_payload, payload_str, BUFMAX);
  
  
  /* 
     Try to parse an "in" command.  An "in" command format is "in
     (0xHH)" where H is an hex digit.
  */
  if (!strncmp("in ", cmdstr, strlen("in ")))
    {
      cmdstr += strlen("in ");
      while (*cmdstr == ' ') cmdstr++; // ignore extra whitespace
      
      if (!strncmp("(0x", cmdstr, strlen("(0x"))) // starts with "(0x"
        {
          int in_port;
          cmdstr += strlen("(0x");
          if (hexToInt(&cmdstr, &in_port)) // a two hex digit port address was read
            {
              char in_data = read_port((char)in_port);
              char in_data_hex[3];

              remcomOutBuffer[0] = 'O';
              mem2hex(&in_data, in_data_hex, 1);           // the byte read, in ascii hex
              mem2hex("read: 0x", remcomOutBuffer+1, 8);
              mem2hex(in_data_hex, remcomOutBuffer+17, 2); // asci_hex(asci_hex(byte_read))
              mem2hex("\n", remcomOutBuffer+21, 1);        // traling new line
              remcomOutBuffer[23]='\0';                    // null char terminate
              return 0;
            }
        }
    } // end of IN command

  if (!strncmp("out ", cmdstr, strlen("out ")))
    {
      cmdstr += strlen("out ");
      while (*cmdstr == ' ') cmdstr++; // ignore extra whitespace
      
      if (!strncmp("(0x", cmdstr, strlen("(0x"))) // starts with "(0x"
        {
          int out_port;
          cmdstr += strlen("(0x");
          if (hexToInt(&cmdstr, &out_port)) // a two hex digit port address was read
            {
              // ignore trailing ' )' and extra whitespace and comma
              while (*++cmdstr == ' ' || *cmdstr == ','); 
              
              if (!strncmp("0x", cmdstr, strlen("0x"))) // out value starts with 0x
                {
                  int out_data;
                  cmdstr += strlen("0x");
                  hexToInt(&cmdstr, &out_data);
                  write_port((char)out_port, (char)out_data);
                }

              strcat(remcomOutBuffer, "OK");
              return 0;
            }
        }
    } // end of OUT command


 error:  
  // strcpy (remcomOutBuffer, "E01");
  return 1;
}

char
read_port(char in_port) __naked
{
  __asm
    push ix
    ld  ix,#0 
    add ix,sp

    push bc
    push af

    ;; get the port from the stack
    

    ld b, #0
    ld c, 4 (ix)
    ;; ld c, #0x90

    ;; read that port and return it in l
    in l, (c)

    pop af
    pop bc

    pop ix
    ret

  __endasm;
}

void
write_port(char out_port, char out_data) __naked
{
  __asm
    push ix    
    ld   ix, #0
    add  ix, sp

    push bc
    push af
    
    ;; get the port argument
    ld c, 4 (ix)
    
    ;; get the data to write
    ld a, 5 (ix)

    ;; write the data to the out port     
    ld b, #0
    out (c), a

    pop af
    pop bc

    pop ix
    ret

  __endasm;
}


/* pacify the compiler */
void 
main () {}

/* Local Variables: */
/* compile-command: "make -k" */
/* End: */
