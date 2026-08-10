// STEP file downloaded from https://grabcad.com/library/kare-aksiyel-fan-square-axial-fan-1/details?folder_id=14049389

module fan_92x92x38() {
  translate([0, 0, 38.5 / 2])
    rotate([180, 0, 0])
      import("fan_92x92x38.stl");
}

fan_92x92x38();
