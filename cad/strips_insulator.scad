include <parameters.scad>
use <base_plate.scad>

module strips_insulator() {
  difference() {
    base_plate(
      height=strips_insulator_stack_height,
      center=true,
      shorter_end=true,
      nickel_passages=true
    );
    // Copper strips pockets
    for (x = [-2.5:2.5]) {
      translate([x * d, 0, 50]) {
        cube(
          [
            copper_width + 2 * strips_clearance,
            1000,
            100,
          ], center=true
        );
      }
    }
    // Nickel strips pockets
    for (y1 = [-0.5:0.5], y2 = [-2:2]) {
      translate([0, y1 * d + y2 * (d + d + cell_isolation), 50]) {
        cube(
          [
            1000,
            nickel_width + 2 * strips_clearance,
            100,
          ], center=true
        );
      }
    }
  }
}

strips_insulator();
