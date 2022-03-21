#define TAILLE 1000

typedef struct instruction {
    char nomInstruction[16];
    int arg1;
    int arg2;
    int arg3;
} instruction;

instruction* init_ti();

void print_ti(instruction* tab);
void print_instruction(instruction i);

void ajouter_instruction(instruction* tab, char* nom, int arg1, int arg2, int arg3);

