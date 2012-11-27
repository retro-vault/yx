/*
 *	driver.h
 *	device drivers 
 *
 *	tomaz stih tue may 29 2012
 */
#ifndef _DRIVER_H
#define _DRIVER_H

struct driver_s {
	uint8_t id0; 
	uint8_t id1; 
	uint8_t id2;							
	word (*open)(struct driver_s *drv, uint8_t *hint, uint16_t attr);
	void (*close)(word handle);				
	result (*read_async)(word handle, uint8_t *buffer, uint16_t count, event_t *done);
	result (*write_async)(word handle, uint8_t *buffer, uint16_t count, event_t *done);
	result (*ioctl)(word handle, uint8_t fn, uint16_t data);
	void (*timer_hook)();
	struct driver_s *next;
};

typedef struct driver_s driver_t;

extern driver_t *drv_first;

extern result drv_register(
	uint8_t id0, uint8_t id1, uint8_t id2,							
	word (*open)(driver_t *drv, uint8_t *hint, uint16_t attr),	
	void (*close)(word handle),									
	result (*read_async)(word handle, uint8_t *buffer, uint16_t count, event_t *done),
	result (*write_async)(word handle, uint8_t *buffer, uint16_t count, event_t *done),
	result (*ioctl)(word handle, uint8_t fn, uint16_t data),
	void (*timer_hook)(),
	void (*init_fn)(driver_t *drv)
	);
extern driver_t *drv_query(uint8_t id0, uint8_t id1, uint8_t id2);

/*
 * TODO: implement
 */
extern result drv_unregister(uint8_t id0, uint8_t id1, uint8_t id2);

#endif
