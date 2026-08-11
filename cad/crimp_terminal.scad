include <parameters.scad>
use <colors.scad>

module crimp_terminal_awg2_0() {
  module base_shape() {
    difference() {
      intersection() {
        translate([0, -15 + 8 / 2 + 5.5, 0])
          cylinder(d=30, h=2.5);
        cube([21.1, 100, 100], center=true);
      }
      cylinder(d=8.2, h=100, center=true);
    }
    translate([0, -15 + 8 / 2 + 5.5 - 15, 7.5])
      rotate([90, 0, 0])
        cylinder(d=15, h=53 - 30);
  }

  module modifier() {
    translate([0, -15 + 8 / 2 + 5.5 - 15, 0])
      cube([100, 5, 100], center=true);
  }

  copper() union() {
      hull() {
        intersection() {
          base_shape();
          modifier();
        }
      }
      difference() {
        base_shape();
        modifier();
      }
    }
}

crimp_terminal_awg2_0();
