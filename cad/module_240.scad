include <parameters.scad>
use <module_120.scad>
use <large_spacer.scad>
use <intermediate_busbar.scad>
use <panels.scad>
use <outlet.scad>
use <inlet.scad>

show_panels = true;
show_cells = true;
show_spacers = true;
show_outlet = true;
show_inlet = true;
show_intermediate_busbar = true;

/**
 * 240 cells as a 6x10x4 pack, along the z axis, the pack centered at the origin.
 * third_pcb can be "LMU", "BMCU", or "NONE"
 */
module module_240(flip_cells = false, flip_terminals = false, flip_pcbs = false, third_pcb = "NONE") {
  if (show_cells) {
    for (z = [-0.5, 0.5]) {
      rotate([0, flip_cells ? 180 : 0, 0])
        translate([0, 0, z * (module_120_height + large_spacer_stack_height + exploded)]) {
          module_120();
        }
    }
  }
  if (show_spacers) {
    rotate([0, 0, 180])
      large_spacer();
  }
  if (show_intermediate_busbar) {
    for (y = [2.9, 1.8]) {
      translate([0, 0.5 * base_plate_dim_y - y, 0])
        rotate([-90, 0, 0])
          intermediate_busbar();
    }
  }
  if (show_panels) {
    panels(flip_pcbs=flip_pcbs, third_pcb=third_pcb);
  }
  if (show_outlet) {
    translate([0, 0, -module_120_height - large_spacer_stack_height])
      rotate([180, 0, 0]) outlet(flip_terminals=flip_terminals);
  }
  if (show_inlet) {
    translate([0, 0, module_120_height + 0.5 * large_spacer_stack_height])
      rotate([0, 0, 180])
        inlet(flip_terminals=flip_terminals);
  }
}

module_240();
