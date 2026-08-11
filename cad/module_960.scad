include <parameters.scad>
use <module_240.scad>
use <bulkhead.scad>

// ISO 8855 Convention:
// x towards front
// y towards left
// z towards top

/**
 * Entire battery pack in the vehicle convention, centered at the origin.
 */
module module_960() {
  for (y = [-0.5, 0.5], z = [-0.5, 0.5]) {
    translate(
      [
        0,
        y * (case_dim_x + bulkhead_thickness),
        z * 258,
      ]
    ) {
      rotate([z > 0 ? 180 : 0, 0, 0])
        rotate([0, 0, 90]) {
          rotate([90, 0, 0]) {
            translate([0, 0, -20])
              module_240(flip_cells=z == y, flip_terminals=z == y);
          }
        }
    }
  }

  rotate([90, 0, 0])
    rotate([0, 0, -90])
      bulkhead();
}

// Labels
translate([300, 0, 10])
  rotate([90, 0, 0])
    linear_extrude(height=10, center=true)
      scale(3)
        text("FRONT ->");

module_960();
