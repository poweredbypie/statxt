# statxt
This is the old version of statxt, which I called "piebar" (ew).
This one is written in C and uses Nix.

I'm leaving this here for archival purposes, and also to compare binary size.
This comes out to around 14 KB, stripped, which is still much larger than the Zig version.

## Building
I use Nix to build this:
```sh
nix build .
```
You can also just use a regular C compiler:
```sh
clang src/*.c -o piebar
```
