// 9mm 50rd ammo box — 2x2 hole test piece for fit verification
// Rounds sit tip-down; case rim (9.96mm) catches on top edge of hole.

hole_d   = 9.5;   // hole diameter — must clear case body, catch rim
wall     = 3;     // wall thickness on all sides
floor_t  = 2;     // floor thickness
depth    = 22;    // total tray depth (hole runs full depth, no bridging)
spacing  = 11.5;  // center-to-center hole spacing

cols = 2;
rows = 2;

tray_x = cols * spacing + 2 * wall;
tray_y = rows * spacing + 2 * wall;

difference() {
    cube([tray_x, tray_y, depth]);
    for (col = [0 : cols - 1], row = [0 : rows - 1]) {
        translate([
            wall + spacing * col + spacing / 2,
            wall + spacing * row + spacing / 2,
            floor_t
        ])
            cylinder(h = depth, d = hole_d, $fn = 48);
    }
}
