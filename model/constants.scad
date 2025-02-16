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
body_y = 100;
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


backplate_thickness = 3;
backplate_width = 15;

usb_cable_width= 8;
usb_plug_width= 18;
usb_cable_protrusion = 2.25;
usb_cable_thickness = 0.8;

wire_channel_bend_diameter = wire_diameter * 6;

phone_socket_center_z = body_z / 2;
