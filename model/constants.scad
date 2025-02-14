include <hotswap_pcb_generator/scad/parameters.scad>

function calculate_y_offset(base, height, z_offset) = (base * (height - z_offset)) / height;

phone_x = 168; // Any bigger and my printer can't handle it.
phone_y = 78;
phone_z = 10;

theta = 60;
body_wall_thickness = phone_z + 1;
body_floor_thickness = 4;
body_front_y_offset = body_wall_thickness / sin(theta);

lid_lip = 4;
lid_z = 9;

body_edge_radius = 4;
body_y = 90;
body_z_peak = tan(theta) * body_y;
body_z = sin(theta) * (phone_y +  body_wall_thickness + lid_z);
body_x = phone_x + ((body_z / sin(theta)) - phone_y) + (body_edge_radius / 2);

body_hollow_x = body_x - (1.25 * body_wall_thickness) ;
body_hollow_y = body_y - body_wall_thickness - body_front_y_offset;
body_hollow_z_peak = tan(theta) * body_hollow_y;
body_hollow_z = body_z * body_hollow_y / body_y;
body_hollow_y_adjustment = (body_front_y_offset -body_wall_thickness) / 2;

body_y_top = calculate_y_offset(body_y, body_z_peak, body_z);

lid_x = body_hollow_x + (2 * lid_lip);
lid_y =  body_y_top - (2 * lid_lip);

socket_edge_offset = 10;
socket_dimension = socket_size + (h_border_width * 2);
socket_hole_dimension = socket_size - 0.3;
socket_latch_x  = 2.5;
socket_latch_y = 4.75;
socket_latch_z = 3.5;
socket_latch_z_offset = 1.25;
socket_latch_x_offset = (socket_hole_dimension / 2) - .001;
switch_spacing = lid_x - socket_hole_dimension - ((lid_lip + socket_edge_offset) * 2);
switch_z_offset = pcb_thickness / 2;

micro_pcb_thickness = 1.55;
pcb_mount_wall_thickness = 1.75;
pcb_x = 18;
pcb_y = 36.2;
pcb_insert_depth = 2.6;
pcb_z_clearance = 7;
pcb_mount_x = pcb_x + (2 * pcb_mount_wall_thickness);
pcb_mount_y = pcb_insert_depth + pcb_mount_wall_thickness;
pcb_mount_z = pcb_z_clearance + micro_pcb_thickness + pcb_mount_wall_thickness;

backplate_thickness = 3;
backplate_width = 15;

usb_cable_width= 8;
usb_plug_width= 18;
usb_cable_protrusion = 2.25;

tension_bar_tolerance = 0.25;
tension_bar_x_depth = 2;
tension_bar_wall = 1.25;
tension_bar_x = phone_x + 2 * tension_bar_x_depth;
tension_bar_y = (body_wall_thickness / 2) / sin(theta);
tension_bar_z = phone_z - 2 * tension_bar_wall;

wire_channel_bend_diameter = wire_diameter * 6;
spring_hole_diameter = 4.7;
// 3mm is a good depth, but these cut through the bottom of the body.
// Adjustments need to be made to the body to accomodate a more adjustable
// tension bar anyway.
//spring_hole_depth = 1;
spring_hole_depth = 3;
