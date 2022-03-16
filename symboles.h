#define TAILLE 1000

typedef struct symbole {
    char nomVariable[16];
    char typeVariable[16];
    int declare;
    int profondeur;
} symbole;

symbole* init();

void print_table(symbole* tab);
void print_symbole(symbole s);

void ajouter_symbole(symbole* tab, symbole s);
void supprimer_symbole(symbole* tab);

