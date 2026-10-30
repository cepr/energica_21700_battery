include <parameters.scad>
use <colors.scad>
use <insert.scad>
use <hex_standoff.scad>
use <LiBAL_s-BMS.scad>

show_inserts = true;
show_standoffs = true;
show_pcbs = false;

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

module large_panel_dxf() {
  import("large_panel.dxf", center=true);
}

module large_panel() {
  clear_acrylic()
    rotate([90, 0, 0])
      rotate([0, 90, 0])
        linear_extrude(height=external_walls, center=true) {
          *large_panel_2d();
          large_panel_dxf();
        }
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
  clear_acrylic()
    rotate([90, 0, 0])
      linear_extrude(height=external_walls, center=true)
        //small_panel_2d();
        translate([-0.5 * case_dim_x + external_walls, 0.5 * module_240_height])
          import("small_panel.dxf");
}

module PCBs(third_pcb) {
  if (show_inserts) {
    translate([0, 6 - 1.5, 0]) {
      rotate([90, 0, 0]) {
        for (x = [-43, 43], z1 = [-1, 1], z2 = [-1, 1]) {
          translate([x, z1 * module_240_height / 4 + z2 * 73]) {
            insert_m4();
          }
        }
      }
    }
  }
  if (show_standoffs) {
    translate([0, 6 - 1.5, 0]) {
      rotate([90, 0, 0]) {
        for (x = [-43, 43], z2 = [-1, 1]) {
          translate([x, module_240_height / 4 + z2 * 73]) {
            translate([0, 0, -15 - 1.6])
              hex_standoff_m4x15();
          }
        }
      }
    }
  }
  for (a = [0, 180]) {
    rotate([0, a, 0]) {
      translate([0, 6 - 1.5, 82])
        rotate([0, 90, 0])
          rotate([-90, 0, 0])
            LMU();
    }
  }
  translate([0, 6 - 1.5 + 15 + 1.6 + 1.6, 82])
    rotate([0, -90, 0])
      rotate([90, 0, 0]) {
        if (third_pcb == "LMU") {
          LMU();
        } else if (third_pcb == "BMCU") {
          BMCU();
        }
      }
}

// third_pcb can be "LMU", "BMCU", or "NONE"
module panels(flip_pcbs = false, third_pcb = "NONE") {
  *for(x=[-0.5, 0.5]) {
    translate([x * (case_dim_x - external_walls), 0, 0]) {
      large_panel();
    }
  }
  for (a = [0, 180]) {
    rotate([0, 0, a])
      translate([0, 0.5 * (case_dim_y - external_walls), 0]) {
        small_panel();
      }
  }
  if (show_pcbs) {
    rotate([0, flip_pcbs ? 180 : 0, 0]) {
      translate([0, 0.5 * (case_dim_y - external_walls), 0]) {
        PCBs(third_pcb);
      }
    }
  }
}

module double_panel() {
  translate([base_plate_dim_x / 2, 0, 0])
    rotate([0, 90, 0])
      rotate([0, 0, 90])
        linear_extrude(height=2.54) {
          import("aluminium_panel.dxf", center=true);
        }
}

*small_panel_2d();
*small_panel();
*panels();

*translate([0, 0, 10])
  large_panel_2d();

*color("red")
  translate([0, 0, -10])
    large_panel_dxf();

*color("red")
  cube([228, 358.2, 5], center=true);

double_panel();
