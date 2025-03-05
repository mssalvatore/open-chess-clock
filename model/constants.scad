include <hotswap_pcb_generator/scad/parameters.scad>

fillet = 5;

body_wall_thickness = 2.5;

socket_dimension = socket_size + (h_border_width * 2);
switch_platform_z = 9;
switch_border = 3;
switch_platform_x = socket_dimension + 2 * switch_border;
switch_platform_y = socket_dimension + switch_border + 40;
switch_z_offset = pcb_thickness / 2;

controller_x = 18;
controller_y = 36.2;
controller_z = 2;
controller_wall_thickness = 1.75;
controller_insert_depth = 2.6;

controller_top_clearance = 5;
controller_bottom_clearance = 7.5;

controller_mount_long_side_x = controller_y;
controller_mount_long_side_y = controller_wall_thickness + controller_insert_depth;
controller_mount_long_side_z = controller_bottom_clearance + controller_z + controller_top_clearance;

controller_mount_short_side_x = controller_mount_long_side_y;
controller_mount_short_side_y = controller_x;
controller_mount_short_side_z = controller_mount_long_side_z;


cavity_x = controller_mount_long_side_x + controller_mount_short_side_x - controller_insert_depth + 5;
cavity_y = 48;
cavity_z = controller_mount_long_side_z;

cable_channel_dimension = cavity_z;

cable_channel_xpos = cavity_x / 2 - .001;
cable_channel_ypos = -(controller_mount_long_side_y - controller_insert_depth + (controller_x / 2) - cable_channel_dimension / 2);

wire_slot_x = cavity_x / 2;
wire_slot_y = wire_slot_x / 2;

usb_cable_connector_length = 40;

strain_relief_x = cavity_z + .5;
strain_relief_y = cavity_z + .5;
strain_relief_z = 12;


strain_relief_lip = 2;
strain_relief_lip_z = 1;
strain_relief_fillet = 2;

cavity_border = 3;
lid_z = 2.65;
floor_thickness = 3;
platform_x = cavity_x + usb_cable_connector_length + 7;
platform_y = cavity_y + 2 * cavity_border; // TODO: Fix magic number
platform_z = cavity_z + floor_thickness + lid_z; // TODO: Fix magic number

// TODO: Fix magic number
cable_channel_length = platform_x - cavity_x - 2 * cavity_border + body_wall_thickness + .502;

phone_theta = 22.5;

phone_clamp_width = 31;
phone_clamp_depth = 21.1;
phone_clamp_screw_shaft_diameter = 7;
phone_clamp_screw_head_diameter = 12;
phone_clamp_screw_head_height =  5;
phone_clamp_screw_hole_ypos = -cos(phone_theta) * lid_z;
phone_clamp_screw_gap = 4.8;

lid_screw_shaft_diameter = 5;
lid_screw_head_diameter = 10;
lid_screw_head_height = 1.6;
lid_nut_diameter = 10.4;
lid_screw_xpos = phone_clamp_depth / 2 + lid_screw_head_diameter / 2 + 1;
