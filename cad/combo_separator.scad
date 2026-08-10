include <parameters.scad>
use <large_spacer.scad>
use <strips_insulator.scad>

module combo_separator() {
  union() {
    large_spacer();
    translate(
      [
        0,
        0,
        strips_insulator_stack_height / 2 + large_spacer_stack_height / 2,
      ]
    )
      strips_insulator();
  }
}

combo_separator();
