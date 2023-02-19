const battery = @import("battery.zig");

pub fn main() !void {
    try battery.printBattery();
}
