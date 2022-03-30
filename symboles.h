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
int get_taille_ts();

int ajouter_symbole(symbole* tab, char* nom, char* typ, int declare);
void supprimer_symbole(symbole* tab);

int get_addr(symbole* ts, char* nom);
int depiler_addr(symbole* tab);
symbole depiler_symbole(symbole* tab);

void inc_depth();
void dec_depth();
