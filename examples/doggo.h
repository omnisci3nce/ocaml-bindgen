typedef enum breed {
    Labrador,
    _GoldenRetriever,
    pug,
    _poodle
} breed;

typedef struct Doggo {
    int many;
    breed breed;
    char wow;
    float weight;
    char* nicknames[4];
} Doggo;

void eleven_out_of_ten_majestic_af(Doggo* pupper);

void no_input_no_output(void);