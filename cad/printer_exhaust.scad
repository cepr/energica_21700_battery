include <parameters.scad>;
use <fan_92x92x38.scad>;

show_fan = false;

OD = 70;
ID = OD - 2 * inlet_walls;

module printer_exhaust() {
  difference() {
    union() {
      hull() {
        for (x = [-0.5, 0.5], y = [-0.5, 0.5]) {
          translate([x * 82.5, y * 82.5, 0])
            cylinder(d=9.5, h=7, center=false);
        }
      }

      cylinder(d=OD, h=38);
    }
    cylinder(d=ID, h=200, center=true);
    for (x = [-0.5, 0.5], y = [-0.5, 0.5]) {
      translate([x * 82.5, y * 82.5, 0])
        cylinder(d=4.5, h=100, center=true);
    }
  }
  if (show_fan) {
    translate([0, 0, -38])
      fan_92x92x38();
  }
}

module print_exhause_modifier() {
  for (x = [-0.5, 0.5], y = [-0.5, 0.5]) {
    translate([x * 82.5, y * 82.5, 0])
      cylinder(d=9.5, h=10);
  }
}

printer_exhaust();
%print_exhause_modifier();

// window opening: 46" x 1"
