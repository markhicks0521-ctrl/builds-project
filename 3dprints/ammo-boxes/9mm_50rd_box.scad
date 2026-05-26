$fn = 48;
wall = 3;
floor_t = 2;
hole_d = 9.5;
cell = 11.5;
cols = 5;
rows = 10;
hole_depth = 22;
groove_d = 3;
groove_h = 3.5;
lid_t = 3;
tray_w = 63.5;
tray_l = 121;
tray_h = 24;

module ammo_tray() {
    difference() {
        cube([tray_w, tray_l, tray_h]);
        for (c = [0:cols-1]) {
            for (r = [0:rows-1]) {
                translate([wall + c*cell + cell/2, wall + r*cell + cell/2, floor_t - 0.1])
                    cylinder(d=hole_d, h=hole_depth + 0.2);
            }
        }
        translate([-0.1, -0.1, tray_h - groove_h])
            cube([groove_d + 0.1, tray_l + 0.2, groove_h + 0.1]);
        translate([tray_w - groove_d, -0.1, tray_h - groove_h])
            cube([groove_d + 0.1, tray_l + 0.2, groove_h + 0.1]);
        translate([tray_w/2, wall + 1, tray_h/2])
            sphere(r=1.3);
    }
}

module ammo_lid() {
    union() {
        cube([tray_w, tray_l, lid_t]);
        translate([-groove_d + 0.15, 0, 0])
            cube([groove_d - 0.3, tray_l, groove_h - 0.3]);
        translate([tray_w - 0.15, 0, 0])
            cube([groove_d - 0.3, tray_l, groove_h - 0.3]);
        translate([tray_w/2 - 12, tray_l, 0])
            cube([24, 6, lid_t]);
        translate([tray_w/2, 0, lid_t/2])
            sphere(r=1.3);
    }
}

ammo_tray();
translate([tray_w + 20, 0, 0]) ammo_lid();
