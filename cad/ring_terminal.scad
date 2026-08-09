include <parameters.scad>

module ring_terminal(bend_angle = 0) {
  rotate([0, 90, 0]) {
    difference() {
      cylinder(d=5.7, h=0.5);
      cylinder(d=3.3, h=10, center=true);
    }
  }

  translate([0, 0, -5.7 / 2]) {
    rotate([0, bend_angle, 0]) {
      translate([0, 0, 5.7 / 2]) {
        translate([2.6 / 2 - 0.3, 0, -4.3 - 0.5 * 5.7])
          scale([2.6, 3.4, 1])
            cylinder(d=1, h=4.3);

        translate([3.7 / 2 - 0.3, 0, -4.3 - 0.5 * 5.7 - 2])
          scale([3.7, 3.9, 1])
            cylinder(d=1, h=2);

        translate([2.6 / 2 - 0.3, 0, -4.3 - 0.5 * 5.7 - 2 - 1])
          cylinder(d=2.3, h=1);

        translate([2.6 / 2 - 0.3, 0, -4.3 - 0.5 * 5.7 - 2 - 1 - 1])
          cylinder(d=1.5, h=1);
      }
    }
  }

  translate([-1.5, 0, 0]) // 1.5 for nut + lock nut
    rotate([0, 90, 0])
      cylinder(d=3, h=8);

  translate([-1.5 - 3.2, 0, 0]) // 1.5 for nut + lock nut
    rotate([0, 90, 0])
      difference() {
        cylinder(d=5.4, h=3.2);
        translate([0, 0, -0.01])
          cylinder(d=2.7, h=2, $fn=6);
      }
}

ring_terminal(bend_angle=0);
