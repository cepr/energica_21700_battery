include <parameters.scad>
use <module_120.scad>
use <large_spacer.scad>
use <intermediate_busbar.scad>
use <panels.scad>
use <outlet.scad>
use <inlet.scad>

/**
 * 240 cells as a 6x10x4 pack, along the z axis, the pack centered at the origin.
 */
module module_240(flip_cells = false, flip_terminals = false) {
  for (z = [-0.5, 0.5]) {
    rotate([0, flip_cells ? 180 : 0, 0])
      translate([0, 0, z * (module_120_height + large_spacer_stack_height + exploded)]) {
        module_120();
      }
  }
  rotate([0, 0, 180])
    large_spacer();
  for (y = [2.9, 1.8]) {
    translate([0, 0.5 * base_plate_dim_y - y, 0])
      rotate([-90, 0, 0])
        intermediate_busbar();
  }
  panels();
  translate([0, 0, -module_120_height - large_spacer_stack_height])
    rotate([180, 0, 0]) outlet(flip_terminals=flip_terminals);

  
  translate([0, 0, module_120_height + 0.5 * large_spacer_stack_height])
    rotate([0, 0, 180])
      inlet(flip_terminals=flip_terminals);
}

module_240();
