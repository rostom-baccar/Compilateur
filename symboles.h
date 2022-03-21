#define TAILLE 1000

typedef struct symbole {
    char nomVariable[16];
    char typeVariable[16];
    int declare;
    int profondeur;
} symbole;

symbole* init_ts();

void print_ts(symbole* tab);
void print_symbole(symbole s);

void ajouter_symbole(symbole* tab, char* nom, char* typ, int declare, int profondeur);
void supprimer_symbole(symbole* tab);
symbole depiler(symbole* tab);

symbole ajouter_tmp(symbole* tab, int prof);
int get_addr(symbole* ts, char* nom);

