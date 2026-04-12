#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>

int main()
{
    char operand[6];
    int num1, num2;

    while (1)
    {
        scanf("%s %d %d", operand, &num1, &num2);

        char libname[32];
        snprintf(libname, sizeof(libname), "lib%s.so", operand);

        void *handle = dlopen(libname, RTLD_LAZY);

        dlerror();

        int (*operation)(int, int);
        *(void **)(&operation) = dlsym(handle, operand);

        int result = operation(num1, num2);
        printf("%d\n", result);

        dlclose(handle);
    }
}