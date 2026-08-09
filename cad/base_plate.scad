include <parameters.scad>

module base_plate(
  height,
  center = false,
  shorter_end = false,
  nickel_passages = false
) {
  translate([0, 0, center ? 0 : height / 2]) {
    union() {
      difference() {
        for (x = [-2.5:2.5], y1 = [-0.5:0.5], y2 = [-2:2]) {
          translate([x * d, y1 * d + y2 * (d + d + cell_isolation)])
            cylinder(h=height, d=d + holder_walls * 2, center=true);
        }
        if (shorter_end) {
          translate([0, -500 - base_plate_dim_y / 2 + 3, 0])
            cube(
              [
                1000,
                1000,
                1000,
              ], center=true
            );
        }
        if (nickel_passages) {
          // Flat surfaces for the ring terminals
          for (x = [-0.5, 0.5], y1 = [-0.5], y2 = [-2:2]) {
            translate([x * (base_plate_dim_x + 100 - ring_terminal_cutout_depth * 2), y1 * d + y2 * (d + d + cell_isolation), 0])
              cube([100, d, 100], center=true);
            translate([x * (base_plate_dim_x - ring_terminal_cutout_depth * 2), y1 * d + y2 * (d + d + cell_isolation) + 5.6 / 2, 0])
              rotate([-90, 0, 0])
                cylinder(d=3.9, h=0.4 * d);
          }
        }
      }
      for (x = [-2.5:2.5]) {
        translate([x * d, shorter_end ? d / 2 : 0])
          cube(
            [
              copper_width + strips_clearance * 2 + holder_walls * 2,
              base_plate_dim_y - (shorter_end ? d : 0),
              height,
            ], center=true
          );
      }
      for (y1 = [-0.5:0.5], y2 = [-2:2]) {
        translate(
          [
            nickel_passages ? y1 * d : 0,
            y1 * d + y2 * (d + d + cell_isolation),
          ]
        )
          cube(
            [
              base_plate_dim_x - (nickel_passages ? d : 0),
              nickel_width + strips_clearance * 2 + holder_walls * 2,
              height,
            ], center=true
          );
      }
    }
  }
}

base_plate(
  height=10,
  center=false,
  shorter_end=true,
  nickel_passages=true
);
