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
// - Figure out how to route the temperature sensors
// - Add slots in the panels to route wires
// - Add the LMU and BMCU
// - design the top holders
// - Make the bottom side panel larger to mount to the bulkhead
//   - add a slot for the outside vents

// Elements

rotate([90, 0, 0])
  rotate([0, 90, 0])
    bulkhead();

module panel_with_pcbs() {
  module_240();
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
    -20,
  ]
) {
  rotate([0, 0, 180])
    panel_with_pcbs();
}

translate(
  [
    case_dim_x / 2 + 10,
    case_dim_y / 2 + 10 - 258,
    -20,
  ]
) {
  panel_with_pcbs();
}
