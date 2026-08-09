include <parameters.scad>

use <colors.scad>
use <busbar.scad>
use <strips_insulator.scad>
use <cell_holder.scad>
use <module_240.scad>
use <base_plate.scad>
use <panels.scad>
use <LiBAL_s-BMS.scad>
use <bulkhead.scad>

// ISO 8855 Convention:
// x towards front
// y towards left
// z towards top

// TODO
// - Model the bulkhead
// - Add the LMU and BMCU
// - design the top and bottom holders
//   - mounting holes for the BMS boards
//   - add mounting to the bulkhead
// - Make the bottom side panel larger to mount to the bulkhead
//   - add a slot for the outside vents

// Elements

rotate([90, 0, 0])
  rotate([0, 90, 0])
    bulkhead();

module panel_with_pcbs() {
  module_240();
  %panels();
  translate([0, -5.5 * d, 81])
    rotate([0, 90, 0])
      rotate([90, 0, 0])
        LMU();

  translate([0, -5.5 * d, -81])
    rotate([0, -90, 0])
      rotate([90, 0, 0])
        LMU();
}

translate(
  [
    case_dim_x / 2 + 10,
    case_dim_y / 2 + 10,
    0,
  ]
) {
  panel_with_pcbs();
}

translate([32, 34, 300])
  color("red") cube([92, 92, 38]);
translate([32, 134, 300])
  color("red") cube([92, 92, 38]);


translate(
  [
    case_dim_x / 2 + 10,
    case_dim_y / 2 + 10 - 258,
    0,
  ]
) {
  panel_with_pcbs();
}
