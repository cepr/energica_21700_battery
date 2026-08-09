include <parameters.scad>
use <module_240.scad>

/**
 * Change from upright cell (along z axis) to the vehicle convention (ISO 8855 Convention: x towards front, y towards left, z towards top)
 */
module toVehicleConvention() {
  rotate([0, 0, -90]) rotate([90, 0, 0]) children();
}

/**
 * Entire battery pack in the vehicle convention, centered at the origin.
 */
module module_960() {
  for (y = [-0.5, 0.5], z = [-0.5, 0.5]) {
    translate(
      [
        0,
        y * (6 * d + bulkhead_y_thickness),
        z * (10 * d + 4 * cell_isolation + bulkhead_z_thickness),
      ]
    ) {
      toVehicleConvention() {
        module_240();
      }
    }
  }
}

// Labels
translate([300, 0, 10]) rotate([90, 0, 0]) scale(3) text("FRONT ->");

module_960();
