include <hotswap_pcb_generator/scad/parameters.scad>

fillet = 5;

socket_dimension = socket_size + (h_border_width * 2);
switch_platform_z = 9;
switch_border = 3;
switch_platform_x = socket_dimension + 2 * switch_border;
switch_platform_y = socket_dimension + switch_border + 30;
switch_z_offset = pcb_thickness / 2;

controller_x = 18;
controller_y = 36.2;
controller_z = 1.55;
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


// -------------------------------------------------------------------------------------------------

/*
function calculate_y_offset(base, height, z_offset) = (base * (height - z_offset)) / height;

phone_x = 168; // Any bigger and my printer can't handle it.
phone_y = 78;
phone_z = 10;

theta = 68.5;
body_wall_thickness = phone_z + 1;
body_floor_thickness = 4;
body_front_y_offset = body_wall_thickness / sin(theta);

lid_lip = 4;
lid_z = 9;

body_edge_radius = 4;
body_y = 65;
body_z_peak = tan(theta) * body_y;
body_z = sin(theta) * (phone_y +  body_wall_thickness + lid_z);
body_x = phone_x + body_wall_thickness;

body_hollow_x = body_x - (1.25 * body_wall_thickness) ;
body_hollow_y = body_y - body_wall_thickness - body_front_y_offset;
body_hollow_z_peak = tan(theta) * body_hollow_y;
body_hollow_z = body_z * body_hollow_y / body_y;
body_hollow_y_adjustment = (body_front_y_offset -body_wall_thickness) / 2;

body_y_top = calculate_y_offset(body_y, body_z_peak, body_z);

lid_x = body_hollow_x + (2 * lid_lip);
lid_y =  body_y_top - (2 * lid_lip);



backplate_thickness = 3;
backplate_width = 15;

usb_cable_width= 8;
usb_plug_width= 18;
usb_cable_protrusion = 2.25;
usb_cable_thickness = 0.8;

wire_channel_bend_diameter = wire_diameter * 6;

phone_socket_center_z = body_z / 2;
*/
