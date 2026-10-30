include <parameters.scad>
use <module_240.scad>
use <bulkhead.scad>
use <LiBAL_s-BMS.scad>
use <panels.scad>

// ISO 8855 Convention:
// x towards front
// y towards left
// z towards top

module module_480() {

  for (a = [0, 180]) {
    rotate([a, 0, 0])
      translate([0, -267.5 / 2, 0])
        module_240(
          flip_cells=false,
          flip_terminals=false,
          //flip_pcbs=z < 0,
          //third_pcb=z > 0 ? "LMU" : y < 0 ? "BMCU" : "NONE"
        );
  }

  double_panel();
}

module_480();

/**
 * Entire battery pack in the vehicle convention, centered at the origin.
 */
module module_960() {
  for (y = [-0.5, 0.5]) {
    translate([0, -150, 0])
      rotate([90, 0, 0])
        rotate([0, 0, 90])
          double_panel();

    for (z = [-0.5, 0.5]) {
      translate(
        [
          0,
          y * (case_dim_x + bulkhead_thickness),
          z * 264, // 258
        ]
      ) {
        rotate([z > 0 ? 180 : 0, 0, 0])
          rotate([0, 0, 90]) {
            rotate([90, 0, 0]) {
              translate([0, 0, -20])
                module_240(
                  flip_cells=z == y,
                  flip_terminals=z == y,
                  flip_pcbs=z < 0,
                  third_pcb=z > 0 ? "LMU" : y < 0 ? "BMCU" : "NONE"
                );
            }
          }
      }
    }
  }

  *for(y=[-0.5, 0.5]) {
    translate([0, y * (case_dim_x + bulkhead_thickness), 0])
      rotate([0, 180, 0])
        BMS(has_bmcu=y < 0);
  }

  translate([0, 0, -1])
    rotate([90, 0, 0])
      rotate([0, 0, -90])
        bulkhead();
}

// Labels
*translate([300, 0, 10])
  rotate([90, 0, 0])
    linear_extrude(height=10, center=true)
      scale(3)
        text("FRONT ->");

*module_960();
