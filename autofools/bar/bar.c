#include <stdio.h>

#include "../foo/foo.h"
#include "bar.h"

void bar(void)
{
    printf("calling lib1\n");
    foo();
}
