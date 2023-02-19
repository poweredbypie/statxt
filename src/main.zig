const battery = @import("battery.zig");
const time = @import("time.zig");

const io = @import("linux").io;

fn write(comptime str: []const u8) void {
    io.print(str, .{});
}

pub fn main() void {
    time.printDate();
    write(" ");
    time.printTime();
    write(", ");
    battery.printBattery();
    write("\n");
}
