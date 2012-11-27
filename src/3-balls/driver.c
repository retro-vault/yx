/*
 *	driver.c
 *	device drivers
 *
 *	tomaz stih tue may 29 2012
 */
#include "yeah.h"

driver_t *drv_first;

/*
 * register a driver
 */
result drv_register(
	uint8_t id0, uint8_t id1, uint8_t id2,							
	word (*open)(driver_t *drv, uint8_t *hint, uint16_t attr),	
	void (*close)(word handle),									
	result (*read_async)(word handle, uint8_t *buffer, uint16_t count, event_t *done),
	result (*write_async)(word handle, uint8_t *buffer, uint16_t count, event_t *done),
	result (*ioctl)(word handle, uint8_t fn, uint16_t data),
	void (*timer_hook)(),
	void (*init_fn)(driver_t *drv)
	) {

	driver_t *d=mem_allocate(sizeof(driver_t),KALLOC);
	d->id0=id0;
	d->id1=id1;
	d->id2=id2;
	d->open=open;
	d->close=close;
	d->read_async=read_async;
	d->write_async=write_async;
	d->ioctl=ioctl;
	d->timer_hook=timer_hook;
	d->next=drv_first;
	drv_first=d;

	if (init_fn) init_fn(d);

	/* install timer */
	tmr_install(timer_hook,EVERYTIME);
}

/*
 * find a driver
 */
driver_t *drv_query(uint8_t id0, uint8_t id1, uint8_t id2) {
	driver_t *d=NULL;
	driver_t *iter=drv_first;

	while (!d && iter) 
		if (iter->id0==id0 && iter->id1==id1 && iter->id2==id2)
			d=iter;
		else
			iter=iter->next;

	return d;
}
