$fn = 48;
tray_w = 65.5;
tray_l = 127;
tray_h = 26;
wall = 4;
floor_t = 2;
hole_d = 9.5;
cell = 11.5;
lid_t = 3;

module ammo_tray() {
    difference() {
        union() {
            cube([tray_w, tray_l, tray_h]);
        }
        // hollow interior
        translate([wall, wall, floor_t])
            cube([tray_w-wall*2, tray_l-wall*2, tray_h]);
        // 50 holes
        for (c = [0:4]) {
            for (r = [0:9]) {
                translate([wall + c*cell + cell/2, wall + r*cell + cell/2, floor_t])
                    cylinder(d=hole_d, h=tray_h);
            }
        }
        // left groove - cuts into inside face of left wall
        translate([wall-3, -0.1, tray_h-lid_t-0.1])
            cube([3.1, tray_l+0.2, lid_t+0.2]);
        // right groove
        translate([tray_w-wall, -0.1, tray_h-lid_t-0.1])
            cube([3.1, tray_l+0.2, lid_t+0.2]);
        // detent divot inside back wall
        translate([tray_w/2, wall+1, tray_h-lid_t/2])
            sphere(r=1.3);
    }
}

module ammo_lid() {
    union() {
        // center plate
        translate([wall-3, 0, 0])
            cube([tray_w-wall*2+6, tray_l, lid_t]);
        // left tongue fits into left groove
        translate([wall-3, 0, 0])
            cube([2.7, tray_l, 2.7]);
        // right tongue
        translate([tray_w-wall+0.3, 0, 0])
            cube([2.7, tray_l, 2.7]);
        // detent bump on closed end face
        translate([tray_w/2, 0.1, lid_t/2])
            sphere(r=1.3);
        // pull tab open end
        translate([tray_w/2-10, tray_l, 0])
            cube([20, 5, lid_t]);
    }
}

ammo_tray();
translate([tray_w+20, 0, 0]) ammo_lid();
