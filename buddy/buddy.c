/*
 *	buddy.c
 *	desktop for buddy
 *
 *	tomaz stih mon oct 14 2013
 */
#include <sdl.h>
 
int main(int argc, char *argv[]) {
    SDL_Init(SDL_INIT_VIDEO);

    SDL_Window *window = SDL_CreateWindow(
        "Zx Spectrum 48k",
        SDL_WINDOWPOS_CENTERED,
        SDL_WINDOWPOS_CENTERED,
        255, 192, 0
    );

    SDL_Delay(3000);
    SDL_DestroyWindow(window);
    SDL_Quit();
    return 0;
}