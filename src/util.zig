const linux = @import("linux");
const File = linux.fs.File;
const mem = linux.mem;

pub fn fileToSlice(path: []const u8) ?[]u8 {
    var file = File.init(path) orelse return null;
    defer file.deinit();

    var block = mem.alloc(u8, file.size()) orelse return null;
    file.read(block);
    return block;
}
