wall = 2;
floor_t = 2;
round_depth = 20;
lid_t = 3;
hole_d = 9.5;
cols = 5;
rows = 10;
cell = 11.5;
tray_w = 61.5;
tray_l = 119;
tray_h = 25.3;
ch_depth = 1.5;
ch_h = 3;
$fn = 48;

module ammo_tray() {
    difference() {
        cube([tray_w, tray_l, tray_h]);
        for (c = [0:4]) {
            for (r = [0:9]) {
                translate([
                    2 + c * 11.5 + 5.75,
                    2 + r * 11.5 + 5.75,
                    1.99
                ])
                cylinder(d=9.5, h=20.02);
            }
        }
        translate([2, 0, 22.3])
            cube([1.5, 119, 3.01]);
        translate([58, 0, 22.3])
            cube([1.5, 119, 3.01]);
    }
}

module ammo_lid() {
    cube([tray_w, tray_l, lid_t]);
}

ammo_tray();
translate([tray_w + 15, 0, 0]) ammo_lid();
