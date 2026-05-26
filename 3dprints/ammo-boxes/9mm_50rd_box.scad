$fn = 48;

module ammo_tray() {
    // Floor
    cube([63.5, 121, 2]);
    // Left wall - full height
    cube([3, 121, 28]);
    // Right wall - full height
    translate([60.5, 0, 0]) cube([3, 121, 28]);
    // Back wall - full height
    cube([63.5, 3, 28]);
    // Lips
    translate([3, 0, 28]) cube([2, 121, 2]);
    translate([58.5, 0, 28]) cube([2, 121, 2]);
    translate([0, 0, 28]) cube([63.5, 3, 2]);
    // Hole block sitting on floor between walls
    difference() {
        translate([3, 3, 2]) cube([57.5, 115, 20]);
        for (c = [0:4]) {
            for (r = [0:9]) {
                translate([8.75 + c*11.5, 8.75 + r*11.5, 1.9])
                    cylinder(d=9.5, h=20.2);
            }
        }
    }
    // Detent divot on inside back wall
    difference() {
        translate([0,0,0]) cube([0.01,0.01,0.01]);
        translate([31.75, 3.5, 25]) sphere(r=1.3);
    }
}

module ammo_lid() {
    // Lid fits inside the 4 walls, sits on top of hole block
    // Width = tray inner width = 57.5, Length = tray inner length = 115
    translate([5, 3, 22]) cube([53.5, 113, 3]);
    // Detent bump on closed end face
    translate([31.75, 3.5, 22]) sphere(r=1.3);
}

ammo_tray();
translate([80, 0, 0]) ammo_lid();
