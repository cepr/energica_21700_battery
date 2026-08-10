include <parameters.scad>

use <strips_insulator.scad>
use <cell_holder.scad>
use <strips.scad>
use <separator.scad>

// exploded = 10;

/**
 * 60 cells as a 6x10 pack, along the y axis, the pack centered at the origin.
 */
module cell_60() {
  /**
 * 12 cells as a 6x2 pack, along the z axis, the pack centered at the origin.
 */
  module cell_12() {
    for (x = [-2.5:2.5], y = [-0.5:0.5]) {
      translate([d * x, d * y, 0]) {
        translate([0, 0, -h / 2]) {
          translate([0, 0, 3 * h / 4]) color("#802020") cylinder(d=d, h=h / 4);
          color("#202020") cylinder(d=d, h=3 * h / 4);
        }
      }
    }
  }
  for (y = [-2:2]) {
    translate([0, y * (d + d + cell_isolation), 0]) {
      if (y % 2 == 0)
        cell_12();
      else
        mirror([0, 0, 1])
          cell_12();
    }
  }
}

module module_60() {
  rotate([0, 180, 0])
    translate([0, 0, -h / 2 - cell_holder_stack_height - strips_insulator_stack_height / 2 - 3 * exploded])
      strips_insulator();

  translate([0, 0, h / 2 + copper_plate_thickness + nickel_plate_thickness + 2 * exploded])
    strips();

  // Top cells holder
  rotate([180, 0, 0])
    translate([0, 0, -h / 2 - cell_holder_stack_height - exploded])
      cell_holder();

  // Cells
  cell_60();

  // Separators
  separators();

  // Bottom cells holder
  translate([0, 0, -h / 2 - cell_holder_stack_height - exploded])
    cell_holder();

  // Bottom copper and nickel
  rotate([180, 0, 0])
    translate([0, 0, h / 2 + copper_plate_thickness + nickel_plate_thickness + 2 * exploded])
      strips();

  rotate([0, 0, 180])
    translate([0, 0, -h / 2 - cell_holder_stack_height - strips_insulator_stack_height / 2 - 3 * exploded])
      strips_insulator();
}

module_60();
