const battery = @import("battery.zig");
const time = @import("time.zig");

pub fn main() void {
    time.printTime();
    battery.printBattery();
}
