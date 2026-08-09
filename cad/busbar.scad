include <parameters.scad>
use <colors.scad>

$fn = 64;
copper_thickness = 4.75;

module busbar_2d() {
  difference() {
    hull() {
      for (x = [-2.5, 2.5])
        translate([x * d, 0])
          circle(d=16);
    }
    for (x = [-2.5:2.5]) {
      translate([x * d, 0])
        circle(d=4.5);
    }
    circle(d=6.8); // M8 hole before tapping
  }
}

module busbar() {
  copper() linear_extrude(height=copper_thickness)
      busbar_2d();
}

busbar_2d();
