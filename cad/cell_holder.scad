include <parameters.scad>
use <base_plate.scad>

module cell_holder() {
  difference() {
    base_plate(
      height=cell_holder_stack_height + holder_pocket_height,
      center=false,
      nickel_passages=false
    );

    // What to remove
    for (x = [-2.5:2.5], y1 = [-0.5:0.5], y2 = [-2:2]) {
      // Pocket for the cells
      translate(
        [
          x * d,
          y1 * d + y2 * (d + d + cell_isolation),
          cell_holder_stack_height,
        ]
      ) {
        cylinder(d=d + 0.1, h=100);
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
            100,
          ], center=true
        );
      }
    }
  }
}

cell_holder();
