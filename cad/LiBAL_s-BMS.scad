include <parameters.scad>
use <colors.scad>
use <insert.scad>

module LMU() {
  ox = -0.765;
  oy = -2.68;
  oz = 0.85;
  pcb() {
    difference() {
      translate([ox, oy, oz])
        rotate([90, 0, 0])
          import("LiBAL_s-BMS-LMU.stl", convexity=10);
      translate([-35, 0, 3])
        cube([90, 37, 15]);
    }
  }
}

module LMUx2() {
  LMU();
  translate([0, 0, 1.6 * 2 + 15])
    rotate([0, 180, 0]) LMU();
  // HEX spacers
  for (x = [-73, 73], y = [-43, 43]) {
    translate([x, y, 1.6])
      cylinder(h=15, d=8, $fn=6);
  }
}

module BMCU() {
  //pcb() {
  color("yellow")
    translate([8.84, -0.16, 4.4])
      rotate([90, 0, 0])
        import("LiBAL_s-BMS-BMCU.stl", convexity=10);
  //}
}

module LMU_plus_BMCU() {
  LMU();
  translate([0, 0, 1.6 * 2 + 15])
    rotate([0, 180, 0]) BMCU();
  // HEX spacers
  for (x = [-73, 73], y = [-43, 43]) {
    translate([x, y, 1.6])
      cylinder(h=15, d=8, $fn=6);
  }
}

module staggered_stack() {
  //cube([case_dim_z, case_dim_x, 45], center=true);
  for (x = [-2.5:2.5]) {
    translate([40 * x, 0, -5])
      rotate([0, 10, 0]) if (x == -2.5) {
        BMCU();
      } else {
        LMU();
      }
  }
}

// works:
// offset_x = 42;
// offset_z = 3 + 1.6;
// angle = 1.845;

offset_x = 46;
offset_z = 3 + 1.6;
angle = 1.77;

module staggered_recursive(count) {
  if (count) {
    LMU();
    translate([offset_x, 0, offset_z])
      rotate([0, angle, 0])
        staggered_recursive(count - 1);
  }
}

module pcb_negative() {
  translate([0, 0, 1.65 / 2])
    cube([160.5, 100.5, 1.65], center=true);
}

module staggered_spacer() {
  module cut(count) {
    if (count) {
      pcb_negative();
      translate([offset_x, 0, offset_z])
        rotate([0, angle, 0])
          cut(count - 1);
    }
  }
  difference() {
    hull() {
      intersection() {
        minkowski() {
          translate([-90, 0, -42 / 2 + 3]) cut(5);
          rotate([90, 0, 0])
            cylinder(h=10, d=6, center=true);
        }
        translate([-case_dim_z / 2, -6 / 2 + 100 / 2, -42 / 2])
          cube([case_dim_z, 6, 42]);
      }
    }

    translate([-90, 0, -42 / 2 + 3])
      cut(5);

    translate([90, 0, 18])
      rotate([0, 180, 0])
        pcb_negative();
  }
}

module staggered_stack_v2(has_bmcu = true) {
  translate([-90, 0, -42 / 2 + 3]) {
    staggered_recursive(5);
  }
  if (has_bmcu) {
    translate([90, 0, 18])
      rotate([0, 180, 0])
        BMCU();
  }
}

module BMS(has_bmcu) {
  staggered_stack_v2(has_bmcu);
  //for (m = [0, 1]) {
  //mirror([0, m, 0])
  staggered_spacer();
  // }
}

*LMUx2();
*LMU_plus_BMCU();
staggered_spacer();
*BMS(has_bmcu=true);
