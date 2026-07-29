
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

$fn = 32;

h = 70.6; // cell max height
d = 21.4; // cell max diameter

cell_isolation = 2; // minimum separation between cells not in parallel

cell_spacing_vertical = 2;

plate_disk_dia = 14;
copper_width = 10;
nickel_width = 8;
plate_slot_length = 8;
plate_slot_width = 0.7;
copper_plate_thickness = 0.15;
nickel_plate_thickness = 0.15;
strips_pocket_height = 0.5;
plates_thickness = copper_plate_thickness + nickel_plate_thickness;

vertical_grid = h + cell_spacing_vertical;

bulkhead_y_thickness = 15;
bulkhead_z_thickness = 5;

exploded = $t * 50;

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
    translate([0, 0, 3 * h / 4]) color("#802020") cylinder(d=d, h=h / 4);
    color("#202020") cylinder(d=d, h=3 * h / 4);
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

module module_60() {
  // Top holder
  translate([0, 0, exploded]) rotate([180, 0, 0]) half_holder();

  // Top Nickel

  // Top copper
  for (y = [-3 * d - 1.5 * cell_isolation, d + 0.5 * cell_isolation]) {
    translate([0, y, (h + copper_plate_thickness) / 2])
      copper_strips();
  }

  // Cells
  cell_60();

  // Bottom copper
  for (y = [-d - 0.5 * cell_isolation, 3 * d + 1.5 * cell_isolation]) {
    translate([0, y, -h / 2 - copper_plate_thickness / 2])
      copper_strips();
  }

  // Bottom Nickel

  // Bottom holder
  translate([0, 0, -exploded]) half_holder();
}
module_60_height = h + cell_spacing_vertical + exploded * 2;
*module_60();

module copper_bent_strip() {
  copper_length = 3 * d + nickel_width;
  bend_radius = cell_spacing_vertical / 2 - copper_plate_thickness / 2;
  bend_length = bend_radius * PI;
  flat_part_length = (copper_length - bend_length) / 2;
  for (x = [-2.5:2.5]) {
    translate(
      [
        x * d,
        3.5 * d + 2 * cell_isolation - nickel_width / 2,
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

module module_120() {
  translate([0, 0, -0.5 * (module_60_height + exploded)]) {
    module_60();
  }

  copper_bent_strip();

  translate([0, 0, 0.5 * (module_60_height + exploded)]) {
    rotate([0, 0, 180]) module_60();
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
      module_120();
    }
  }

  // Copper to connect the two pack of 240 cells
  mirror([0, 1, 0])
    copper_bent_strip();

  // Negative and positive bus bars
  module terminal() {
    space_for_nut = 5;
    mirror([0, 1, 0]) {
      for (x = [-2.5:2.5]) {
        translate(
          [
            x * d,
            3.5 * d + 2 * cell_isolation - nickel_width / 2,
            -module_120_height - copper_plate_thickness / 2 + cell_spacing_vertical / 2,
          ]
        )
          copper_strip(length=1.5 * d + 0.5 * nickel_width + space_for_nut)
            copper_bend(90, 5) {
              difference() {
                // square part to attach nut
                copper_strip(copper_width);
                translate([0, copper_width / 2, 0]) cylinder(h=100, d=4.5, center=true);
              }
            }
      }
    }
  }
  // Negative terminal at the bottom
  terminal();
  // Positive terminal at the top
  mirror([0, 0, 1]) terminal();
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
module_960();

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
            3 * d + cell_isolation + nickel_width,
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

module copper_bend(angle, radius) {
  color("#b87333")
    rotate([0, 90, 0])
      translate([angle > 0 ? -radius : radius, 0, 0])
        rotate_extrude(angle=angle) {
          translate([angle > 0 ? radius : -radius, 0, 0]) square([copper_plate_thickness, copper_width], center=true);
        }

  translate([0, 0, radius])
    rotate([angle, 0, 0])
      translate([0, 0, -radius])
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

module quarter() {

  translate(
    [
      2 * vertical_grid,
      -3 * d,
      5 * d,
    ]
  ) rotate([0, 0, 90]) rotate([-90, 0, 0]) {

        *translate([0, 0, -15])
          cube([130, 220, 350]);

        // First battery level
        translate([3 * d, 5 * d, 0]) {
          half_holder();
        }
        translate([0, 0, cell_spacing_vertical / 2]) {
          translate([0, 0, -copper_plate_thickness]) {
            translate([0, 0, -nickel_plate_thickness]) {
              nickel_strips(0, 2);
              nickel_strips(2, 4);
              nickel_strips(6, 4);
            }
            copper_strips(-2, 4);
            copper_strips(2, 4);
            copper_strips(6, 4);
          }
          cell_array(0, 2, 1);
          cell_array(2, 2, -1);
          cell_array(4, 2, 1);
          cell_array(6, 2, -1);
          cell_array(8, 2, 1);
          translate([0, 0, h]) {
            copper_strips(0, 4);
            copper_strips(4, 4);
            copper_strips(8, 2);
            // Fold
            plate_folded_right(0, 9, 6, 0);
            translate([0, 0, copper_plate_thickness]) {
              nickel_strips(0, 4);
              nickel_strips(4, 4);
              nickel_strips(8, 2);
            }
          }
        }
        translate([3 * d, 5 * d, vertical_grid])
          rotate([180, 0, 0])
            half_holder();

        // Second battery level
        translate([3 * d, 5 * d, vertical_grid])
          rotate([0, 0, 180])
            half_holder();

        translate([0, 0, vertical_grid + cell_spacing_vertical / 2]) {
          translate([0, 0, -copper_plate_thickness]) {
            translate([0, 0, -nickel_plate_thickness]) {
              nickel_strips(8, 2);
              nickel_strips(4, 4);
              nickel_strips(0, 4);
            }
            copper_strips(8, 2);
            copper_strips(4, 4);
            copper_strips(0, 4);
          }
          cell_array(0, 2, 1);
          cell_array(2, 2, -1);
          cell_array(4, 2, 1);
          cell_array(6, 2, -1);
          cell_array(8, 2, 1);
          translate([0, 0, h]) {
            copper_strips(6, 4);
            copper_strips(2, 4);
            copper_strips(0, 2);
            // Fold
            plate_folded_left(0, 0, 6, 0);
            translate([0, 0, copper_plate_thickness]) {
              nickel_strips(6, 4);
              nickel_strips(2, 4);
              nickel_strips(0, 2);
            }
          }
        }
        translate([3 * d, 5 * d, vertical_grid * 2])
          mirror([0, 0, 1])
            half_holder();

        // Third battery level
        translate([3 * d, 5 * d, vertical_grid * 2])
          half_holder();
        translate([0, 0, vertical_grid * 2 + cell_spacing_vertical / 2]) {
          translate([0, 0, -copper_plate_thickness]) {
            translate([0, 0, -nickel_plate_thickness]) {
              nickel_strips(0, 2);
              nickel_strips(2, 4);
              nickel_strips(6, 4);
            }
            copper_strips(0, 2);
            copper_strips(2, 4);
            copper_strips(6, 4);
          }
          cell_array(0, 2, 1);
          cell_array(2, 2, -1);
          cell_array(4, 2, 1);
          cell_array(6, 2, -1);
          cell_array(8, 2, 1);
          translate([0, 0, h]) {
            copper_strips(0, 4);
            copper_strips(4, 4);
            copper_strips(8, 2);
            // Fold
            plate_folded_right(0, 9, 6, 0);
            translate([0, 0, copper_plate_thickness]) {
              nickel_strips(0, 4);
              nickel_strips(4, 4);
              nickel_strips(8, 2);
            }
          }
        }
        translate([3 * d, 5 * d, vertical_grid * 3])
          rotate([180, 0, 0])
            half_holder();

        // Fourth battery level
        translate([3 * d, 5 * d, vertical_grid * 3])
          rotate([0, 0, 180])
            half_holder();

        translate([0, 0, vertical_grid * 3 + cell_spacing_vertical / 2]) {
          translate([0, 0, -copper_plate_thickness]) {
            translate([0, 0, -nickel_plate_thickness]) {
              nickel_strips(8, 2);
              nickel_strips(4, 4);
              nickel_strips(0, 4);
            }
            copper_strips(8, 2);
            copper_strips(4, 4);
            copper_strips(0, 4);
          }
          cell_array(0, 2, 1);
          cell_array(2, 2, -1);
          cell_array(4, 2, 1);
          cell_array(6, 2, -1);
          cell_array(8, 2, 1);
          translate([0, 0, h]) {
            copper_strips(6, 4);
            copper_strips(2, 4);
            copper_strips(-2, 4);
            translate([0, 0, copper_plate_thickness]) {
              nickel_strips(6, 4);
              nickel_strips(2, 4);
              nickel_strips(0, 2);
              translate(
                [
                  (6 * d - 120) / 2,
                  (10 * d - 120) / 2,
                  plates_thickness,
                ]
              ) {
                // 12V 120x120x30 Fan
                //cube([120, 120, 30]);
              }
            }
          }
        }
        translate([3 * d, 5 * d, vertical_grid * 4])
          mirror([0, 0, 1])
            half_holder();
      }
}

clearance = 0.5;
holder_pocket_height = 3;
holder_walls = 0.5;
holder_strips_height = 0.3;
holder_thickness = cell_spacing_vertical + holder_pocket_height * 2;

module half_holder() {
  module cooling_hole() {
    render(convexity=2) {
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
            cylinder(h=100, d=d + clearance * 2 + holder_walls * 2, center=true);
        }
        // copper
        for (x = [-0.5, 0.5]) {
          translate([x * d, 0, 0]) {
            cube(
              [
                copper_width + clearance * 2 + holder_walls * 2,
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
                nickel_width + clearance * 2 + holder_walls * 2,
                100,
              ], center=true
            );
          }
        }
      }
    }
  }

  render() {
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
          for (x = [-3:3], y1 = [-4:4]) {
            for (y2 = [-1, 0, 1]) {
              translate([x * d, y1 * (d + d + cell_isolation) + y2 * d, 0]) {
                cooling_hole();
              }
            }
          }
        }

        // Pockets for the cells
        for (x = [-2.5:2.5], y1 = [-0.5:0.5], y2 = [-2:2]) {
          translate([x * d, y1 * d + y2 * (d + d + cell_isolation)]) {
            translate([0, 0, holder_thickness / 2 - holder_pocket_height])
              cylinder(h=10, d=d + clearance * 2);
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
                copper_width + clearance * 2,
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
                5 * d + copper_width + clearance * 2,
                nickel_width + clearance * 2,
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
                copper_width + clearance * 2,
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

*for(z=[0, 180], x=[0, -180]) {
  rotate([x, 0, 0]) {
    rotate([0, 0, z]) {
      translate(
        [
          0,
          d * 3 + bulkhead_y_thickness / 2,
          d * 5 + bulkhead_z_thickness / 2,
        ]
      ) {
        quarter();
      }
    }
  }
}

// quarter();

translate([300, 0, 10]) rotate([90, 0, 0]) scale(3) text("FRONT ->");

*cube([100, 1.6, 160]);
*translate([0, 0, 165])
  cube([100, 1.6, 160]);
