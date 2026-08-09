include <parameters.scad>
include <colors.scad>

module copper_strip(length) {
  copper()
    translate([0, length / 2, 0])
      cube([copper_width, length, copper_plate_thickness], center=true);
  translate([0, length, 0]) {
    children();
  }
}

module nickel_strip(length) {
  nickel()
    translate([0, length / 2, 0])
      cube([nickel_width, length, nickel_plate_thickness], center=true);
  translate([0, length, 0]) {
    children();
  }
}

module copper_bend(angle, radius) {
  copper()
    rotate([0, 90, 0])
      translate([angle > 0 ? -radius : radius, 0, 0])
        rotate_extrude(angle=angle) {
          translate([angle > 0 ? radius : -radius, 0, 0]) square([copper_plate_thickness, copper_width], center=true);
        }

  translate([0, 0, angle > 0 ? radius : -radius])
    rotate([angle, 0, 0])
      translate([0, 0, angle > 0 ? -radius : radius])
        children();
}

module nickel_bend(angle, radius) {
  nickel()
    rotate([0, 90, 0])
      translate([angle > 0 ? -radius : radius, 0, 0])
        rotate_extrude(angle=angle) {
          translate([angle > 0 ? radius : -radius, 0, 0]) square([nickel_plate_thickness, nickel_width], center=true);
        }

  translate([0, 0, angle > 0 ? radius : -radius])
    rotate([angle, 0, 0])
      translate([0, 0, angle > 0 ? -radius : radius])
        children();
}

module nickel_strips(top, height) {
  width = 6;
  nickel() {
    for (y = [0:height - 1]) {
      translate(
        [
          0.5 * d - copper_width / 2,
          (top + y + 0.5) * d - nickel_width / 2,
          0,
        ]
      ) {
        cube(
          [
            (width - 1) * d + copper_width,
            nickel_width,
            nickel_plate_thickness,
          ]
        );
      }
    }
  }
}

module strips() {
  module copper_contact() {
    module half() {
      copper_strip(length=4)
        copper_bend(angle=22.5, radius=2)
          copper_bend(angle=-22.5, radius=2)
            copper_strip(length=5.5 + 1);
    }
    union() {
      half();
      mirror([0, 1, 0]) half();
    }
  }
  module nickel_contact() {
    module half() {
      nickel_strip(length=4)
        nickel_bend(angle=16, radius=2)
          nickel_bend(angle=-16, radius=2)
            nickel_strip(length=6);
    }
    rotate([0, 0, 90])
      union() {
        half();
        mirror([0, 1, 0]) half();
      }
  }
  for (x = [-2.5:2.5], y1 = [-0.5:0.5], y2 = [-2:2]) {
    translate([x * d, y1 * d + y2 * (d + d + cell_isolation), 0]) {
      translate([0, 0, copper_plate_thickness / 2 - cell_holder_stack_height])
        copper_contact();
      translate([0, 0, nickel_plate_thickness / 2 - cell_holder_stack_height + copper_plate_thickness])
        nickel_contact();
    }
  }
}

strips();
