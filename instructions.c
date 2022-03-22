#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "instructions.h"

/*
int main() {
    instruction* tab;
    tab = init();
    
    ajouter_instruction(tab, "MOV", 0, 0, 1);
    ajouter_instruction(tab, "MOV", 0, 2, 3);
    
    print_table(tab);
    
    return 0;
}
*/

instruction* init_ti() {
    return malloc(TAILLE*sizeof(instruction*));
}


void print_ti(instruction* tab) {
    int i;
    for (i=0; i < taille; i++) {
        print_instruction(tab[i]);
        printf("\n");
    }
}

void print_instruction(instruction i) {
    printf("%s %d, %d, %d", i.nomInstruction, i.arg1, i.arg2, i.arg3);
}

void ajouter_instruction(instruction* tab, char* nom, int arg1, int arg2, int arg3) {
    if (taille >= TAILLE) printf("TAILLE MAXIMALE DEPASSEE\n");
    instruction i = {arg1:arg1, arg2:arg2, arg3:arg3};
    strcpy(i.nomInstruction, nom);
    tab[taille] = i;
    taille++;
}



