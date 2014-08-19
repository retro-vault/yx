typedef struct window_s {
	string title;
	rectangle_t* window_rectangle;
	window_t* first_child;
	window_t* next_sibling;
	window_t* parent;
	(word))(*window_procedure)(window_t *me, word msg, word p1, word p2)); 
	...
} window_t;