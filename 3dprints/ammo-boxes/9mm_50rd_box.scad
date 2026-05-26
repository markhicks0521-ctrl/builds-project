$fn = 48;

module ammo_tray() {
    difference() {
        union() {
            // Floor
            cube([61.5, 119, 2]);
            // Left wall
            cube([2, 119, 26]);
            // Right wall
            translate([59.5, 0, 0])
                cube([2, 119, 26]);
            // Back wall closed end
            translate([0, 0, 0])
                cube([61.5, 2, 26]);
            // Hole block — solid fill between walls
            translate([2, 2, 2])
                cube([57.5, 115, 24]);
        }
        // 50 holes — all usable, centered in cells
        for (c = [0:4]) {
            for (r = [0:9]) {
                translate([7.75 + c*11.5, 7.75 + r*11.5, 2])
                    cylinder(d=9.5, h=24.1);
            }
        }
        // Left wall groove — tongue slot
        translate([2, 0, 22.5])
            cube([3.5, 119.1, 3.5]);
        // Right wall groove — tongue slot
        translate([56, 0, 22.5])
            cube([3.5, 119.1, 3.5]);
        // Detent divot on back wall inside face
        translate([30.75, 2.6, 24])
            sphere(r=1.3);
    }
}

module ammo_lid() {
    union() {
        // Main lid plate — fits between grooves
        translate([3.5, 0, 0])
            cube([54.5, 119, 3]);
        // Left tongue
        translate([2.3, 0, 0])
            cube([3.2, 119, 3.2]);
        // Right tongue
        translate([56, 0, 0])
            cube([3.2, 119, 3.2]);
        // Pull tab on open end
        translate([20, 119, 0])
            cube([21.5, 4, 3]);
        // Detent bump on closed end face
        translate([30.75, 0.1, 1.5])
            sphere(r=1.3);
    }
}

ammo_tray();
translate([80, 0, 0]) ammo_lid();
