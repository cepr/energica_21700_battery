include <parameters.scad>
use <colors.scad>

module large_panel_2d() {
  difference() {
    square([module_240_height, case_dim_y], center=true);
    for (y1 = [-0.5, 0.5], y2 = [-2:2]) {
      for (x = [-2:2]) {
        translate(
          [
            x * (module_60_height + large_spacer_stack_height),
            y1 * d + y2 * (d + d + cell_isolation),
          ]
        ) {
          circle(d=4.5);
        }
      }
    }
  }
}

module large_panel() {
  rotate([0, 90, 0])
    linear_extrude(height=external_walls, center=true)
      large_panel_2d();
}

module small_panel() {
  difference() {
    cube([case_dim_x - 2 * external_walls, external_walls, module_240_height], center=true);
    for (x = [-2.5:2.5], z = [-2:2]) {
      translate([x * d, 0, z * (module_60_height + large_spacer_stack_height)]) {
        rotate([90, 0, 0])
          cylinder(h=100, d=4.5, center=true);
      }
    }
  }
}

module panels() {
  clear_acrylic() {
    for (x = [-0.5, 0.5]) {
      translate([x * (case_dim_x - external_walls), 0, 0]) {
        large_panel();
      }
    }
    for (y = [-0.5, 0.5]) {
      translate([0, y * (case_dim_y - external_walls), 0])
        small_panel();
    }
  }
}

*large_panel_2d();
small_panel();
