#ifndef DICTIONARY_H
#define DICTIONARY_H

typedef struct {
	int row;
	char label[500];
}Element;

typedef struct {
	int number_of_elements;
	int max;
	struct Element* list;
}Dictionary;

Element* allocate();//checked
void destroy(Element* e);//checked
void init_element(Element* e, int row, char* label);//checked
Dictionary* allocatedict();//checked
void destroydict(Dictionary* dictionary);//checked
void init_dictionary(Dictionary* dictionary, int size);//checked
void add_element(Dictionary* dictionary, Element* element);//checked
int get_row_number(Dictionary* dictionary, char* label);//checked
void get_line(Dictionary* dictionary, int row_number, char* line);//checked
void update_line(Dictionary* dictionary, int row_number, char* line);//checked

#endif 

