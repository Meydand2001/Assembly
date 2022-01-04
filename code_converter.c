#define _CRT_SECURE_NO_WARNINGS

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "number_converter.h"
#include "code_converter.h"
#include "dictionary.h"

void assreg(char name[], char* tr) {
	if (strcmp(name, "$zero") == 0) {
		strcpy(tr, "0000");
	}
	else if (strcmp(name, "$imm1") == 0) {
		strcpy(tr, "0001");
	}
	else if (strcmp(name, "$imm2") == 0) {
		strcpy(tr, "0010");
	}
	else if (strcmp(name, "$v0") == 0) {
		strcpy(tr, "0011");
	}
	else if (strcmp(name, "$a0") == 0) {
		strcpy(tr, "0100");
	}
	else if (strcmp(name, "$a1") == 0) {
		strcpy(tr, "0101");
	}
	else if (strcmp(name, "$a2") == 0) {
		strcpy(tr, "0110");
	}
	else if (strcmp(name, "$t0") == 0) {
		strcpy(tr, "0111");
	}
	else if (strcmp(name, "$t1") == 0) {
		strcpy(tr, "1000");
	}
	else if (strcmp(name, "$t2") == 0) {
		strcpy(tr, "1001");
	}
	else if (strcmp(name, "$s0") == 0) {
		strcpy(tr, "1010");
	}
	else if (strcmp(name, "$s1") == 0) {
		strcpy(tr, "1011");
	}
	else if (strcmp(name, "$s2") == 0) {
		strcpy(tr, "1100");
	}
	else if (strcmp(name, "$gp") == 0) {
		strcpy(tr, "1101");
	}
	else if (strcmp(name, "$sp") == 0) {
		strcpy(tr, "1110");
	}
	else if (strcmp(name, "$ra") == 0) {
		strcpy(tr, "1111");
	}
}

void asscode(char name[], char* tr) {
	if (strcmp(name, "add") == 0) {
		strcpy(tr, "00000000");
	}
	else if (strcmp(name, "sub") == 0) {
		strcpy(tr, "00000001");
	}
	else if (strcmp(name, "mac") == 0) {
		strcpy(tr, "00000010");
	}
	else if (strcmp(name, "and") == 0) {
		strcpy(tr, "00000011");
	}
	else if (strcmp(name, "or") == 0) {
		strcpy(tr, "00000100");
	}
	else if (strcmp(name, "xor") == 0) {
		strcpy(tr, "00000101");
	}
	else if (strcmp(name, "sll") == 0) {
		strcpy(tr, "00000110");
	}
	else if (strcmp(name, "sra") == 0) {
		strcpy(tr, "00000111");
	}
	else if (strcmp(name, "srl") == 0) {
		strcpy(tr, "00001000");
	}
	else if (strcmp(name, "beq") == 0) {
		strcpy(tr, "00001001");
	}
	else if (strcmp(name, "bne") == 0) {
		strcpy(tr, "00001010");
	}
	else if (strcmp(name, "blt") == 0) {
		strcpy(tr, "00001011");
	}
	else if (strcmp(name, "bgt") == 0) {
		strcpy(tr, "00001100");
	}
	else if (strcmp(name, "ble") == 0) {
		strcpy(tr, "00001101");
	}
	else if (strcmp(name, "bge") == 0) {
		strcpy(tr, "00001110");
	}
	else if (strcmp(name, "jal") == 0) {
		strcpy(tr, "00001111");
	}
	else if (strcmp(name, "lw") == 0) {
		strcpy(tr, "00010000");
	}
	else if (strcmp(name, "sw") == 0) {
		strcpy(tr, "00010001");
	}
	else if (strcmp(name, "reti") == 0) {
		strcpy(tr, "00010010");
	}
	else if (strcmp(name, "in") == 0) {
		strcpy(tr, "00010011");
	}
	else if (strcmp(name, "out") == 0) {
		strcpy(tr, "00010100");
	}
	else if (strcmp(name, "halt") == 0) {
		strcpy(tr, "00010101");
	}
}

int checklabelrow(char row[]) {
	char coprow[100];
	strcpy(coprow, row);
	int i = 0;
	while (coprow[i] != '\0') {
		if (coprow[i] == ':') {
			return 1;
		}
		i++;
	}
	return 0;
}


int checkwordrow(char row[]) { // word impact
	char coprow[100];
	strcpy(coprow, row);
	char* opcode = strtok(coprow," ");
	remove_whitespace(opcode);
	if (strcmp(opcode, ".word") == 0) {
		return 1;
	}
	return 0;
}



void create_label_dictionary(Dictionary* assembly, Dictionary* labels, Dictionary* memory) {
	char line[500];
	char* label;
	char* no_label;
	int programcounter = 0;
	int address;
	int maxaddress = 0;
	for (int i = 0; i < assembly->number_of_elements; i++) {//better to check the -1
		get_line(assembly, i, line);
		//printf("%s\n", line);
		if (checklabelrow(line) != 1 && checkwordrow(line) != 1) {
			programcounter++;
		}
		else if (checklabelrow(line) == 1) {
			label = strtok(line, ":");
			no_label = strtok(NULL, "\n");
			//update_line(assembly, i, no_label);
			Element* e = allocate();
			init_element(e, programcounter, label);
			printf("row: %d , content: %s\n", e->row, e->label);
			add_element(labels, e);
		}
		else {
			address = address_word(line);
			if (address > maxaddress) {
				maxaddress = address;
			}
		}
	}
	for (int j = 0; j <= maxaddress; j++) {
		Element* e2 = allocate();
		init_element(e2, j, "00000000");
		//printf("row: %d , content: %s\n", e2->row, e2->label);
		add_element(memory, e2);
	}
}

int address_word(char row[]) { // word impact
	char coprow[100];
	strcpy(coprow, row);
	char* piece = strtok(coprow, " ");
	piece = strtok(NULL, " ");
	remove_whitespace(piece);
	int address;
	if (checkbase(piece) == 10) {
		 address = atoi(piece);
	}
	else {
		address = hex2num(piece);
	}
	return address;
	//  if base decimal atoi else hex to dec.
}

void data_word(char row[], char* data) {
	char coprow[100];
	char str[100];
	//char hex[12];
	strcpy(coprow, row);
	char* piece = strtok(coprow, " ");
	piece = strtok(NULL, " ");
	piece = strtok(NULL, "\n");
	printf("%s\n", piece);
	remove_whitespace(piece);
	convert_word(piece, str);
	printf("%s\n", str);
	bin2hex(str, data, 8);
}



void assemble(Dictionary* assembly, Dictionary* labels, Dictionary* instructions,Dictionary* memory) {
	char line[500];
	char str[100];
	char hex[20];
	int address;
	printf("assemble\n");
	Element* e = allocate();
	for (int i = 0; i < assembly->number_of_elements; i++) {//better to check the -1
		get_line(assembly, i, line);
		printf("%s\n", line);
		if (checkwordrow(line) == 1) {
			address = address_word(line);
			data_word(line, hex);
			//init_element(e, address, hex);
			//printf("row: %d , content: %s\n", e->row, e->label);
			update_line(memory, address, hex);
			//add_element(memory, e);
		}
		else if(checklabelrow(line) != 1) {
			assrow(line, str, labels);
			printf("%s\n", str);
			bin2hex(str, hex, 12);
			printf("%s\n", hex);
			//printf("%s\n", hex);
			//Element* e2 = allocate();
			init_element(e, i, hex);
			printf("row: %d , content: %s\n", e->row, e->label);
			add_element(instructions, e);
		}
		else {

		}
	}
}


int checkwhitespace(char line[]) {
	int i = 0;
	while (line[i] != NULL || line[i] != '\0') {
		if (line[i] == ' ' || line[i] =='	') {
			return 1;
		}
		i++;
	}
	return 0;
}

void remove_whitespace(char* text) {
	int i = 0;
	int	j = 0;
	while (text[i] != '\0')
	{
		if (text[i] != ' ' && text[i] != '	') {
			text[j] = text[i];
			j++;
		}
		i++;
	}
	text[j] = '\0';
}

void assrow(char row[], char* str,Dictionary* labels) {
	char coprow[200];
	strcpy(coprow, row);
	char* piece = strtok(coprow, " ");
	if (checkwhitespace(piece) == 1) {
		remove_whitespace(piece);
	}
	printf("%s\n", piece);
	char tr[200] = "";
	asscode(piece, tr);
	strcpy(str, tr);
	for (int i = 1; i < 6; i++) {
		piece = strtok(NULL, ",");
		if (checkwhitespace(piece) == 1) {
			remove_whitespace(piece);
		}
		printf("%s\n", piece);
		if (piece != NULL) {
			if (i < 5) {
				assreg(piece, tr);
				strcat(str, tr);
			}
			else {
				convert(piece,tr,labels);
				strcat(str, tr);
			}
		}
	}
	piece = strtok(NULL,"\n");
	if (checkwhitespace(piece) == 1) {
		remove_whitespace(piece);
	}
	printf("%s\n", piece);
	if (piece != NULL) {
		convert(piece, tr, labels);
		strcat(str, tr);
	}
}
