include <parameters.scad>
use <base_plate.scad>

module large_spacer() {
  difference() {
    base_plate(height=large_spacer_stack_height, center=true, shorter_end=true, nickel_passages=true);
    // Inserts
    // Long side
    for (x = [-0.5, 0.5], y1 = [-0.5:0.5], y2 = [-2:2]) {
      translate([x * base_plate_dim_x, y1 * d + y2 * (d + d + cell_isolation), 0])
        rotate([0, 90, 0])
          cylinder(h=(m3_insert_length + (y1 == -0.5 ? ring_terminal_cutout_depth : 0)) * 2, d=m3_insert_od, center=true);
    }
    // Short side
    for (x = [-2.5:2.5], y = [-0.5 * base_plate_dim_y + 3, 0.5 * base_plate_dim_y]) {
      translate([x * d, y, 0])
        rotate([90, 0, 0])
          cylinder(h=m3_insert_length * 2, d=m3_insert_od, center=true);
    }
    // Clearance for the ring terminals
    for (x = [-0.5, 0.5], y1 = [-0.5], y2 = [-2:2]) {
      translate([x * (base_plate_dim_x - ring_terminal_cutout_depth * 2), y1 * d + y2 * (d + d + cell_isolation) + 5.6 / 2, 0])
        rotate([-90, 0, 0])
          cylinder(d=3.9, h=0.4 * d);
    }
  }
}

module large_spacer_modifier() {
  // Inserts
  // Long side
  for (x = [-0.5, 0.5], y1 = [-0.5:0.5], y2 = [-2:2]) {
    translate([x * base_plate_dim_x, y1 * d + y2 * (d + d + cell_isolation), 0])
      rotate([0, 90, 0])
        cylinder(h=(m3_insert_length + 3 + (y1 == -0.5 ? ring_terminal_cutout_depth : 0)) * 2, d=m3_insert_od + 3, center=true);
  }
  // Short side
  for (x = [-2.5:2.5], y = [-0.5 * base_plate_dim_y + 3, 0.5 * base_plate_dim_y]) {
    translate([x * d, y, 0])
      rotate([90, 0, 0])
        cylinder(h=m3_insert_length * 2 + 3, d=m3_insert_od + 3, center=true);
  }
}

large_spacer();
