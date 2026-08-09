include <parameters.scad>
use <base_plate.scad>
use <LiBAL_s-BMS.scad>
use <large_spacer.scad>

module outlet() {
  //bms_shift_x = d / 2;
  //bms_shift_y = 5;
  // LMUs
  // translate([bms_shift_x, bms_shift_y, outlet_height + 5 + 0.01])
  //   rotate([0, 0, 90])
  //     LMUx2();
  // difference() {
  //   union() {
  //base_plate(height=outlet_height);
  large_spacer();
  // for (x = [-43, 43], y = [-73, 73]) {
  //   translate([x + bms_shift_x, y + bms_shift_y, 0])
  //     cylinder(h=outlet_height + 5, d=10);
  // }
  // }
  // Holes for the m4 inserts
  // for (x = [-43, 43], y = [-73, 73]) {
  //   translate([x + bms_shift_x, y + bms_shift_y, 0])
  //     cylinder(h=100, d=m4_insert_od, center=true);
  // }
  // }
}

outlet();
