#ifndef FS_H
#define FS_H

// directory iteration
#include <dirent.h>
// stat (duh)
#include <sys/stat.h>
// bool, true, false
#include <stdbool.h>

typedef bool(* FSEnumCallback)(struct dirent*, struct stat*);

void cd_fatal(const char* path);
bool enum_dir(const char* path, FSEnumCallback callback);
char* file_to_str(const char* path);

#endif
