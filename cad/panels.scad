include <parameters.scad>
use <colors.scad>

module large_panel_2d() {
  difference() {
    square([case_dim_y, module_240_height + 30], center=true);
    for (y1 = [-0.5, 0.5], y2 = [-2:2]) {
      for (z = [-2:2]) {
        translate(
          [
            y1 * d + y2 * (d + d + cell_isolation),
            z * (module_60_height + large_spacer_stack_height),
          ]
        ) {
          circle(d=3.2);
        }
      }
    }
    for (z = [-0.5, 0.5]) {
      translate([0, z * (module_240_height + 30)]) {
        hull() {
          for (y = [-0.5, 0.5]) {
            translate([y * (case_dim_y - 30 - 30), 0])
              circle(r=15);
          }
        }
      }
    }
    for (y = [-0.5, 0.5], z = [-0.5, 0.5]) {
      translate([y * (case_dim_y - 15), z * (module_240_height + 15)])
        circle(d=5.5);
    }
  }
}

module large_panel() {
  rotate([90, 0, 0])
    rotate([0, 90, 0])
      linear_extrude(height=external_walls, center=true)
        large_panel_2d();
}

module small_panel_2d() {
  difference() {
    square([case_dim_x - 2 * external_walls, module_240_height], center=true);
    for (x = [-2.5:2.5], y = [-2:2]) {
      translate([x * d, y * (module_60_height + large_spacer_stack_height)]) {
        circle(d=3.2);
      }
    }
    for (x = [-0.5, 0.5], y = [-1.5:1.5]) {
      translate([x * (case_dim_x - 2 * external_walls), y * (module_60_height + large_spacer_stack_height)]) {
        hull() {
          for (y2 = [-0.5, 0.5]) {
            translate([0, y2 * 40])
              circle(d=3);
          }
        }
      }
    }
    for (x = [-43, 43], z1 = [-1, 1], z2 = [-1, 1]) {
      translate([x, z1 * module_240_height / 4 + z2 * 73])
        circle(d=m4_insert_od);
    }
  }
}

module small_panel() {
  rotate([90, 0, 0])
    linear_extrude(height=external_walls, center=true)
      //small_panel_2d();
      translate([-0.5 * case_dim_x + external_walls, 0.5 * module_240_height])
        import("small_panel.dxf");
}

module panels() {
  clear_acrylic() {
    for (x = [-0.5, 0.5]) {
      translate([x * (case_dim_x - external_walls), 0, 0]) {
        large_panel();
      }
    }
    for (y = [-0.5, 0.5]) {
      translate([0, y * (case_dim_y - external_walls), 0])
        small_panel();
    }
  }
}

small_panel_2d();
*large_panel_2d();
*small_panel();
*panels();
