$fn = 48;

// === TRAY ===
module ammo_tray() {
    // Floor
    cube([61.5, 119, 2]);

    // Left wall
    cube([2, 119, 26]);

    // Right wall
    translate([59.5, 0, 0]) cube([2, 119, 26]);

    // Back wall (closed end)
    translate([0, 0, 0]) cube([61.5, 2, 26]);

    // NO front wall — open end for lid to slide in

    // Left inward lip (holds lid in)
    translate([2, 0, 23]) cube([2, 119, 3]);

    // Right inward lip
    translate([57.5, 0, 23]) cube([2, 119, 3]);

    // Back inward lip
    translate([0, 2, 23]) cube([61.5, 2, 3]);

    // Hole grid — 5 cols x 10 rows, tip-down, solid floor beneath
    difference() {
        translate([2, 2, 2]) cube([57.5, 115, 20]);
        for (c = [0:4]) {
            for (r = [0:9]) {
                translate([7.75 + c*11.5, 7.75 + r*11.5, 2])
                    cylinder(d=9.5, h=20.1);
            }
        }
    }

    // Detent divot on inside of open end — cut into floor near front
    difference() {
        translate([0,0,0]) cube([0.1, 0.1, 0.1]); // dummy
        translate([30.75, 116, 1])
            sphere(r=1.2);
    }
}

// === LID ===
module ammo_lid() {
    difference() {
        // Full plate
        cube([61.5, 119, 3]);
        // Left notch — fits under left lip
        translate([-0.1, -0.1, 0]) cube([4.1, 119.2, 3]);
        // Right notch — fits under right lip
        translate([57.4, -0.1, 0]) cube([4.2, 119.2, 3]);
        // Back notch — fits under back lip
        translate([-0.1, -0.1, 0]) cube([61.7, 4.1, 3]);
        // Front notch
        translate([-0.1, 115, 0]) cube([61.7, 4.2, 3]);
    }
    // Detent bump on front edge bottom
    translate([30.75, 116, 0])
        sphere(r=1.2);
}

ammo_tray();
translate([80, 0, 0]) ammo_lid();
