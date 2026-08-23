$fn = 64;

h = 70.3; // cell max height
d = 21.5; // cell max diameter

available_y = 19.5 * 25.4;

aluminum_thickness = 0.04 * 25.4; // 5052 H32 Aluminum for the case
case_dim_x = 137; // external dimensions, must be 137 to match the EIG battery box
case_dim_y = 228; // 235 is the max, can be smaller
case_dim_z = 355; // 

external_walls = 3; // acrylic

base_plate_dim_x = case_dim_x - 2 * external_walls;
base_plate_dim_y = case_dim_y - 2 * external_walls;

cell_isolation = 1; // minimum separation between cells not in parallel

plate_disk_dia = 14;
copper_width = 10;
copper_length = 9.8 * d;

nickel_width = 8;
nickel_length = 5.8 * d; // length of the nickel strip to connect 6 cells

plate_slot_length = 8;
plate_slot_width = 0.7;
copper_plate_thickness = 0.15;
nickel_plate_thickness = 0.15;
strips_pocket_height = 1;

plates_thickness = copper_plate_thickness + nickel_plate_thickness;

bulkhead_thickness = 20;

strips_clearance = 0.5;
holder_pocket_height = 5;
holder_walls = 0.5;

exploded = $t * 50;

inlet_stack_height = 20;
outlet_walls = 3;

m3_insert_od = 4.6; // 5mm OD minus some plastic to melt
m3_insert_length = 4 + 4; // 4 mm more than the insert length

m4_insert_od = 5.25; // this is the diameter of the hole, it must be smaller than the insert’s maximum OD
m4_insert_length = 8; // 2 mm more than the insert length

cell_holder_stack_height = 0.3;

strips_insulator_stack_height = 1.2;

module_60_height = h + cell_holder_stack_height * 2 + strips_insulator_stack_height * 2 + 7 * exploded;

large_spacer_stack_height = 7;

module_120_height = module_60_height * 2 + large_spacer_stack_height + exploded;

module_240_height = module_120_height * 2 + large_spacer_stack_height * 3 + exploded;

inlet_walls = 3;

ring_terminal_cutout_depth = 3;
busbar_cutout_depth = 3;
busbar_thickness = 1;
