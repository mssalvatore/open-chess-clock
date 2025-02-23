include <hotswap_pcb_generator/scad/parameters.scad>

fillet = 5;

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

wire_slot_x = cavity_x / 2;
wire_slot_y = wire_slot_x / 2;

usb_cable_connector_length = 40;
