word send_message(window_t *window, word msg, word p1, word p2) {
	if (is_window(window)) {
		return window->wndproc(window,msg,p1,p2);
	}
}

/* message loop */
while (get_message(&m) && m.code!=MSG_QUIT) 
	dispatch_message(m);
