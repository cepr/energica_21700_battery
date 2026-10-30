include <parameters.scad>;
use <terminal_busbar.scad>;

w = 5;
r = 3;

*translate([0, 0, 3.5 + w])
  rotate([90, 0, 0])
    terminal_busbar();

translate([-75, 0, 0])
  difference() {
    union() {

      cube([150, w + 2.3 + r * 2, 12]);
      translate([0, r + w + 2.3, 12])
        rotate([0, 90, 0])
          cylinder(h=150, r=r);
    }
    translate([-500, w, w])
      cube([1000, 2.3, 100]);
  }
