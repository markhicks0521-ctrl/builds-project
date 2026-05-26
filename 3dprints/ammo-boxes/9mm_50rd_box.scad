$fn = 48;
tray_w = 63.5;
tray_l = 121;
tray_h = 22;
wall = 3;
floor_t = 2;
hole_d = 9.5;
cell = 11.5;
groove_w = 3;
groove_h = 2;
lid_t = 3;

module ammo_tray() {
    difference() {
        cube([tray_w, tray_l, tray_h]);
        // 50 holes
        for (c = [0:4]) {
            for (r = [0:9]) {
                translate([wall + c*cell + cell/2, wall + r*cell + cell/2, floor_t-0.1])
                    cylinder(d=hole_d, h=tray_h);
            }
        }
        // Left groove - cut into top of left wall, full length
        translate([-0.1, -0.1, tray_h-groove_h])
            cube([groove_w+0.1, tray_l+0.2, groove_h+0.1]);
        // Right groove - cut into top of right wall, full length
        translate([tray_w-groove_w, -0.1, tray_h-groove_h])
            cube([groove_w+0.1, tray_l+0.2, groove_h+0.1]);
        // Detent divot inside back wall
        translate([tray_w/2, wall-0.5, tray_h-groove_h/2])
            sphere(r=1.3);
    }
}

module ammo_lid() {
    union() {
        // Main plate
        cube([tray_w, tray_l, lid_t]);
        // Left tongue - hangs below lid into left groove
        translate([0, 0, -(groove_h-0.3)])
            cube([groove_w-0.3, tray_l, groove_h-0.3]);
        // Right tongue - hangs below lid into right groove
        translate([tray_w-(groove_w-0.3), 0, -(groove_h-0.3)])
            cube([groove_w-0.3, tray_l, groove_h-0.3]);
        // Pull tab on open end
        translate([tray_w/2-12, tray_l, 0])
            cube([24, 6, lid_t]);
        // Detent bump on closed end face bottom
        translate([tray_w/2, 0, -(groove_h-0.3)/2])
            sphere(r=1.3);
    }
}

ammo_tray();
translate([tray_w+20, 0, 0]) ammo_lid();
