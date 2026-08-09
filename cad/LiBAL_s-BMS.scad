use <colors.scad>

module LMU() {
  ox = -0.765;
  oy = -2.68;
  oz = 0.85;
  pcb() {
    translate([ox, oy, oz])
      rotate([90, 0, 0])
        import("LiBAL_s-BMS-LMU.stl");
  }
}

module LMUx2() {
  LMU();
  translate([0, 0, 1.6 * 2 + 15])
    rotate([0, 180, 0]) LMU();
  // HEX spacers
  for (x = [-73, 73], y = [-43, 43]) {
    translate([x, y, 1.6])
      cylinder(h=15, d=8, $fn=6);
  }
}

module BMCU() {
  //pcb() {
  translate([8.84, -0.16, 4.4])
    rotate([90, 0, 0])
      import("LiBAL_s-BMS-BMCU.stl");
  //}
}

module LMU_plus_BMCU() {
  LMU();
  translate([0, 0, 1.6 * 2 + 15])
    rotate([0, 180, 0]) BMCU();
  // HEX spacers
  for (x = [-73, 73], y = [-43, 43]) {
    translate([x, y, 1.6])
      cylinder(h=15, d=8, $fn=6);
  }
}

*LMUx2();
LMU_plus_BMCU();
