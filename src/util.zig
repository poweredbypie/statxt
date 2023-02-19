const linux = @import("linux");
const File = linux.fs.File;
const mem = linux.mem;

pub fn fileToSlice(path: []const u8) ?[]u8 {
    if (File.init(path)) |file| {
        defer file.deinit();
        if (mem.alloc(u8, file.size())) |block| {
            file.read(block);
            return block;
        }
    }

    return null;
}
