include <parameters.scad>
use <colors.scad>

module hex_standoff_m4x15() {
  copper()
    union() {
      cylinder(h=15, d=6.925, center=false, $fn=6);
      cylinder(h=15 + 6, d=3.5, center=false);
    }
}

hex_spacer_m4x15();
