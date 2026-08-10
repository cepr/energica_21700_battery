include <parameters.scad>
use <colors.scad>

module intermediate_busbar() {
  copper() linear_extrude(height=busbar_thickness) {
      // intermediate_busbar.dxf was generated from KiCad
      import("intermediate_busbar.dxf");
    }
}

intermediate_busbar();
