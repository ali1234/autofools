#include <stdio.h>

#include "libfoo.h"
#include "libbar.h"

void bar(void)
{
    printf("calling lib1\n");
    foo();
}
