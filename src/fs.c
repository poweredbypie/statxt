#include "fs.h"
#include "util.h"

// errno (duh)
#include <errno.h>
// exit
#include <stdlib.h>
// chdir
#include <unistd.h>

void cd_fatal(const char* path) {
    if (chdir(path) != 0) {
        err("Couldn't enter directory (%s)\n", path);
        exit(errno);
    }
}

bool enum_dir(const char* path, FSEnumCallback callback) {
    DIR* dir = opendir(path);
    if (dir == NULL) {
        err("Couldn't open directory (%s)\n", path);
        exit(errno);
    }
    cd_fatal(path);

    struct dirent* entry = NULL;
    struct stat info;
    while ((entry = readdir(dir))) {
        if (stat(entry->d_name, &info) != 0) {
            err("Couldn't stat file (%s)\n", entry->d_name);
            continue;
        }
        // I'm going to assume the name isn't of length 0
        if (entry->d_name[0] == '.') {
            // Ignore '.' and '..'
            continue;
        }

        if (callback(entry, &info)) {
            return true;
        }
    }

    closedir(dir);

    return false;
}

// Returns a file as a byte buffer.
// May return NULL!
// Buffer must be freed by the caller.
char* file_to_str(const char* path) {
    FILE* file = fopen(path, "rb");
    if (file == NULL) {
        err("Couldn't open file (%s)\n", path);
        return NULL;
    }

    struct stat info;
    if (stat(path, &info) != 0) {
        err("Couldn't stat file (%s)\n", path);
        exit(errno);
    }

    off_t size = info.st_size;
    rewind(file);

    char* str = malloc(sizeof(char) * size);
    // stat - too big!
    // fseek - too small!
    // So we have to use fread's result and realloc.
    size = fread(str, sizeof(char), size, file);
    str = realloc(str, size + 1);
    // Null terminate the string.
    str[size] = 0;
    fclose(file);
    return str;
}
