pub const print = @cImport({
    @cInclude("stdio.h");
}).printf;
