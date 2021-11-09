void main() {
    // Create pointer of character and point to first cell of video memory;
    char* video_memory = (char*) 0xb8000;

    // Set pointer to 'X', ie set first cell to 'X'
    *video_memory = 'X';
}
