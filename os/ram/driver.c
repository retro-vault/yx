/*
 *	driver.c
 *	device drivers
 *
 *	tomaz stih sun may 12 2013
 */
#include "yx.h"

driver_t *drv_first=NULL;

/*
 * register a driver
 */
driver_t *drv_register(
	string name,
	handle_t *(*open)(struct driver_s *d, byte *hint, word attr),
	void (*close)(handle_t *h),		
	byte (*read_async)(handle_t *handle, byte *buffer, word count, event_t *done),
	byte (*write_async)(handle_t *handle, byte *buffer, word count, event_t *done),
	byte (*ioctl)(handle_t *handle, byte fn, word data),
	void (*timer_hook)()
) {
	name_t *n;
	driver_t *d;
	timer_t *t;

	if ( d = (driver_t *)syslist_add((void **)&drv_first, sizeof(driver_t), SYS) ) {
		d->open=open;
		d->close=close;
		d->read_async=read_async;
		d->write_async=write_async;
		d->ioctl=ioctl;
		/* install timer */
		if (timer_hook) {
			if (!(t=tmr_install(timer_hook,EVERYTIME,SYS))) {
				/* failed */
				syslist_delete((void **)&drv_first, (void *)d);
				return NULL;
			}
		} 
		/* link driver name if linking requested */
		if (!name_link(SYS, name, d)) {
			syslist_delete((void **)&drv_first, (void *)d);
			tmr_uninstall(t);
			return NULL;
		}
	}
	return d;
}
