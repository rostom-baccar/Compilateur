#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symboles.h"

int taille = 0;
int profondeurMAX = 0;

symbole* init_ts() {
    return malloc(TAILLE*sizeof(symbole*));
}


void print_ts(symbole* tab) {
    int i = 0;
    for (i; i < taille; i++) {
        print_symbole(tab[i]);
        printf("\n");
    }
}

void print_symbole(symbole s) {
    printf("%s (%s, %d, %d) ", s.nomVariable, s.typeVariable, s.declare, s.profondeur);
}

void ajouter_symbole(symbole* tab, char* nom, char* type, int decl, int prof) {
    if (taille >= TAILLE) printf("TAILLE MAXIMALE DEPASSEE\n");
    symbole s = {declare:0, profondeur:prof};
    strcpy(s.nomVariable, nom);
    strcpy(s.typeVariable, type);
    tab[taille] = s;
    taille++;
}

void supprimer_symbole(symbole * tab) {
    int i = 0;
    int nb = 0;
    for (i; i < taille; i++) {
        symbole s = tab[i];
        if (s.profondeur == profondeurMAX) {
            nb++;
        }
    }
    taille -= nb;
}

symbole depiler(symbole *tab) {
    symbole retour = tab[taille];
    taille--;
    return retour;
}

symbole ajouter_tmp(symbole* tab, int profondeur) {

    ajouter_symbole(tab, "tmp", "tmp", profondeur, 0);
    taille++;
    return tab[taille];
}

int get_addr(symbole* tab, char* nom) {
    int i = 0;
    for (i; i < taille; i++) {
        if (tab[i].nomVariable == nom) {
            return i;
        }
    }
}





