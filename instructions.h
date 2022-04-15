#define TAILLE 1000

typedef struct instruction {
    char nomInstruction[16];
    char arg1[3];
    char arg2[3];
    char arg3[3];
} instruction;

instruction* init_ti();

void print_ti(instruction* tab);
void print_instruction(instruction i, int indice);

void ajouter_instruction(instruction* tab, char* nom, char* arg1, char* arg2, char* arg3);
int get_taille_ti();

char * ti_to_string(instruction i);
char * ti_to_string(instruction i);
char get_op_code(instruction i);
void write_from_table(instruction * ti);
