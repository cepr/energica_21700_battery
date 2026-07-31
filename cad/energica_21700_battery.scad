
// ISO 8855 Convention:
// x towards front
// y towards left
// z towards top

// TODO
// - add mounting holes in the holders
// - make the end holders thicker, possibly add water cooling paths
// - add mounting brakets for the bus bars
// - add mounting to the bulkhead
// - build a fixture to help with the spot welding: add chanfrain hole
// - maybe design the holder to be under the strips, instead of above,
//   or maybe both

$fn = 64;

aluminum_thickness = 0.04 * 25.4; // 5052 H32 Aluminum for the case
case_dim_x = 137; // external dimensions, must be 137 to match the EIG battery box
case_dim_y = 235; // 235 is the max, can be smaller
case_dim_z = 355; // 

fish_paper_thickness = 0.2;
h = 70.6 + fish_paper_thickness; // cell max height including the fish paper ring
d = 21.5; // cell max diameter

cell_isolation = 1; // minimum separation between cells not in parallel

cell_spacing_vertical = 3;

plate_disk_dia = 14;
copper_width = 10;
nickel_width = 8;
plate_slot_length = 8;
plate_slot_width = 0.7;
copper_plate_thickness = 0.15;
nickel_plate_thickness = 0.15;
strips_pocket_height = 0.5;
plates_thickness = copper_plate_thickness + nickel_plate_thickness;

bulkhead_y_thickness = 15;
bulkhead_z_thickness = 5;

strips_clearance = 0.5;
holder_pocket_height = 3;
holder_walls = 0.5;
holder_strips_height = 0.3;
holder_thickness = cell_spacing_vertical + holder_pocket_height * 2;

exploded = $t * 50;

// m3_nut_width = 5.43 + 0.2;
// m3_nut_height = 2.20 + 0.2;

/**
 * Change from upright cell (along z axis) to the vehicle convention (ISO 8855 Convention: x towards front, y towards left, z towards top)
 */
module toVehicleConvention() {
  rotate([0, 0, -90]) rotate([90, 0, 0]) children();
}

/**
 * Single cell, along the z axis, centered at the origin.
 */
module cell() {
  translate([0, 0, -h / 2]) {
    translate([0, 0, 3 * h / 4]) color("#802020") cylinder(d=d, h=h / 4 - fish_paper_thickness - 0.01);
    color("#202020") cylinder(d=d, h=3 * h / 4);
    color("#1b4d44") translate([0, 0, h - fish_paper_thickness]) difference() {
          cylinder(d=21, h=fish_paper_thickness);
          cylinder(d=12, h=10, center=true);
        }
  }
}
*cell();

/**
 * 12 cells as a 6x2 pack, along the z axis, the pack centered at the origin.
 */
module cell_12() {
  for (x = [-2.5:2.5], y = [-0.5:0.5]) {
    translate([d * x, d * y, 0]) {
      cell();
    }
  }
}
*cell_12();

/**
 * 60 cells as a 6x10 pack, along the y axis, the pack centered at the origin.
 */
module cell_60() {
  for (y = [-2:2]) {
    translate([0, y * (d + d + cell_isolation), 0]) {
      if (y % 2 == 0)
        cell_12();
      else
        mirror([0, 0, 1])
          cell_12();
    }
  }
}
*cell_60();

module module_60(negative_terminal = "screw", positive_terminal = "screw") {
  // Top holder
  *translate([0, 0, exploded]) rotate([180, 0, 0]) half_holder();

  // Top Nickel
  for (y1 = [-0.5:0.5], y2 = [-2:2]) {
    translate(
      [
        -2.9 * d,
        y1 * d + y2 * (d + d + cell_isolation),
        h / 2 + nickel_plate_thickness / 2 + copper_plate_thickness,
      ]
    ) {
      rotate([0, 0, -90]) {
        if (y1 == -0.5 && (y2 == -1 || y2 == 1)) {
          nickel_strip(length=(6 * d))
            nickel_bend(-90, 2)
              difference() {
                nickel_strip(10);
                translate([0, 5, 0]) cylinder(h=10, d=3.2, center=true); // M3 hole
              }
        } else {
          nickel_strip(length=(2.9 * 2 * d));
        }
      }
    }
  }

  // Top copper
  for (y = [-3 * d - 1.5 * cell_isolation, d + 0.5 * cell_isolation]) {
    translate([0, y, (h + copper_plate_thickness) / 2])
      copper_strips();
  }
  for (x = [-2.5:2.5]) {
    translate([x * d, 3.2 * d + 2 * cell_isolation, h / 2 + copper_plate_thickness / 2]) {
      if (positive_terminal == "screw") {
        copper_strip(2 * d + copper_plate_thickness)
          copper_bend(90, 2)
            difference() {
              copper_strip(12.85);
              translate([0, 7.85, 0]) cylinder(h=10, d=3.2, center=true); // M3 hole
            }
      } else if (positive_terminal == "folded") {
        copper_strip(1.6 * d)
          copper_bend(180, (cell_spacing_vertical - copper_plate_thickness) / 6)
            copper_strip(0.5 * d)
              copper_bend(-90, (cell_spacing_vertical - copper_plate_thickness) / 6);
      }
    }
  }

  // Cells
  cell_60();

  // Bottom copper
  for (y = [-d - 0.5 * cell_isolation, 3 * d + 1.5 * cell_isolation]) {
    translate([0, y, -h / 2 - copper_plate_thickness / 2])
      copper_strips();
  }
  mirror([0, 1, 0]) {
    for (x = [-2.5:2.5]) {
      translate([x * d, 3.2 * d + 2 * cell_isolation, -h / 2 - copper_plate_thickness / 2]) {
        if (negative_terminal == "screw") {
          copper_strip(2 * d)
            copper_bend(90, 2)
              difference() {
                copper_strip(10);
                translate([0, 5, 0]) cylinder(h=10, d=3.2, center=true); // M3 hole
              }
        } else if (negative_terminal == "folded") {
          copper_strip(1.6 * d)
            copper_bend(-180, (cell_spacing_vertical - copper_plate_thickness) / 6)
              copper_strip(0.5 * d)
                copper_bend(90, (cell_spacing_vertical - copper_plate_thickness) / 6);
        }
      }
    }
  }

  // Bottom Nickel
  for (y1 = [-0.5:0.5], y2 = [-2:2]) {
    translate(
      [
        -2.9 * d,
        y1 * d + y2 * (d + d + cell_isolation),
        -h / 2 - nickel_plate_thickness / 2 - copper_plate_thickness,
      ]
    ) {
      rotate([0, 0, -90]) {
        if (y1 == -0.5 && (y2 == -2 || y2 == 0 || y2 == 2)) {
          nickel_strip(length=(6 * d))
            nickel_bend(90, 2)
              difference() {
                nickel_strip(10);
                translate([0, 5, 0]) cylinder(h=10, d=3.2, center=true); // M3 hole
              }
        } else {
          nickel_strip(length=(2.9 * 2 * d));
        }
      }
    }
  }

  // Bottom holder
  *translate([0, 0, -exploded]) half_holder();
}
module_60_height = h + cell_spacing_vertical + exploded * 2;
*module_60();

module EIG() {
  cube([137, 235, 355], center=true);
}

module copper_bent_strip() {
  copper_length = 3 * d + nickel_width;
  bend_radius = cell_spacing_vertical / 2 - copper_plate_thickness / 2;
  bend_length = bend_radius * PI;
  flat_part_length = (copper_length - bend_length) / 2;
  for (x = [-2.5:2.5]) {
    translate(
      [
        x * d,
        3.5 * d + 2 * cell_isolation - 0.3 * d,
        -cell_spacing_vertical / 2 + copper_plate_thickness / 2 - exploded * 1.5,
      ]
    )
      copper_strip(length=flat_part_length)
        copper_bend(90, bend_radius)
          copper_strip(length=exploded * 3)
            copper_bend(90, bend_radius)
              copper_strip(length=flat_part_length);
  }
}

module module_120(negative_terminal = "screw", positive_terminal = "screw") {
  translate([0, 0, -0.5 * (module_60_height + exploded)]) {
    module_60(positive_terminal="folded", negative_terminal=negative_terminal);
  }

  // copper_bent_strip();

  translate([0, 0, 0.5 * (module_60_height + exploded)]) {
    rotate([0, 0, 180])
      mirror([1, 0, 0])
        module_60(negative_terminal="folded", positive_terminal=positive_terminal);
  }
}
module_120_height = module_60_height * 2 + exploded;
*module_120();

/**
 * 240 cells as a 6x10x4 pack, along the z axis, the pack centered at the origin.
 */
module module_240() {
  for (z = [-0.5:0.5]) {
    translate([0, 0, z * (module_120_height + exploded)]) {
      module_120(negative_terminal=(z < 0 ? "screw" : "folded"), positive_terminal=(z < 0 ? "folded" : "screw"));
    }
  }

  // Copper to connect the two pack of 240 cells
  //mirror([0, 1, 0])
  //copper_bent_strip();

  // Positive terminal at the top
  // mirror([0, 0, 1]) terminal();
}
module_240_height = module_120_height * 2 + exploded;
*module_240();

/**
 * Entire battery pack in the vehicle convention, centered at the origin.
 */
module module_960() {
  for (y = [-0.5, 0.5], z = [-0.5, 0.5]) {
    translate(
      [
        0,
        y * (6 * d + bulkhead_y_thickness),
        z * (10 * d + 4 * cell_isolation + bulkhead_z_thickness),
      ]
    ) {
      toVehicleConvention() {
        module_240();
      }
    }
  }
}
*module_960();

module cell_array(top, height, direction) {
  left = 0;
  width = 6;
  for (x = [left:left + width - 1]) {
    for (y = [top:top + height - 1]) {
      translate(
        [
          d * (x + 0.5),
          d * (y + 0.5),
          0,
        ]
      ) {
        if (direction < 0) {
          translate([0, 0, h])
            mirror([0, 0, 1]) cell();
        } else {
          cell();
        }
      }
    }
  }
}

module copper_strips() {
  color("#b87333") {
    for (x = [-2.5:2.5]) {
      translate([x * d, 0, 0]) {
        cube(
          [
            copper_width,
            3 * d + cell_isolation + 0.7 * d,
            copper_plate_thickness,
          ],
          center=true
        );
      }
    }
  }
}

module copper_strip(length) {
  color("#b87333")
    translate([0, length / 2, 0])
      cube([copper_width, length, copper_plate_thickness], center=true);
  translate([0, length, 0]) {
    children();
  }
}

module nickel_strip(length) {
  color("#9a9590")
    translate([0, length / 2, 0])
      cube([nickel_width, length, nickel_plate_thickness], center=true);
  translate([0, length, 0]) {
    children();
  }
}

module copper_bend(angle, radius) {
  color("#b87333")
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
  color("#9a9590")
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
  color("#9a9590") {
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

module half_holder() {
  module cooling_hole() {
    render() {
      difference() {
        cube(
          [
            d * 0.8,
            d * 0.8,
            99,
          ], center=true
        );
        for (x = [-0.5, 0.5], y = [-0.5, 0.5]) {
          translate([x * d, y * d])
            cylinder(h=100, d=d + holder_walls * 2, center=true);
        }
        // copper
        for (x = [-0.5, 0.5]) {
          translate([x * d, 0, 0]) {
            cube(
              [
                copper_width + strips_clearance * 2 + holder_walls * 2,
                100,
                100,
              ], center=true
            );
          }
        }
        // nickel
        for (y = [-0.5, 0.5]) {
          translate([0, y * d, 0]) {
            cube(
              [
                100,
                nickel_width + strips_clearance * 2 + holder_walls * 2,
                100,
              ], center=true
            );
          }
        }
      }
    }
  }

  module cooling_hole_larger() {
    render() {
      union() {
        for (y = [-0.5, 0.5]) {
          translate([0, y * cell_isolation, 0]) cooling_hole();
        }
      }
    }
  }

  render(convexity=15) {
    translate(
      [
        0,
        0,
        -h / 2 - cell_spacing_vertical / 2,
      ]
    ) {
      difference() {
        translate([0, 0, holder_thickness / 4]) {
          cube(
            [
              d * 6,
              d * 10 + cell_isolation * 4,
              holder_thickness / 2,
            ],
            center=true
          );
        }

        // Cooling holes
        render() {
          for (x = [-2:2], y = [-4:4]) {
            translate(
              [
                x * d,
                y * d + y / 2 * cell_isolation,
                0,
              ]
            ) {
              if (y % 2) {
                cooling_hole_larger();
              } else {
                cooling_hole();
              }
            }
          }
        }

        // Pockets for the cells
        for (x = [-2.5:2.5], y1 = [-0.5:0.5], y2 = [-2:2]) {
          translate([x * d, y1 * d + y2 * (d + d + cell_isolation)]) {
            translate([0, 0, holder_thickness / 2 - holder_pocket_height])
              cylinder(h=10, d=d);
          }
        }

        // Pockets for the copper strips
        for (x = [-2.5:2.5]) {
          translate(
            [
              x * d,
              0,
              5 + strips_pocket_height,
            ]
          ) {
            cube(
              [
                copper_width + strips_clearance * 2,
                20 * d, // much longer than needed
                10,
              ], center=true
            );
          }
        }

        // Pockets for the nickel strips
        for (y1 = [-2:2], y2 = [-0.5, 0.5]) {
          translate(
            [
              0,
              y1 * (d + d + cell_isolation) + y2 * d,
              5 + strips_pocket_height,
            ]
          ) {
            cube(
              [
                5 * d + copper_width + strips_clearance * 2,
                nickel_width + strips_clearance * 2,
                10,
              ], center=true
            );
          }
        }

        // Holes for copper strip to go to the next level of cells
        for (x = [-2.5:2.5]) {
          translate(
            [
              x * d,
              -50 - 4.5 * d - 2 * cell_isolation - nickel_width / 2,
              0,
            ]
          ) {
            cube(
              [
                copper_width + strips_clearance * 2,
                100,
                100,
              ],
              center=true
            );
          }
        }
      }
    }
  }
}

module holders() {
  for (z = [-1.5:1.5]) {
    translate([0, 0, z * (h + cell_spacing_vertical)]) {
      half_holder();
    }
  }
}

module BMS() {
  //cube([100, 1.6, 160], center=true);
  color("#008c32")
    import("LMU_Assembly.stl");
}

module holder_sample_2x4() {
  intersection() {
    half_holder();
    cube([2 * d, 4 * d, 100], center=true);
  }
}

module fixture() {
  difference() {
    translate([0, 0, 25]) cube([6 * d + 10, 10 * d + 4 * cell_isolation, 50], center=true);
    for (x = [-2.5:2.5], y1 = [-0.5, 0.5], y2 = [-2:2]) {
      translate([x * d, y1 * d + y2 * (d + d + cell_isolation), 5])
        cylinder(h=51, d=d);
    }
  }
}

// Labels
translate([300, 0, 10]) rotate([90, 0, 0]) scale(3) text("FRONT ->");

// Elements
module_240();
*EIG();
