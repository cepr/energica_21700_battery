include <parameters.scad>
use <colors.scad>

module intermediate_busbar_2d() {
  length = 5 * d + copper_width + 2 * strips_clearance + 2 * holder_walls;
  echo("intermediate_busbar_length", length);
  echo("intermediate_busbar_width", large_spacer_stack_height);
  difference() {
    square(
      [
        length,
        large_spacer_stack_height,
      ], center=true
    );
    for (x = [-2.5:2.5]) {
      translate([x * d, 0]) {
        circle(d=4.3);
      }
    }
  }
}

// intermediate_busbar.dxf was generated from KiCad

module intermediate_busbar() {
  copper() linear_extrude(height=1) {
      import("intermediate_busbar.dxf");
    }
}

intermediate_busbar();
