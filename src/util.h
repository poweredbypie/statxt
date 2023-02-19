#ifndef UTIL_H
#define UTIL_H

// fprintf, stderr
#include <stdio.h>

#define err(...) \
    do { \
        fprintf(stderr,  __VA_ARGS__); \
    } while (0)

#endif
