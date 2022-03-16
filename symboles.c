#include <stdio.h>
#include <stdlib.h>
#include "symboles.h"

int taille = 0;
int profondeurMAX = 0;

int main() {
    symbole* tab;
    tab = init();
    int a = 2;
    int b;
        
    
    symbole s1 = {nomVariable:"a", typeVariable:"int", declare:0, profondeur:1};
    ajouter_symbole(tab, s1);
    
    symbole s2 = {nomVariable:"b", typeVariable:"char", declare:1, profondeur:0};
    ajouter_symbole(tab, s2);
    
    print_table(tab);
    supprimer_symbole(tab);
    print_table(tab);
    
    return 0;
}

symbole* init() {
    return malloc(TAILLE*sizeof(symbole*));
}


void print_table(symbole* tab) {
    int i = 0;
    for (i; i < taille; i++) {
        print_symbole(tab[i]);
        printf("\n");
    }
}

void print_symbole(symbole s) {
    printf("%s (%s, %d, %d) ", s.nomVariable, s.typeVariable, s.declare, s.profondeur);
}

void ajouter_symbole(symbole* tab, symbole s) {
    if (taille >= TAILLE) printf("TAILLE MAXIMALE DEPASSEE\n");
    if (s.profondeur >= profondeurMAX) {profondeurMAX++;}
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


int get_addr(symbole* tab, char* nom) {
    int i = 0;
    for (i; i < taille; i++) {
        if (tab[i].nomVariable == nom) {
            return i;
        }
    }
}





