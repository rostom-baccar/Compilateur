#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symboles.h"

int taille = 0;
int profondeurMAX = 0;

/*
int main() {

    symbole * ts = init_ts();
    depiler(ts);
    symbole s1 = ajouter_tmp(ts);
    depiler(ts);
    symbole s2 = ajouter_tmp(ts);
    symbole s3 = ajouter_tmp(ts);
    depiler(ts);
    ajouter_symbole(ts, "a", "int", 0);
    ajouter_symbole(ts, "b", "int", 0);
    depiler(ts);
    symbole s4 = ajouter_tmp(ts);
    symbole s5 = ajouter_tmp(ts);
    
    print_ts(ts);
}*/

symbole* init_ts() {
    return malloc(TAILLE*sizeof(symbole*));
}


void print_ts(symbole* tab) {
    int i;
    for (i=0; i < taille; i++) {
        print_symbole(tab[i]);
        printf("\n");
    }
}

int get_taille_ts() {
    return taille;
}

void print_symbole(symbole s) {
    printf("%s (%s, %d, %d) ", s.nomVariable, s.typeVariable, s.declare, s.profondeur);
}

int ajouter_symbole(symbole* tab, char* nom, char* type, int decl) {
    if (taille >= TAILLE) printf("TAILLE MAXIMALE DEPASSEE\n");
    symbole s = {declare:decl, profondeur:profondeurMAX};
    strcpy(s.nomVariable, nom);
    strcpy(s.typeVariable, type);
    tab[taille] = s;
    taille++;
    return taille;
}

void supprimer_symbole(symbole * tab) {
    int i;
    int nb = 0;
    for (i=0; i < taille; i++) {
        symbole s = tab[i];
        if (s.profondeur == profondeurMAX) {
            nb++;
        }
    }
    taille -= nb;
}

int depiler_addr(symbole* tab) {
    taille--;
    
    return taille + 1;
}

// nécessaire pour update adresse retour du jump
symbole depiler_symbole(symbole* tab) {
    taille--;
    return tab[taille];
}


int get_addr(symbole* tab, char* nom) {
    int i;
    for (i=0; i < taille; i++) {
        
        if (strcmp(tab[i].nomVariable, nom) == 0) {
            return i;
        }
    }
    
    //if (strcmp("a", nom) == 0) {return 99;}
    return -1;
}




void inc_depth() {
    profondeurMAX++;
}
void dec_depth() {
    profondeurMAX-- ;
}

