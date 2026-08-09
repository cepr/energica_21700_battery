include <parameters.scad>
use <strips.scad>

// Tool to bend press the copper strips
module copper_press() {
  difference() {
    cube([copper_width + 2, 96, 8], center=true);
    for (y = [0, d, 2 * d + cell_isolation, 3 * d + cell_isolation]) {
      translate([0, y - 29, -cell_holder_stack_height / 2]) {
        scale([2, 1, 2]) copper_contact();
      }
    }
    translate([0, -48 + 4, 0])
      rotate([0, 90, 0])
        cylinder(h=100, d=6, center=true);
  }
}

// Tool to bend press the nickel strips
module nickel_press() {
  difference() {
    translate([-3.5, 0, 0])
      cube([6 * d + 7, nickel_width + 2, 8], center=true);
    for (x = [-2.5:2.5]) {
      translate([x * d, 0, 0]) {
        scale([1, 2, 2]) nickel_contact();
      }
    }
    translate([-3 * d - 3, 0, 0])
      rotate([90, 0, 0])
        cylinder(h=100, d=6, center=true);
  }
}

*copper_press();
nickel_press();
