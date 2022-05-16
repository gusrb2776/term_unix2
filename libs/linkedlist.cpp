#include <linkedlist.h>
#include <stdlib.h>
#include <string.h>

static Node* _head = NULL;
static Node* _tail = NULL;
static Node* _cur_node = NULL;

bool empty()
{
    return _head == NULL;
}

size_t size()
{
    Node* it = NULL;
    size_t count = 0;
    if(_head == NULL) return 0;
    
    it = _head;
    count = 1;
    while(it != _tail){
        ++count;
        it = it->next;
    }

    return count;
}

void print()
{
    //TODO: IMPL
}

void print_file(FILE* stream)
{
    //TODO: IMPL
}

void clear()
{
    Node* it = NULL;
    if(_tail == NULL) return;

    it = _tail;
    while(it != _head){
        it = it->prev;
        free(it->next->data);
        free(it->next);
    }
    free(it->data);
    free(it);

    _tail = NULL;
    _head = NULL;
}

static Node* createNode(size_t n, char new_data[n])
{
    Node* new_node = (Node*)malloc(sizeof(Node));
    new_node->next = NULL;
    new_node->data = (char*)malloc(sizeof(char) * n);
    strncpy(new_node->data, new_data, n);
    new_node->prev = NULL;
}

Node* append_left(size_t n, char new_data[n])
{
    Node* new_node = createNode(n, new_data);
    if(empty()){
        _tail = new_node;
    }else{
        _head->prev = new_node;
        new_node->next = _head;
    }
    _head = new_node;
    return new_node;
}

Node* insert_after(Node* cur_node, Node* new_node)
{
    //TODO: IMPL
    return NULL;
}

Node* append(size_t n, char new_data[n])
{
    //TODO: IMPL
    return NULL;
}

Node* delete_node(Node* cur_node)
{
    //TODO: IMPL
    return NULL;
}

Node* delete(char* data)
{
    //TODO: IMPL
    return NULL;
}

Node* get_node(size_t index)
{
    //TODO: IMPL
    return NULL;
}

Node* first()
{
    //TODO: IMPL
    return NULL;
}

Node* last()
{
    //TODO: IMPL
    return NULL;
}

Node* next()
{
    //TODO: IMPL
    return NULL;
}

Node* prev()
{
    //TODO: IMPL
    return NULL;
}
