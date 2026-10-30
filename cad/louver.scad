include <parameters.scad>;
use <insert.scad>;

step = 4;

module louver_external() {
  difference() {
    translate([0, 0, 2 * step])
      difference() {
        cylinder(h=3 * step, d1=90, d2=90 - 6 * step);
        translate([0, 0, -step])
          cylinder(h=3 * step, d1=90, d2=90 - 6 * step);
      }
    // Mounting holes
    for (a = [0:45:360 - 45]) {
      rotate([0, 0, a])
        translate([-37, 0, 10])
          rotate([0, -45, 0])
            union() {
              cylinder(h=100, d=3.5, center=true);
              translate([0, 0, 4.2 - 1.5])
                cylinder(h=100, d=7, center=false);
            }
    }
  }
}

module louver_internal() {
  difference() {
    union() {
      // Walls for the inserts
      for (a = [0:45:360]) {
        rotate([0, 0, a])
          translate([-37, 0, 10])
            rotate([0, -45, 0])
              translate([0, 0, -1])
                cylinder(h=2.9 + 2, d=m3_insert_od + 2 * 2, center=true);
      }
      cylinder(h=3 * step, d1=90, d2=90 - 6 * step);
    }

    difference() {
      cylinder(h=2 * step, d=100, center=true);
      cylinder(h=100, d=70, center=true);
    }

    intersection() {
      rotate([0, 45, 0])for (x = [-100:5:100])
        translate([x, 0, 0])
          cube([5 - 0.6 * sqrt(2), 100, 100], center=true);
      cylinder(h=1000, d=60, center=true);
    }

    // Holes for the inserts
    for (a = [0:45:360]) {
      rotate([0, 0, a])
        translate([-37, 0, 10])
          rotate([0, -45, 0])
            cylinder(h=9, d=m3_insert_od, center=true);
    }
  }
}

module louver_x2() {
  intersection() {
    for (x = [-45, 45]) {
      translate([x, 0, 0]) {
        louver_external();
        louver_internal();
        for (a = [0:45:360]) {
          rotate([0, 0, a])
            translate([-37, 0, 10])
              rotate([0, -45, 0])
                translate([0, 0, -2.6])
                  insert_m3();
        }
      }
    }
    translate([0, -500, 0])
      cube([1000, 1000, 1000], center=true);
  }
}

*louver_external();
louver_internal();
*louver_x2();
