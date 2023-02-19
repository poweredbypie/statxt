const c = @cImport({
    @cInclude("stdio.h");
    @cInclude("sys/stat.h");
});

const Self = @This();

path: []const u8,
file: *c.FILE,

pub fn init(path: []const u8) ?Self {
    // Currently I only read from files so it's always `rb`.
    const file = c.fopen(path.ptr, "rb") orelse return null;
    return Self{ .path = path, .file = file };
}

pub fn size(self: *const Self) usize {
    var stats: c.struct_stat = undefined;
    _ = c.stat(self.path.ptr, &stats);

    return @intCast(usize, stats.st_size);
}

pub fn read(self: *Self, buf: []u8) void {
    _ = c.fread(buf.ptr, 1, buf.len, self.file);
}

pub fn deinit(self: *Self) void {
    _ = c.fclose(self.file);
}
