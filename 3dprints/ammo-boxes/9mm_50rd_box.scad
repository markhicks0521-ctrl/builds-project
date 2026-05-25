// === CARTRIDGE PARAMETERS ===
bullet_d = 9.01;       // bullet diameter mm
base_d = 9.93;         // case base diameter mm
cartridge_oal = 29.69; // overall cartridge length mm

// === FIT PARAMETERS ===
hole_clearance = 0.47; // added to base_d for hole diameter
lid_clearance = 0.3;   // sliding fit clearance for lid rails

// === GRID ===
cols = 5;
rows = 10;

// === TRAY PARAMETERS ===
wall = 2;
floor_t = 2;
round_depth = 20;      // how deep rounds sit in tray
lip_h = 4;             // height of lip the lid slides over

// === DERIVED ===
hole_d = base_d + hole_clearance;
cell_w = hole_d + wall;
tray_inner_w = cols * cell_w;
tray_inner_l = rows * cell_w;
tray_outer_w = tray_inner_w + wall * 2;
tray_outer_l = tray_inner_l + wall * 2;
tray_h = round_depth + floor_t;

$fn = 32;
corner_r = 2;

// Rounded-corner box using hull of 4 corner cylinders
module rounded_box(w, l, h, r = 2) {
    hull() {
        translate([r,   r,   0]) cylinder(r=r, h=h);
        translate([w-r, r,   0]) cylinder(r=r, h=h);
        translate([r,   l-r, 0]) cylinder(r=r, h=h);
        translate([w-r, l-r, 0]) cylinder(r=r, h=h);
    }
}

// ─── TRAY ────────────────────────────────────────────────────────────────────

module ammo_tray() {
    difference() {
        union() {
            // Main tray body
            rounded_box(tray_outer_w, tray_outer_l, tray_h, corner_r);

            // Lip collar: wall-thick hollow raised ring above tray body
            translate([0, 0, tray_h])
                difference() {
                    rounded_box(tray_outer_w, tray_outer_l, lip_h, corner_r);
                    translate([wall, wall, -0.01])
                        cube([tray_inner_w, tray_inner_l, lip_h + 0.02]);
                }
        }

        // Inner pocket — cartridges sit here
        translate([wall, wall, floor_t])
            cube([tray_inner_w, tray_inner_l, round_depth + 0.01]);

        // Cartridge holes punched through floor (enables push-out from below)
        for (c = [0:cols-1]) {
            for (r = [0:rows-1]) {
                translate([
                    wall + c * cell_w + cell_w / 2,
                    wall + r * cell_w + cell_w / 2,
                    -0.01
                ])
                    cylinder(d=hole_d, h=floor_t + 0.02);
            }
        }
    }
}

// ─── LID ─────────────────────────────────────────────────────────────────────

// 9mm FMJ side-profile silhouette, centered at origin, for deboss
module bullet_silhouette() {
    bw = 8;    // 8 mm wide
    bh = 22;   // 22 mm tall
    // Ogive begins at 60 % up from base (10 % above centre)
    body_top = bh * 0.1;
    linear_extrude(0.81)
    polygon([
        [-bw/2, -bh/2],       // base left
        [ bw/2, -bh/2],       // base right
        [ bw/2,  body_top],   // shoulder right
        [ bw/4,  bh/2 - 2],  // ogive right
        [ 0,     bh/2],       // tip
        [-bw/4,  bh/2 - 2],  // ogive left
        [-bw/2,  body_top]    // shoulder left
    ]);
}

module ammo_lid() {
    // Outer footprint fits over the lip with sliding clearance
    lid_outer_w = tray_outer_w + lid_clearance * 2;
    lid_outer_l = tray_outer_l - lid_clearance;
    lid_t     = 3;
    inner_h   = lip_h + lid_clearance;
    total_h   = lid_t + inner_h;
    groove_w  = 2;
    groove_d  = 1.5;

    // Rail groove x positions: centred over the two long-side lip walls
    //   Left lip wall occupies x [0, wall] in tray coords
    //   → x [lid_clearance, lid_clearance+wall] in lid coords
    groove_x_L = lid_clearance + (wall - groove_w) / 2;
    groove_x_R = lid_clearance + tray_outer_w - wall + (wall - groove_w) / 2;

    difference() {
        // Lid outer body — rounded corners
        rounded_box(lid_outer_w, lid_outer_l, total_h, corner_r);

        // Inner cavity: open at y=0 (sliding entry end),
        //               closed-end wall at y = lid_outer_l - wall
        translate([lid_clearance, -0.01, 0])
            cube([tray_outer_w, lid_outer_l - wall + 0.01, inner_h]);

        // Rail grooves in ceiling (z = inner_h), running full length
        translate([groove_x_L, -0.01, inner_h])
            cube([groove_w, lid_outer_l + 0.02, groove_d]);
        translate([groove_x_R, -0.01, inner_h])
            cube([groove_w, lid_outer_l + 0.02, groove_d]);

        // ── Top-face deboss design ──────────────────────────────────────────

        // Bullet silhouette centred on lid top face
        translate([lid_outer_w / 2, lid_outer_l / 2, total_h - 0.8])
            bullet_silhouette();

        // "9MM" label above bullet (font size 6)
        translate([lid_outer_w / 2, lid_outer_l / 2 + 15, total_h - 0.8])
            linear_extrude(0.81)
                text("9MM", size=6,
                     font="Liberation Sans:style=Bold",
                     halign="center", valign="center");

        // "50 RDS" label below bullet (font size 5)
        translate([lid_outer_w / 2, lid_outer_l / 2 - 17, total_h - 0.8])
            linear_extrude(0.81)
                text("50 RDS", size=5,
                     font="Liberation Sans:style=Bold",
                     halign="center", valign="center");
    }
}

// ─── PREVIEW ─────────────────────────────────────────────────────────────────

ammo_tray();
translate([tray_outer_w + 10, 0, 0]) ammo_lid();
