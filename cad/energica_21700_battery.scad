
// ISO 8855 Convention:
// x towards front
// y towards left
// z towards top

// TODO
// - design the top and bottom holders
//   - captured nuts for terminals
//     - add separators between the terminals
//   - coolant?
//   - mounting holes for the BMS boards
//   - add mounting to the bulkhead
//   - make it wavy for better rigidity
// - build a fixture to help with the spot welding: add chanfrain hole
//
// - buy heat shrink tubing for the nickel strips
//   - 
//
// - Design walls between the cells in series so I can remove their wrapping for better thermal
//   - this cannot be integrated with the holder as this would interfere with the strips

$fn = 64;

aluminum_thickness = 0.04 * 25.4; // 5052 H32 Aluminum for the case
case_dim_x = 137; // external dimensions, must be 137 to match the EIG battery box
case_dim_y = 235; // 235 is the max, can be smaller
case_dim_z = 355; // 

fish_paper_thickness = 0.2;
h = 70.6 + fish_paper_thickness; // cell max height including the fish paper ring
d = 21.5; // cell max diameter

cell_isolation = 1; // minimum separation between cells not in parallel

cell_spacing_vertical = 4;

plate_disk_dia = 14;
copper_width = 10;
copper_length = 9.8 * d;

nickel_width = 8;
nickel_length = 5.8 * d; // length of the nickel strip to connect 6 cells

plate_slot_length = 8;
plate_slot_width = 0.7;
copper_plate_thickness = 0.15;
nickel_plate_thickness = 0.15;
strips_pocket_height = 1;

plates_thickness = copper_plate_thickness + nickel_plate_thickness;

bulkhead_y_thickness = 15;
bulkhead_z_thickness = 5;

strips_clearance = 0.5;
holder_pocket_height = 3;
holder_walls = 0.5;

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

module module_60() {
  // Top holder
  translate([0, 0, exploded]) rotate([180, 0, 0]) {
      half_holder(variant="B");
    }

  // How much to extend the nickel strip connecting 6 cells before the bend
  nickel_extend = 2.5;

  // Top Nickel
  for (y1 = [-0.5:0.5], y2 = [-2:2]) {
    translate(
      [
        -nickel_length / 2,
        y1 * d + y2 * (d + d + cell_isolation),
        h / 2 + nickel_plate_thickness / 2 + copper_plate_thickness,
      ]
    ) {
      rotate([0, 0, -90]) {
        if (y1 == -0.5 && (y2 == -1 || y2 == 1)) {
          nickel_strip(length=nickel_length + nickel_extend)
            nickel_bend(-90, 2)
              nickel_strip(50);
        } else {
          nickel_strip(length=nickel_length);
        }
      }
    }
  }

  // Top copper
  module bottom_copper() {
    mirror([0, 1, 0]) {
      for (x = [-2.5:2.5]) {
        translate(
          [
            x * d,
            0,
            -h / 2 - copper_plate_thickness / 2 + 0.01,
          ]
        ) {
          translate(
            [
              0,
              4 * d + 2 * cell_isolation - 0.9 * d,
              0,
            ]
          ) {
            copper_strip(1.6 * d)
              copper_bend(-180, (cell_spacing_vertical - copper_plate_thickness) / 6)
                copper_strip(0.6 * d)
                  copper_bend(90, (cell_spacing_vertical - copper_plate_thickness) / 6);
          }

          color("#b87333") translate([0, d, 0])
              cube([copper_width, 3.8 * d, copper_plate_thickness], center=true);

          color("#b87333") translate([0, -3 * d, 0])
              cube([copper_width, 3.8 * d, copper_plate_thickness], center=true);
        }
      }
    }
  }
  rotate([180, 0, 0]) bottom_copper();

  // Top inner holder
  inner_holder();

  // Cells
  *cell_60();

  // Bottom copper
  bottom_copper();

  // Bottom Nickel
  *for(y1=[-0.5:0.5], y2=[-2:2]) {
    translate(
      [
        -nickel_length / 2,
        y1 * d + y2 * (d + d + cell_isolation),
        -h / 2 - nickel_plate_thickness / 2 - copper_plate_thickness,
      ]
    ) {
      rotate([0, 0, -90]) {
        if (y1 == -0.5 && (y2 == -2 || y2 == 0 || y2 == 2)) {
          nickel_strip(length=nickel_length + nickel_extend)
            nickel_bend(-90, 2)
              nickel_strip(50);
        } else {
          nickel_strip(length=(nickel_length));
        }
      }
    }
  }

  // Bottom holder
  translate([0, 0, -exploded]) {
    half_holder(variant="A");
  }
}
module_60_height = h + cell_spacing_vertical + exploded * 2;

module EIG() {
  cube([case_dim_x, case_dim_y, case_dim_z], center=true);
}

module module_120(negative_terminal = "screw", positive_terminal = "screw") {
  translate([0, 0, -0.5 * (module_60_height + exploded)]) {
    module_60();
  }

  translate([0, 0, 0.5 * (module_60_height + exploded)]) {
    rotate([0, 0, 180])
      mirror([1, 0, 0])
        module_60();
  }
}
module_120_height = module_60_height * 2 + exploded;

/**
 * 240 cells as a 6x10x4 pack, along the z axis, the pack centered at the origin.
 */
module module_240() {
  translate([0, 0, -0.5 * (module_120_height + exploded)]) {
    module_120(negative_terminal=("screw"), positive_terminal=("folded"));
  }
  translate([0, 0, 0.5 * (module_120_height + exploded)]) {
    mirror([1, 0, 0])
      module_120(negative_terminal=("folded"), positive_terminal=("screw"));
  }
}

module_240_height = module_120_height * 2 + exploded;

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

module passage_with_chanfrain(width) {
  rotate([90, 0, 0])
    linear_extrude(height=width + 2 * strips_clearance, center=true) {
      difference() {
        translate([-2.5, -50]) square([3, 100]);
        hull() {
          translate([-2.5, -2]) circle(r=2);
          translate([-2.5, -50]) circle(r=2);
        }
      }
    }
}

module nickel_passage_with_chanfrain() {
  passage_with_chanfrain(nickel_width);
}

ring_isolation_thickness = 0.2;

module inner_holder() {
  intersection() {
    difference() {
      union() {
        h = ring_isolation_thickness + holder_pocket_height;
        for (x = [-2.5:2.5], y1 = [-0.5:0.5], y2 = [-2:2]) {
          translate(
            [
              x * d,
              y1 * d + y2 * (d + d + cell_isolation),
            ]
          ) {
            cylinder(d=d + holder_walls * 2, h=h);
          }
        }
        for (x = [-2.5:2.5]) {
          translate([x * d, 0, h / 2]) {
            cube(
              [
                d - copper_width - 0.2 * 2 + holder_walls * 2,
                10 * d + 4 * cell_isolation,
                h,
              ], center=true
            );
          }
        }
      }

      // What to remove
      for (x = [-2.5:2.5], y1 = [-0.5:0.5], y2 = [-2:2]) {
        // Pocket for the cells
        translate(
          [
            x * d,
            y1 * d + y2 * (d + d + cell_isolation),
            ring_isolation_thickness,
          ]
        ) {
          cylinder(d=d, h=100);
        }
        translate(
          [
            x * d,
            y1 * d + y2 * (d + d + cell_isolation),
            0,
          ]
        ) {
          cube(
            [
              copper_width + 0.2,
              d * 0.5,
              2 * ring_isolation_thickness + 0.05,
            ], center=true
          );
        }
      }
    }

    cube(
      [
        6 * d - 0.1,
        10 * d + 4 * cell_isolation - 0.1,
        100,
      ], center=true
    );
  }
}

module base_holder() {
  module cooling_hole() {
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

  module cooling_hole_larger() {
    union() {
      for (y = [-0.5, 0.5]) {
        translate([0, y * cell_isolation, 0]) cooling_hole();
      }
    }
  }

  difference() {
    union() {
      difference() {
        translate([0, 0, (h + cell_spacing_vertical) / 4]) {
          cube(
            [
              case_dim_x,
              case_dim_y,
              (h + cell_spacing_vertical) / 2,
            ],
            center=true
          );
        }

        // Cooling holes
        for (x = [-2:2], y = [-4:4]) {
          translate(
            [
              x * d,
              y * d + y / 2 * cell_isolation,
              0,
            ]
          ) {
            if (y % 2) {
              render() cooling_hole_larger();
            } else {
              render() cooling_hole();
            }
          }
        }

        // Pockets for the cells
        *for(x=[-2.5:2.5], y1=[-0.5:0.5], y2=[-2:2]) {
          translate([x * d, y1 * d + y2 * (d + d + cell_isolation)]) {
            translate([0, 0, cell_spacing_vertical / 2])
              cylinder(h=100, d=d);
          }
        }

        // Space for the inner holder
        translate([0, 0, 50 + cell_spacing_vertical / 2 - ring_isolation_thickness - 0.1])
          cube(
            [
              6 * d + 0.1,
              10 * d + 4 * cell_isolation + 0.1,
              100,
            ], center=true
          );
      }

      // Mounting hole columns
      for (x = [-3:2:3], y = [-5, 5]) {
        translate([x * d, y * (d + cell_isolation / 2), 0])
          cylinder(h=(h + cell_spacing_vertical) / 2, d=7.5);
      }
      for (x = [-3, 3], y = [-3:2:3]) {
        translate([x * d, y * (d + cell_isolation / 2), 0])
          cylinder(h=(h + cell_spacing_vertical) / 2, d=7.5);
      }
    }

    // Mounting holes
    for (x = [-3:2:3], y = [-5:2:5]) {
      translate(
        [
          x * d,
          y * (d + cell_isolation / 2),
        ]
      ) {
        cylinder(h=100, d=4.5, center=true); // M4 rod
      }
    }
  }
}

module m4_hex_nut() {
  cylinder(h=3.2, d=8.1, center=true, $fn=6);
}

module half_holder(variant = "A") {
  translate(
    [
      0,
      0,
      -h / 2 - cell_spacing_vertical / 2,
    ]
  ) {
    difference() {
      render(convexity=10) base_holder();

      // Pockets for the copper strips
      for (x = [-2.5:2.5]) {
        translate(
          [
            x * d,
            0,
            50 + 0.5 * cell_spacing_vertical - strips_pocket_height,
          ]
        ) {
          cube(
            [
              copper_width + strips_clearance * 2,
              copper_length + 2 * strips_clearance,
              100,
            ], center=true
          );
        }
      }

      // Pockets for the nickel strips
      for (y1 = [-0.5:0.5], y2 = [-2:2]) {
        extend =
          (
            (
              y1 == -0.5 && variant == "A" && (y2 == -2 || y2 == 0 || y2 == 2)
            ) || (
              y1 == 0.5 && variant == "B" && (y2 == -1 || y2 == 1)
            )
          ) ? 4
          : 0;
        translate(
          [
            extend / 2,
            y2 * (d + d + cell_isolation) + y1 * d,
            50 + 0.5 * cell_spacing_vertical - strips_pocket_height,
          ]
        ) {
          cube(
            [
              nickel_length + strips_clearance * 2 + extend,
              nickel_width + strips_clearance * 2,
              100,
            ], center=true
          );
        }
      }

      // vertical (z) passage for the nickel strips
      for (x = [-1, 1], y1 = [-0.5:0.5], y2 = [-2:2]) {
        width = 1;
        translate(
          [
            x * (case_dim_x / 2 - 1 - 0.5 * width),
            y2 * (d + d + cell_isolation) + y1 * d,
            0,
          ]
        ) {
          if (x == 1 && y1 == -0.5 && variant == "A" && (y2 == -2 || y2 == 0 || y2 == 2)) {
            translate([0, 0, cell_spacing_vertical / 2 - strips_pocket_height])
              nickel_passage_with_chanfrain();
          } else {
            cube(
              [
                width,
                nickel_width + strips_clearance * 2,
                100,
              ], center=true
            );
          }
        }
      }

      // Holes for copper strip to go to the next level of cells
      for (x = [-2.5:2.5]) {
        translate(
          [
            x * d,
            -4 * d - 2 * cell_isolation,
            0,
          ]
        ) {
          cube(
            [
              copper_width + strips_clearance * 2,
              1.85 * d,
              100,
            ],
            center=true
          );
        }
      }
    }
  }
}

module BMS() {
  color("#008c32")
    import("LMU_Assembly.stl");
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

module nuts() {
  translate([0, 0, 200]) {
    for (x = [-3:2:3], y = [-5, 5]) {
      translate([x * d, y * (d + cell_isolation / 2), 0]) m4_hex_nut();
    }
    for (x = [-3, 3], y = [-5:2:5]) {
      translate([x * d, y * (d + cell_isolation / 2), 0]) m4_hex_nut();
    }
  }
}

module separator() {
  difference() {
    cube(
      [
        5 * d,
        cell_isolation,
        h,
      ], center=true
    );
    for (x = [-2.5:2.5], z = [-1, 1]) {
      translate([x * d, 0, z * (50 + h / 2 - holder_pocket_height - 0.5)])
        cube([copper_width + 2 * strips_clearance + holder_walls * 2, 100, 100], center=true);
    }
  }
}

module separators() {
  for (y = [-3:2:3]) {
    translate([0, y * (d + cell_isolation / 2), 0]) {
      separator();
    }
  }
}

// Labels
translate([300, 0, 10]) rotate([90, 0, 0]) scale(3) text("FRONT ->");

// Elements
intersection() {
  translate([-500 + d / 2, 0, 0])
    cube([1000, 1000, 1000], center=true);
  *module_60();
  *module_120();
  *base_holder();
  *half_holder(variant="A");
  *base_holder();
  mirror([0, 0, 1]) inner_holder();
}

module copper_cell() {
  module half() {
    copper_strip(length=4)
      copper_bend(angle=18.5, radius=2)
        copper_bend(angle=-18.5, radius=2)
          copper_strip(length=5.5);
  }
  union() {
    half();
    mirror([0, 1, 0]) half();
  }
}

for (y1 = [-0.5:0.5], y2 = [-2:2]) {
  translate([0, y1 * d + y2 * (d + d + cell_isolation), 0]) {
    translate([d / 2, 0, copper_plate_thickness / 2 - ring_isolation_thickness])
      copper_cell();
    translate([0, 0, nickel_plate_thickness / 2])
      rotate([0, 0, -90])
        nickel_strip(length=20);
  }
}

*cell_60();

*for(y=[0], a=[0, 180]) {
  translate([0, y * (d + cell_isolation), 0])
    rotate([a, 0, 0]) {
      translate([0, 0, -h / 2 - ring_isolation_thickness])
        inner_holder();
    }
}

*separator();
*separators();

*EIG();

*cube([137, 10, 10], center=true);

!inner_holder();
