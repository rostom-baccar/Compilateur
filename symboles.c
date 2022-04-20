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

char * ajouter_symbole(symbole* tab, char* nom, char* type, int decl) {
    if (taille >= TAILLE) printf("TAILLE MAXIMALE DEPASSEE\n");
    symbole s = {declare:decl, profondeur:profondeurMAX};
    strcpy(s.nomVariable, nom);
    strcpy(s.typeVariable, type);
    tab[taille] = s;
    taille++;
    
    char * taille_addr = malloc(3);
    sprintf(taille_addr, "%d", taille-1);
    
    return taille_addr;
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

char * depiler_addr(symbole* tab) {
    if (taille == 0) {exit(-1);}
    taille--;
    
    char * taille_addr = malloc(3);
    sprintf(taille_addr, "%d", taille);
    return taille_addr;
}

// nécessaire pour update adresse retour du jump
symbole depiler_symbole(symbole* tab) {
    if (taille == 0) {exit(-1);}
    taille--;
    return tab[taille];
}


char * get_addr(symbole* tab, char* nom) {
    int i;
    for (i=0; i < taille; i++) {
        
        if (strcmp(tab[i].nomVariable, nom) == 0) {
            char * i_addr = malloc(3);
            sprintf(i_addr, "%d", i);
            return i_addr;
        }
    }

    return "-1";
}




void inc_depth() {
    profondeurMAX++;
}
void dec_depth() {
    profondeurMAX-- ;
}

