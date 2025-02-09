include <hotswap_pcb_generator/scad/parameters.scad>

function calculate_y_offset(base, z_offset, theta) = ((tan(theta) * base) - z_offset) / tan(theta);


body_wall_thickness = 8;
body_front_thickness = 12;

lid_lip = body_wall_thickness / 2;

body_x = 200;
body_y = 90 + (2 * body_wall_thickness);
body_z = 90 + lid_lip;
body_hollow_y = body_y - (body_wall_thickness + body_front_thickness);
body_theta = 68;
body_y_top = calculate_y_offset(body_y, body_z, body_theta);
body_edge_radius = 6;

lid_x = body_x - (2 * lid_lip);
lid_y =  body_y_top - (2 * lid_lip);
lid_z = 8.5;
lid_tolerance = .2;

socket_edge_offset = 10;
socket_dimension = socket_size + (h_border_width * 2);
socket_hole_dimension = socket_size;
switch_spacing = lid_x - socket_hole_dimension - ((lid_lip + socket_edge_offset) * 2);
switch_z_offset = pcb_thickness / 2;
