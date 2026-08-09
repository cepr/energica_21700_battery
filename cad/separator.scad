include <parameters.scad>

module separator2d() {
  difference() {
    square(
      [
        5.55 * d,
        h,
      ], center=true
    );
    for (x = [-2.5:2.5], y = [-1, 1]) {
      translate(
        [
          x * d,
          y * (50 + h / 2 - holder_pocket_height - 0.5),
        ]
      )
        square(
          [
            copper_width + 2 * strips_clearance + holder_walls * 2 + 0.3,
            100,
          ], center=true
        );
    }
  }
}

module separator() {
  rotate([90, 0, 0])
    linear_extrude(height=cell_isolation, center=true) separator2d();
}

module separators() {
  for (y = [-3:2:3]) {
    translate([0, y * (d + cell_isolation / 2), 0]) {
      separator();
    }
  }
}

separator();
