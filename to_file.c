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
	}
}

// Returns the op code
char get_op_code(instruction i) {

	switch(i.nomInstruction) {
		
		case 'ADD':
			return '1';
		case 'MUL':
			return '2';
		case 'SOU':
			return '3';
		case 'DIV':
			return '4';
		case 'COP':
			return '5';
		case 'AFC':
			return '6';
		case 'JMP':
			return '7';
		case 'JMF':
			return '8';
		case 'INF':
			return '9';
		case 'SUP':
			return 'A';
		case 'EQU':
			return 'B';
		case 'PRI':
			return 'C';
	}
}

// Converts intruction into the corresponding string
char * ti_to_string(instruction i) {
	
	char * string = malloc(100);
	char op_code = get_op_code(i);
	sprintf(string, "%c %s %s %s", op_code, i.arg1, i.arg2, i.arg3);
	
	return string;
	}
}