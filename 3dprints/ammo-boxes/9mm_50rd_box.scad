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
        union() {
            difference() {
                cube([61.5, 119, 25.3]);
                for (c = [0:4]) {
                    for (r = [0:9]) {
                        translate([
                            2 + c * 11.5 + 5.75,
                            2 + r * 11.5 + 5.75,
                            1.99
                        ])
                        cylinder(d=9.5, h=23.33);
                    }
                }
            }
            // raised long walls
            translate([0, 0, 25.3])     cube([2, 119, 3.3]);
            translate([59.5, 0, 25.3])  cube([2, 119, 3.3]);
            // raised short end walls
            translate([0, 0, 25.3])     cube([61.5, 2, 3.3]);
            translate([0, 117, 25.3])   cube([61.5, 2, 3.3]);
            // inward lips — all 4 sides
            translate([2, 0, 25.3])     cube([1.5, 119, 3.3]);
            translate([58, 0, 25.3])    cube([1.5, 119, 3.3]);
            translate([0, 2, 25.3])     cube([61.5, 1.5, 3.3]);
            translate([0, 117.5, 25.3]) cube([61.5, 1.5, 3.3]);
        }
        // sliding gap in open end lip — leaves corner posts, opens middle for lid tongue
        translate([1.5, 117.5, 25.3]) cube([58, 1.5, 3.3]);
        // detent divot on open end inside face
        translate([30.75, 117.5, 26.95]) sphere(r=1.2);
    }
}

module ammo_lid() {
    union() {
        difference() {
            cube([61.5, 119, 3]);
            translate([-0.01, 0, 0])  cube([1.5, 119, 3]);
            translate([60, 0, 0])     cube([1.5, 119, 3]);
            translate([0, -0.01, 0])  cube([61.5, 1.5, 3]);
            translate([0, 117.5, 0])  cube([61.5, 1.5, 3]);
        }
        // detent bump — clicks into tray divot on open end
        translate([30.75, 118, 1.5]) sphere(r=1.2);
    }
}

ammo_tray();
translate([tray_w + 15, 0, 0]) ammo_lid();
