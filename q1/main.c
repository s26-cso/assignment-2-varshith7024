#include <stdio.h>

typedef struct Node
{
    int val;
    struct Node *left;
    struct Node *right;
} Node;

Node *make_node(int val);
Node *insert(Node *root, int val);
Node *get(Node *root, int val);
int getAtMost(int val, struct Node *root);

int main()
{
    Node *node = make_node(42);
    node = insert(node, 46);
    node = insert(node, 40);
    node = insert(node, 30);
    node = insert(node, 35);
    printf("%d\n", node->val);                    // 42
    printf("%d\n", node->left->val);              // 40
    printf("%d\n", node->right->val);             // 46
    printf("%d\n", node->left->left->right->val); // 35
    Node *test1 = get(node, 35);
    Node *test2 = get(node, 100);
    printf("%d\n", test1->val);          // 35
    printf("%p\n", test2);               // (nil)
    printf("%d\n", getAtMost(37, node)); // 35
    printf("%d\n", getAtMost(20, node)); // -1
    printf("%d\n", getAtMost(42, node)); // 42
}