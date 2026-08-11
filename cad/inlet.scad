include <parameters.scad>
use <large_spacer.scad>
use <terminal_busbar.scad>
use <fan_92x92x38.scad>

airgap = 15;

module inlet(flip_terminals = false) {
  ox = case_dim_x - 2 * external_walls;
  oy = case_dim_y - 2 * external_walls;

  module for_each_hole_bottom() {
    for (x = [-0.5, 0.5], y = [-1.5:1.5]) {
      translate([x * 5 * d, y * (3 * d + 1.5 * cell_isolation)])
        children();
    }
  }

  module for_each_hole_top() {
    for (x = [-0.5, 0.5], y1 = [-0.5, 0.5], y2 = [-0.5, 0.5]) {
      translate([x * 82.5, y1 * 92 + y2 * 82.5])
        children();
    }
  }

  translate([0, 0, large_spacer_stack_height / 2])
    difference() {
      large_spacer();
      for_each_hole_bottom() {
        cylinder(d=m4_insert_od, h=100, center=true);
      }
    }

  for (y = [0, busbar_thickness + copper_plate_thickness]) {
    translate([0, -0.5 * oy + busbar_cutout_depth - y, large_spacer_stack_height / 2])
      rotate([90, 0, 0]) {
        if (flip_terminals) {
          mirror([1, 0, 0])
            terminal_busbar();
        } else {
          terminal_busbar();
        }
      }
  }

  for (y = [-0.5, 0.5]) {
    translate([0, y * 92, large_spacer_stack_height + airgap]) {
      fan_92x92x38();
    }
  }

  module funnel_outer() {
    hull() {
      translate([0, 0, airgap - 3]) {
        for_each_hole_top() {
          cylinder(d=92 - 82.5, h=3, center=false);
        }
      }
      for_each_hole_bottom() {
        cylinder(d=8, h=3, center=false);
      }
    }
  }

  module funnel_inner() {
    difference() {
      hull() {
        translate([0, 0, airgap - 3]) {
          for_each_hole_top() {
            cylinder(d=92 - 82.5 - 6, h=3, center=false);
          }
        }
        translate([0, 0, -0.1]) {
          for_each_hole_bottom() {
            cylinder(d=4.5, h=3, center=false);
          }
        }
      }
      translate([0, 0, airgap])
        cube([1000, 1000, 6], center=true);
      for_each_hole_top() {
        translate([0, 0, airgap - 3])
          cylinder(d=m4_insert_od + 6, h=6, center=true);
      }
    }
  }

  translate([0, 0, large_spacer_stack_height]) {
    difference() {
      union() {
        difference() {
          funnel_outer();
          funnel_inner();
        }

        intersection() {
          for_each_hole_bottom() {
            cylinder(d=8 + 6, h=100);
          }
          funnel_outer();
        }
      }

      // Holes for the bottom screws
      for_each_hole_bottom() {
        cylinder(d=4.5, h=100, center=true);
        translate([0, 0, 3])
          cylinder(d=8, h=100);
      }

      // Holes for the top inserts
      for_each_hole_top() {
        cylinder(d=m4_insert_od, h=100, center=true);
      }

      // Holes for the fan outlet
      for (y = [-0.5, 0.5]) {
        translate([0, y * 92, 0])
          cylinder(d=90, h=100, center=true);
      }
    }
  }
}

inlet();
