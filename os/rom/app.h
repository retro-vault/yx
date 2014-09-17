/*
 *	app.h
 *	yx application 
 *
 *	tomaz stih wed sep 17 2014
 */
#ifndef _APP_H
#define _APP_H

/*
 * header of application file 
 */
typedef struct app_file_hdr_s {
	byte s;			/* 'A' */
	byte i;			/* 'P' */
	byte g;			/* 'P' */
	word stack_size;	/* stack size */
	word entry_point;	/* app entry point */
	word rel_entries;	/* number of relocation entries */
	word rel_table[0];
} app_file_hdr_t;

/*
 * application entry
 */
typedef struct app_s {
	list_header_t hdr;
	app_file_hdr_t *app_file_hdr;
	task_t *main_thread;
	msg_queue_t *mq;
} app_t;

/* 
 * relocate app, return absolute entry point
 */
extern word app_relocate(app_file_hdr_t *app_file_hdr);

#endif
