wall      = 2;
floor_t   = 2;
shelf_t   = 2;
round_depth = 20;
lid_t     = 3;
hole_d    = 9.5;
cols      = 5;
rows      = 10;

cell   = hole_d + wall;
tray_w = cols * cell + wall * 2;
tray_l = rows * cell + wall * 2;
tray_h = floor_t + round_depth + lid_t + 0.3;  // 25.3mm

$fn = 48;

module ammo_tray() {
    difference() {
        cube([tray_w, tray_l, tray_h]);

        // 50 holes — floor_t to floor_t+round_depth, solid floor beneath
        for (c = [0:cols-1]) {
            for (r = [0:rows-1]) {
                translate([
                    wall + c * cell + cell/2,
                    wall + r * cell + cell/2,
                    floor_t - 0.01
                ])
                    cylinder(d=hole_d, h=round_depth + 0.02);
            }
        }

        // lid channel — inside face of both long walls (X walls), top 3mm
        translate([wall, 0, tray_h - 3])
            cube([1.5, tray_l, 3.01]);
        translate([tray_w - wall - 1.5, 0, tray_h - 3])
            cube([1.5, tray_l, 3.01]);
    }
}

module ammo_lid() {
    cube([tray_w, tray_l, 3]);
}

ammo_tray();
translate([tray_w + 15, 0, 0]) ammo_lid();
