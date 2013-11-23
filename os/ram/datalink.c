/*
 *	datalink.c
 *	data link protocol
 *
 *	tomaz stih tue jul 31 2012
 */
#include "main.h"

byte dl_next_response=DL_ACK;   /* next response, assume ack */
byte dl_oseq=1, dl_iseq=0;      /* input and output sequence number */
dl_link_t *dl_link_first=NULL;  /* pointer to first link */

/*
 * connect to datalink
 */
dl_link_t *dl_link_connect(void *owner, word ibuffer_size) {

	dl_link_t *l;

	if ( l = (dl_link_t *)syslist_add((void **)&dl_link_first, sizeof(dl_link_t), owner) ) {
		/* populate link */
		l->pending_reads=NULL;
		l->pending_writes=NULL;
	}

	return l;
}

/*
 * disconnect from data link
 */
dl_link_t *dl_link_disconnect(dl_link_t *l) {
	return (dl_link_t *)syslist_delete((void **)&dl_link_first, (void *)l);
}

#ifdef _YES
result dl_loop() {

	result oresult, iresult:

	dl_frame_header_t ofhdr, ifhdr;
	dl_frame_body_t ofbody, ifbody;

	/*
	 * first send data
	 */
	ofhdr.sequence=dl_oseq; /* current sequence */
	if (que_is_empty(iq)) {	/* no data to send */
		ofhdr.response=dl_next_response | DL_YOU; /* create a "you" block */
		oresult = dl_send(&ofhdr,NULL, DL_TIMEOUT_HEADER);
	} else {
		ofhdr.response=dl_next_response & (~DL_YOU); /* not a "you" block */
		que_peek_bytes(iq, ofbody.data, FRAME_LEN, &(obody.size));
		oresult = dl_send(&ofhdr,&ofbody, DL_TIMEOUT_HEADER + DL_TIMEOUT_BODY);
	}

	/* TODO: what if? */
	if (oresult==RESULT_DL_TIMEOUT) {
	}

	/*
	 * now receive data
	 */
	iresult = dl_receive(&ifhdr, sizeof(dl_frame_header_t), DL_TIMEOUT_HEADER);
	if (iresult==RESULT_SUCCESS) { /* got header */
		if (ifhdr.response & DL_ACK) { /* conclude previous block !!! */
			dl_oseq++; /* increase output sequence */
			que_consume_bytes(iq,obody.size);
		}
		if (!(ifhdr.response & DL_YES)) {
			iresult = dl_receive(&ifbody, sizeof(dl_frame_body_t), DL_TIMEOUT_BODY);
			if (iresult==RESULT_SUCCESS) {
				if (dl_check_data(&ifbody)) {
					dl_next_response=DL_ACK;
					que_append(oq, ifbody.data, ifbody.size);
				} else {
					dl_next_response=DL_NAK;
				}
			} else
				dl_next_response=DL_NAK; /* request resend */
		}
	}
}

void dl_send(dl_frame_header_t *hdr, dl_frame_body_t *body) {
	/* calc crc */
}
#endif
