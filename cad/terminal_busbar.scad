include <parameters.scad>;
use <colors.scad>;

module terminal_busbar() {
  copper() linear_extrude(height=busbar_thickness) {
      // DXF generated with KiCad
      import("terminal_busbar.dxf");
    }
}

terminal_busbar();
