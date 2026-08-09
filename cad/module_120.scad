include <parameters.scad>
use <module_60.scad>
use <large_spacer.scad>
use <intermediate_busbar.scad>

//exploded = 10;

module module_120() {
  for (r = [0, 180]) {
    rotate([0, r, 0])
      translate([0, 0, -0.5 * (module_60_height + large_spacer_stack_height + exploded)]) {
        rotate([r, 0, 0])
          module_60();
      }
  }
  large_spacer();
  for (y = [2.9, 1.8]) {
    translate([0, -0.5 * base_plate_dim_y + y, 0])
      rotate([90, 0, 0])
        intermediate_busbar();
  }
}

module_120();
