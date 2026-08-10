include <parameters.scad>
use <ring_terminal.scad>

module balancing_terminals() {
  translate(
    [
      base_plate_dim_x / 2 - ring_terminal_cutout_depth + 0.5,
      -4.5 * d - 2 * cell_isolation,
      0,
    ]
  )
    rotate([0, 180, 0])
      rotate([90, 0, 0])
        ring_terminal(bend_angle=15);
}

balancing_terminals();
