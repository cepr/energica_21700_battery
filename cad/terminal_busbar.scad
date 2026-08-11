include <parameters.scad>;
use <colors.scad>;
use <crimp_terminal.scad>;

module terminal_busbar() {
  copper() linear_extrude(height=busbar_thickness) {
      // DXF generated with KiCad
      import("terminal_busbar.dxf");
    }
  translate([0, 16, 2.5])
    rotate([0, 0, 90])
      crimp_terminal_awg2_0();
}

terminal_busbar();
