		;;	libex.s
		;;	extra functions, usually provided by SDCC
		;;
		;;	tomaz stih sun jul 26 2015
		.module crt0

		.globl __sdcc_call_hl

		.area	_CODE

__sdcc_call_hl::
		jp	(hl)
