#define _CRT_SECURE_NO_WARNINGS

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "number_converter.h"
#include "code_converter.h"
#include "dictionary.h"




void mainjh() {
	Element* e = allocate();
	init_element(e, 10, "l1");
	Element* e2 = allocate();
	init_element(e2, 21, "liu11");
	Dictionary* d = allocatedict();
	init_dictionary(d, 10);
	add_element(d, e);
	add_element(d, e2);
	char line[100];
	destroy(e);
	get_line(d, 10, line);
	printf("%s",line);
}

int checkcomment(char line[]) {
	int i = 0;
	while (line[i] != '\0') {
		if (line[i] == '#') {
			return 1;
		}
		i++;
	}
	return 0;
}


void remove_comment(char line[]) {//checked/
	char* no_comments;
	no_comments = strtok(line, "#");
	strcpy(line, no_comments);
}

 

void mainnb() {
	
	char line[100] = " .word 4093 7 ";
	char hex[30];
	int j = checkwordrow(line);
	int num = address_word(line);
	data_word(line, hex);
	printf("is it: %d  address: %d  data: %s", j, num, hex);
	
	

}

void mainyp() {
	char line[100] = "    out $zero, $zero, $imm2,$imm1,1,2";
}



void readfile(char* filename, Dictionary* assembly) {//works
	FILE* filepointer;
	filepointer = fopen(filename, "r");
	char line[500];
	int i = 0;
	int counter=0;
	while (!feof(filepointer)) {
		fgets(line, 500, filepointer);
		if (checkcomment(line) == 1) {
			remove_comment(line);
			strcat(line, "\n");
		}
		if (line[0] == '\0') {
			counter++;
		}
		printf("%s", line);
		Element* row = allocate();
		init_element(row, i, line);
		add_element(assembly, row);
		i++;
	}
	printf("%d\n", counter);
	fclose(filepointer);
}

void writefile(char* filename, Dictionary* instructions) {//works
	FILE* filepointer;
	filepointer = fopen(filename, "w");
	char line[500];
	Element* list = instructions->list;
	for (int i = 0; i < instructions->number_of_elements; i++) {
		strcpy(line, list[i].label);
		strcat(line, "\n");
		fprintf(filepointer, line);
	}
	fclose(filepointer);
	
}

void main() {//fix and finish.
	Dictionary* assembly = allocatedict();
	init_dictionary(assembly, 4096);
	Dictionary* labels = allocatedict();
	init_dictionary(labels, 4096);
	Dictionary* instructions = allocatedict();
	init_dictionary(instructions, 4096);
	Dictionary* memory = allocatedict();
	init_dictionary(memory, 4096);
	readfile("disktest.asm",assembly);
	create_label_dictionary(assembly, labels, memory);
	char line[500];
	Element* list = memory->list;
	for (int i = 0; i < memory->number_of_elements; i++) {
		strcpy(line, list[i].label);
		strcat(line, "\n");
		printf("%s", line);
	}
	assemble(assembly, labels, instructions, memory);
	writefile("imemin.txt", instructions);
	writefile("dmemin.txt", memory);
	destroydict(assembly);
	destroydict(labels);
	destroydict(instructions);
	destroydict(memory);

}
	
