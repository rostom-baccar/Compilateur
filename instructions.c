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
    printf("%d - %s %s %s %s", indice, i.nomInstruction, i.arg1, i.arg2, i.arg3);
}

int get_taille_ti() {
    return taille_ti;
}

void ajouter_instruction(instruction* tab, char* nom, char * arg1, char * arg2, char * arg3) {
    if (taille_ti >= TAILLE) printf("TAILLE MAXIMALE DEPASSEE\n");
    instruction i;
    strcpy(i.nomInstruction, nom);
    strcpy(i.arg1, arg1);
    strcpy(i.arg2, arg2);
    strcpy(i.arg3, arg3);
    tab[taille_ti] = i;
    taille_ti++;
}

// Avoir stdlib
void write_from_table(instruction * ti) {
	
	FILE * fPtr;

	fPtr = fopen("asm.txt", "w");

	if(fPtr == NULL) {
        	printf("Unable to create file.\n");
        	exit(EXIT_FAILURE);
    	}
	
	int i;
	for (i=0; i<taille_ti; i++) {
		fputs(ti_to_string(ti[i]), fPtr);
		fputs("\n", fPtr);
	}
}

// Returns the op code
// Can't do switch because name is char * not char [clown emoji]
char get_op_code(instruction i) {

	if (strcmp(i.nomInstruction, "ADD") == 0) {
	    return '1';
	}
	else if (strcmp(i.nomInstruction, "MUL") == 0) {
	    return '2';
	}
	else if (strcmp(i.nomInstruction, "SOU") == 0) {
	    return '3';
	}
	else if (strcmp(i.nomInstruction, "DIV") == 0) {
	    return '4';
	}
	else if (strcmp(i.nomInstruction, "COP") == 0) {
	    return '5';
	}
	else if (strcmp(i.nomInstruction, "AFC") == 0) {
	    return '6';
	}
	else if (strcmp(i.nomInstruction, "JMP") == 0) {
	    return '7';
	}
	else if (strcmp(i.nomInstruction, "JMF") == 0) {
	    return '8';
	}
	else if (strcmp(i.nomInstruction, "INF") == 0) {
	    return '9';
	}
	else if (strcmp(i.nomInstruction, "SUP") == 0) {
	    return 'A';
	}
	else if (strcmp(i.nomInstruction, "EQU") == 0) {
	    return 'B';
	}
	else if (strcmp(i.nomInstruction, "PRI") == 0) {
	    return 'C';
	}
	else {
        return '_';
	}
	
}

// Converts intruction into the corresponding string
char * ti_to_string(instruction i) {
	
	char * string = malloc(100);
	char op_code = get_op_code(i);
	sprintf(string, "%c %s %s %s", op_code, i.arg1, i.arg2, i.arg3);
	
	return string;
}






