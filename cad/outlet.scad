include <parameters.scad>
use <large_spacer.scad>
use <terminal_busbar.scad>

module outlet() {
  large_spacer();
  for (y = [0, -busbar_thickness - copper_plate_thickness]) {
    translate([0, y, 0]) {
      translate([0, -base_plate_dim_y / 2 + busbar_cutout_depth, 0])
        rotate([90, 0, 0]) {
          terminal_busbar();
        }
    }
  }
}

outlet();
