#ifndef CODE_CONVERTER_H
#define CODE_CONVERTER_H
#include "dictionary.h"

void assreg(char name[], char* tr);//checked
void asscode(char name[], char* tr);//checked
void assrow(char row[], char* str,Dictionary* labels);//checked without imm.
int checklabelrow(char row[]);//checked
int checkwordrow(char row[]);// checked
int address_word(char row[]);///checked
void data_word(char row[], char* data);//checked
void remove_whitespace(char* text);//checked
void create_label_dictionary(Dictionary* assembly, Dictionary* labels, Dictionary* memory);// seams fine
void assemble(Dictionary* assembly, Dictionary* labels, Dictionary* instructions, Dictionary* memory);//ook.


#endif 
