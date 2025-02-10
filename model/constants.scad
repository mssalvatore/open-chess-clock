include <hotswap_pcb_generator/scad/parameters.scad>

function calculate_y_offset(base, height, z_offset) = (base * (height - z_offset)) / height;

phone_x = 168; // Any bigger and my printer can't handle it.
phone_y = 85;
phone_z = 10;

body_wall_thickness = 8;
body_front_thickness = phone_z + 1;

lid_lip = body_wall_thickness / 2;
lid_z = 8.5;

body_theta = 68;
body_edge_radius = 4;
body_y = 90 + (2 * body_wall_thickness);
body_z = sin(body_theta) * (phone_y +  body_wall_thickness + lid_z);
body_x = phone_x + ((body_z / sin(body_theta)) - phone_y) + (body_edge_radius / 2);
body_hollow_x = body_x - (2 * body_wall_thickness);
body_hollow_y = body_y - body_wall_thickness - (body_front_thickness / cos(90 - body_theta));
body_hollow_z = tan(body_theta) * body_hollow_y;
body_hollow_y_bottom = calculate_y_offset(body_hollow_y, body_hollow_z, body_wall_thickness);
body_hollow_y_top = calculate_y_offset(body_hollow_y, body_hollow_z, body_z);
body_y_top = calculate_y_offset(body_y, tan(body_theta) * body_y, body_z);

lid_x = body_x - (2 * lid_lip);
lid_y =  body_y_top - (2 * lid_lip);
lid_tolerance = .2;

socket_edge_offset = 10;
socket_dimension = socket_size + (h_border_width * 2);
socket_hole_dimension = socket_size;
switch_spacing = lid_x - socket_hole_dimension - ((lid_lip + socket_edge_offset) * 2);
switch_z_offset = pcb_thickness / 2;

micro_pcb_thickness = 1.6;
pcb_mount_wall_thickness = 1.6;
pcb_x = 18.25;
pcb_y = 37;
pcb_insert_depth = 2.6;
pcb_z_clearance = 5;
pcb_mount_x = pcb_x + (2 * pcb_mount_wall_thickness);
pcb_mount_y = pcb_insert_depth + pcb_mount_wall_thickness;
pcb_mount_z = pcb_z_clearance + micro_pcb_thickness + pcb_mount_wall_thickness;

backplate_thickness = 3;
backplate_width = 15;

usb_cable_width= 8;
usb_plug_width= 14;
usb_cable_protrusion = 1;
