// === CARTRIDGE PARAMETERS ===
bullet_d = 9.01;       // bullet diameter mm
base_d = 9.93;         // case base diameter mm
cartridge_oal = 29.69; // overall cartridge length mm

// === FIT PARAMETERS ===
lid_clearance = 0.3;   // sliding fit clearance for lid rails
detent_from_end = 5;   // mm from closed end to detent centre

// === GRID ===
cols = 5;
rows = 10;

// === TRAY PARAMETERS ===
wall = 2;
floor_t = 2;           // solid floor thickness
shelf_t = 2;           // hole-shelf thickness at tray top
round_depth = 20;      // pocket depth below shelf (round body hangs here)
lip_h = 4;             // height of lip the lid slides over

// === DERIVED ===
// hole_d < case rim (9.96 mm): round drops tip-down, hangs by rim on shelf edge
hole_d = 9.5;
cell_w = hole_d + wall;
tray_inner_w = cols * cell_w;
tray_inner_l = rows * cell_w;
tray_outer_w = tray_inner_w + wall * 2;
tray_outer_l = tray_inner_l + wall * 2;
tray_h = floor_t + round_depth + shelf_t;  // total tray body height

$fn = 32;
corner_r = 2;

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
    detent_z = tray_h + lip_h / 2;  // mid-height of lip for divot centre
    // Divot sphere inset so cap depth = r - inset = 1.6 - 1.1 = 0.5 mm
    divot_inset = 1.1;

    difference() {
        union() {
            // Tray body: solid floor + open round pocket + solid shelf
            rounded_box(tray_outer_w, tray_outer_l, tray_h, corner_r);

            // Lip collar above tray body
            translate([0, 0, tray_h])
                difference() {
                    rounded_box(tray_outer_w, tray_outer_l, lip_h, corner_r);
                    translate([wall, wall, -0.01])
                        cube([tray_inner_w, tray_inner_l, lip_h + 0.02]);
                }
        }

        // Round pocket: above solid floor, below solid shelf
        translate([wall, wall, floor_t])
            cube([tray_inner_w, tray_inner_l, round_depth + 0.01]);

        // Rim-hang holes through shelf only — floor stays solid
        for (c = [0:cols-1]) {
            for (r = [0:rows-1]) {
                translate([
                    wall + c * cell_w + cell_w / 2,
                    wall + r * cell_w + cell_w / 2,
                    tray_h - shelf_t - 0.01
                ])
                    cylinder(d=hole_d, h=shelf_t + 0.02);
            }
        }

        // Detent divots on outer faces of long-side lip walls, near closed end
        // Left wall outer face at x=0 → sphere centre at x=divot_inset
        translate([divot_inset, tray_outer_l - detent_from_end, detent_z])
            sphere(r=1.6);
        // Right wall outer face at x=tray_outer_w → centre at x=tray_outer_w-divot_inset
        translate([tray_outer_w - divot_inset, tray_outer_l - detent_from_end, detent_z])
            sphere(r=1.6);
    }
}

// ─── LID ─────────────────────────────────────────────────────────────────────

module bullet_silhouette() {
    bw = 8;
    bh = 22;
    body_top = bh * 0.1;  // ogive starts 60 % up from base
    linear_extrude(0.81)
    polygon([
        [-bw/2, -bh/2],
        [ bw/2, -bh/2],
        [ bw/2,  body_top],
        [ bw/4,  bh/2 - 2],
        [ 0,     bh/2],
        [-bw/4,  bh/2 - 2],
        [-bw/2,  body_top]
    ]);
}

module ammo_lid() {
    lid_outer_w = tray_outer_w + lid_clearance * 2;
    lid_outer_l = tray_outer_l - lid_clearance;
    lid_t    = 3;
    inner_h  = lip_h + lid_clearance;   // cavity height: lip fits with clearance
    total_h  = lid_t + inner_h;
    groove_w = 2;
    groove_d = 1.5;
    tab_h    = 2;   // hard-stop tab height
    tab_d    = 2;   // hard-stop tab depth (y)
    detent_r = 1.5; // bump hemisphere radius

    // Rail groove x: centred over long-side lip wall tops
    groove_x_L = lid_clearance + (wall - groove_w) / 2;
    groove_x_R = lid_clearance + tray_outer_w - wall + (wall - groove_w) / 2;

    // Detent bump position in lid coords
    bump_y = lid_outer_l - detent_from_end;
    bump_z = lip_h / 2;   // matches tray divot at mid-height of lip

    union() {
        difference() {
            rounded_box(lid_outer_w, lid_outer_l, total_h, corner_r);

            // Inner cavity: open at y=0 (sliding entry), wall at closed end
            translate([lid_clearance, -0.01, 0])
                cube([tray_outer_w, lid_outer_l - wall + 0.01, inner_h]);

            // Rail grooves in ceiling (z=inner_h), full length
            translate([groove_x_L, -0.01, inner_h])
                cube([groove_w, lid_outer_l + 0.02, groove_d]);
            translate([groove_x_R, -0.01, inner_h])
                cube([groove_w, lid_outer_l + 0.02, groove_d]);

            // Top-face deboss: bullet silhouette + labels
            translate([lid_outer_w / 2, lid_outer_l / 2, total_h - 0.8])
                bullet_silhouette();
            translate([lid_outer_w / 2, lid_outer_l / 2 + 15, total_h - 0.8])
                linear_extrude(0.81)
                    text("9MM", size=6, font="Liberation Sans:style=Bold",
                         halign="center", valign="center");
            translate([lid_outer_w / 2, lid_outer_l / 2 - 17, total_h - 0.8])
                linear_extrude(0.81)
                    text("50 RDS", size=5, font="Liberation Sans:style=Bold",
                         halign="center", valign="center");
        }

        // Hard stop: full-width tab on inside of closed end, 2 mm tall × 2 mm deep
        // Catches tray near wall when lid is almost fully slid off
        translate([lid_clearance, lid_outer_l - wall - tab_d, 0])
            cube([tray_outer_w, tab_d, tab_h]);

        // Detent bumps: hemispheres on inner long-side walls near closed end
        // Left inner wall at x=lid_clearance, bump protrudes +x into cavity
        translate([lid_clearance, bump_y, bump_z])
            intersection() {
                sphere(r=detent_r);
                translate([0, -50, -50]) cube([100, 100, 100]);
            }
        // Right inner wall at x=lid_clearance+tray_outer_w, protrudes -x
        translate([lid_clearance + tray_outer_w, bump_y, bump_z])
            intersection() {
                sphere(r=detent_r);
                translate([-100, -50, -50]) cube([100, 100, 100]);
            }
    }
}

// ─── PREVIEW ─────────────────────────────────────────────────────────────────

ammo_tray();
translate([tray_outer_w + 10, 0, 0]) ammo_lid();
