// 9mm 50-round ammo box
// Lid slides in from short end (y=119 side)

wall = 2;
floor_t = 2;
hole_d = 9.5;
cols = 5;
rows = 10;
cell = 11.5;
tray_w = 61.5;
tray_l = 119;
hole_depth = 20;
tray_h = 22;
rail_h = 4;
lip = 2;
lid_t = 3;
cl = 0.4;
$fn = 48;

module ammo_tray() {
    union() {
        // Main body with holes
        difference() {
            cube([tray_w, tray_l, tray_h]);
            for (c = [0:cols-1]) {
                for (r = [0:rows-1]) {
                    translate([
                        wall + c*cell + cell/2,
                        wall + r*cell + cell/2,
                        floor_t
                    ])
                    cylinder(d=hole_d, h=hole_depth+0.1);
                }
            }
            // detent divot on short open end inside face
            translate([tray_w/2, tray_l-wall-0.6, tray_h-rail_h/2])
                sphere(r=1.2);
        }
        // Left rail
        translate([0, 0, tray_h])
            cube([wall, tray_l, rail_h]);
        // Right rail
        translate([tray_w-wall, 0, tray_h])
            cube([wall, tray_l, rail_h]);
        // Closed short end rail
        translate([0, 0, tray_h])
            cube([tray_w, wall, rail_h]);
        // Open short end rail (y=tray_l side)
        translate([0, tray_l-wall, tray_h])
            cube([tray_w, wall, rail_h]);
        // Left inward lip
        translate([wall, 0, tray_h+rail_h-lid_t])
            cube([lip, tray_l, lid_t]);
        // Right inward lip
        translate([tray_w-wall-lip, 0, tray_h+rail_h-lid_t])
            cube([lip, tray_l, lid_t]);
        // Closed end inward lip
        translate([0, wall, tray_h+rail_h-lid_t])
            cube([tray_w, lip, lid_t]);
        // Open end inward lip
        translate([0, tray_l-wall-lip, tray_h+rail_h-lid_t])
            cube([tray_w, lip, lid_t]);
    }
}

module ammo_lid() {
    difference() {
        cube([tray_w, tray_l, lid_t]);
        // Left notch
        translate([-0.1, -0.1, 0])
            cube([wall+lip+cl, tray_l+0.2, lid_t]);
        // Right notch
        translate([tray_w-wall-lip-cl, -0.1, 0])
            cube([wall+lip+cl+0.1, tray_l+0.2, lid_t]);
        // Closed end notch
        translate([-0.1, -0.1, 0])
            cube([tray_w+0.2, wall+lip+cl, lid_t]);
        // Open end notch
        translate([-0.1, tray_l-wall-lip-cl, 0])
            cube([tray_w+0.2, wall+lip+cl+0.1, lid_t]);
    }
    // detent bump on open end face
    translate([tray_w/2, tray_l-wall-lip-cl, lid_t/2])
        sphere(r=1.2);
}

ammo_tray();
translate([tray_w+20, 0, 0]) ammo_lid();
