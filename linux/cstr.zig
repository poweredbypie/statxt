const c = @cImport({
    @cInclude("errno.h");
    @cInclude("stdlib.h");
    @cInclude("string.h");
});

pub fn contains(str: []const u8, substr: []const u8) bool {
    return (c.strstr(str.ptr, substr.ptr) != null);
}

pub fn find(str: []const u8, char: u8) ?usize {
    if (c.strchr(str.ptr, char)) |ptr| {
        // This is kind of goofy but I think it's better than raw pointers.
        const idx = ptr - @ptrToInt(str.ptr);
        return @ptrToInt(idx);
    }

    return null;
}

pub fn toInt(str: []const u8) i32 {
    return @intCast(i32, c.strtol(str.ptr, null, 10));
}
