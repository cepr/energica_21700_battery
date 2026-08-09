include <parameters.scad>
use <base_plate.scad>
use <busbar.scad>

// https://nmbtc.com/wp-content/uploads/parts/documents/12038VE-12R-GUE-4%20data%20sheet.pdf
module fan() {
  difference() {
    cube([120, 120, 38], center=true);
    for (x = [-105 / 2, 105 / 2], y = [-105 / 2, 105 / 2]) {
      translate([x, y, 0])
        cylinder(h=100, d=4.3, center=true);
    }
  }
}

module fan_panel() {
  linear_extrude(height=100, center=true, convexity=10) {
    intersection() {
      square([117.6, 117.6], center=true);
      circle(d=136);
    }
    for (x = [-105 / 2, 105 / 2], y = [-105 / 2, 105 / 2]) {
      translate([x, y])
        circle(d=4.3);
    }
  }
}

module inlet() {
  ox = case_dim_x - 2 * external_walls;
  oy = case_dim_y - 2 * external_walls;

  translate([0, 0, large_spacer_stack_height / 2])
    difference() {
      base_plate(height=large_spacer_stack_height, center=true, shorter_end=false);
      // Inserts
      for (x = [-0.5, 0.5], y1 = [-.5:0.5], y2 = [-2:2]) {
        translate([x * base_plate_dim_x, y1 * d + y2 * (d + d + cell_isolation), 0])
          rotate([0, 90, 0])
            cylinder(h=m4_insert_length * 2, d=m4_insert_od, center=true);
      }
      for (x = [-2.5:2.5], y = [-0.5, 0.5]) {
        translate([x * d, y * base_plate_dim_y, 0])
          rotate([90, 0, 0])
            cylinder(h=m4_insert_length * 2, d=m4_insert_od, center=true);
      }
    }

  translate([0, 0, 20])
    difference() {
      cube([ox, oy, 3], center=true);
      fan_panel();
    }

  translate([0, -0.5 * oy, large_spacer_stack_height / 2])
    rotate([90, 0, 0])
      busbar();

  translate([0, 0, 50]) {
    fan();
  }
}

inlet();
