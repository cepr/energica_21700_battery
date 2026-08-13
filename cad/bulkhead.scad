include <parameters.scad>;

module bulkhead() {
  difference() {
    translate([-10, 0, 0])
      cube([500, 420, 20], center=true);

    for (y1 = [-0.5, 0.5], y2 = [-2:2]) {
      translate([0, y1 * 12 + y2 * 70, 0]) {
        cylinder(h=100, d=5, center=true);
      }
    }

    for (y1 = [-2.5:2.5]) {
      translate([2, y1 * 70, 0]) {
        hull() {
          for (y = [-0.5, 0.5]) {
            translate([0, y * (45.6 - 31.8), 0])
              cylinder(h=100, d=31.8, center=true);
          }
        }
      }
    }

    for (x = [-1, 0], y = [-0.5, 0.5]) {
      translate([x * 258 + 5, y * 396, 0])
        cylinder(h=100, d=5, center=true);
    }
  }
}

bulkhead();
