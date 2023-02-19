const linux = @import("linux");
const File = linux.fs.File;
const mem = linux.mem;

pub fn fileToSlice(path: []const u8) ?[]u8 {
    const file_raw = File.init(path);
    if (file_raw == null) {
        return null;
    }

    var file = file_raw.?;
    defer file.deinit();

    if (mem.alloc(u8, file.size())) |block| {
        file.read(block);
        return block;
    }
    else {
        return null;
    }
}
