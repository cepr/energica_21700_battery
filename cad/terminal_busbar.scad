include <parameters.scad>;
use <colors.scad>;
use <crimp_terminal.scad>;

show_ring_terminal = false;
show_second_plate = false;

module terminal_busbar() {
  copper()for (z = show_second_plate ? [0, busbar_thickness + copper_plate_thickness] : [0]) {
    translate([0, 0, z])
      linear_extrude(height=busbar_thickness) {
        // DXF generated with KiCad
        import("terminal_busbar.dxf");
      }
  }
  if (show_ring_terminal) {
    translate([-38, 16, 2 * busbar_thickness + copper_plate_thickness])
      rotate([0, 0, 90])
        crimp_terminal_awg2_0();
  }
}

terminal_busbar();
