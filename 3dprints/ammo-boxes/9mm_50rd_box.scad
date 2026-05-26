wall = 2;
floor_t = 2;
round_depth = 20;
lid_t = 3;
hole_d = 9.5;
cols = 5;
rows = 10;
cell = 11.5;
tray_w = 63.5;
tray_l = 121;
tray_h = 25.3;
rail_h = 3.3;
lip_w = 3;
$fn = 48;

module ammo_tray() {
    union() {
        difference() {
            cube([tray_w, tray_l, tray_h]);
            for (c = [0:4]) {
                for (r = [0:9]) {
                    translate([2 + c*11.5 + 5.75, 2 + r*11.5 + 5.75, 1.99])
                        cylinder(d=9.5, h=23.33);
                }
            }
            translate([30.75, tray_l - 4, 0])
                sphere(r=1.2);
        }
        translate([0, 0, tray_h])
            cube([wall, tray_l, rail_h]);
        translate([tray_w - wall, 0, tray_h])
            cube([wall, tray_l, rail_h]);
        translate([0, 0, tray_h])
            cube([tray_w, wall, rail_h]);
        translate([wall, 0, tray_h + rail_h - lid_t])
            cube([lip_w, tray_l, lid_t]);
        translate([tray_w - wall - lip_w, 0, tray_h + rail_h - lid_t])
            cube([lip_w, tray_l, lid_t]);
        translate([0, 0, tray_h + rail_h - lid_t])
            cube([tray_w, wall, lid_t]);
    }
}

module ammo_lid() {
    difference() {
        cube([tray_w, tray_l, lid_t]);
        translate([-0.01, 0, 0])
            cube([wall + lip_w + 0.3, tray_l, lid_t]);
        translate([tray_w - wall - lip_w - 0.3, 0, 0])
            cube([wall + lip_w + 0.3, tray_l, lid_t]);
        translate([0, -0.01, 0])
            cube([tray_w, wall + lip_w + 0.3, lid_t]);
    }
    translate([tray_w/2, tray_l - 3, 0])
        sphere(r=1.2);
}

ammo_tray();
translate([tray_w + 15, 0, 0]) ammo_lid();
