#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "instructions.h"


int taille_ti = 0;

instruction* init_ti() {
    return malloc(TAILLE*sizeof(instruction));
}


void print_ti(instruction* tab) {
    int i;
    for (i=0; i < taille_ti; i++) {
        print_instruction(tab[i], i);
        printf("\n");
    }
}

void print_instruction(instruction i, int indice) {
    printf("%d - %s %d, %d, %d", indice, i.nomInstruction, i.arg1, i.arg2, i.arg3);
}

int get_taille_ti() {
    return taille_ti;
}

void ajouter_instruction(instruction* tab, char* nom, int arg1, int arg2, int arg3) {
    if (taille_ti >= TAILLE) printf("TAILLE MAXIMALE DEPASSEE\n");
    instruction i = {arg1:arg1, arg2:arg2, arg3:arg3};
    strcpy(i.nomInstruction, nom);
    tab[taille_ti] = i;
    taille_ti++;
}






