const c = @cImport({
    @cInclude("errno.h");
    @cInclude("stdlib.h");
    @cInclude("string.h");
});

pub fn contains(str: []const u8, substr: []const u8) bool {
    const ptr = c.strstr(str.ptr, substr.ptr);
    return (ptr != null);
}

pub fn find(str: []const u8, char: u8) ?usize {
    const ptr = c.strchr(str.ptr, char);
    if (ptr == null) {
        return null;
    }

    // This is kind of goofy but I think it's better than raw pointers.
    const idx = ptr - @ptrToInt(str.ptr);
    return @ptrToInt(idx);
}

pub fn toInt(str: []const u8) i32 {
    const num = c.strtol(str.ptr, null, 10);
    return @intCast(i32, num);
}
