include <parameters.scad>
use <colors.scad>

module insert_m3() {
  difference() {

    copper() union() {
        cylinder(h=4, d=4.2, center=false);
        for (z = [1, 3]) {
          translate([0, 0, z])
            cylinder(h=1, d=5.08, center=false);
        }
      }
    cylinder(h=100, d=3, center=true);
  }
}

module insert_m4() {
  difference() {

    copper() union() {
        cylinder(h=6, d=5.25, center=false);
        for (z = [1, 4]) {
          translate([0, 0, z])
            cylinder(h=2, d=6, center=false);
        }
      }
    cylinder(h=100, d=4, center=true);
  }
}

insert_m3();
