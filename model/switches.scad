include <BOSL/constants.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>

include <hotswap_pcb_generator/scad/parameters.scad>
use <hotswap_pcb_generator/scad/switch.scad>

include <constants.scad>

socket_dimension = socket_size + (h_border_width * 2);
socket_hole_dimension = socket_size - 0.3;

socket_latch_x = 4.75;
socket_latch_y  = 2.25;
socket_latch_z = 3.5;
socket_latch_z_offset = 1.25;
socket_latch_x_offset = (socket_hole_dimension / 2)  + (socket_latch_x / 2) - .001;

switch_z_offset = pcb_thickness / 2;
switch_border = 3;

switch_platform_x = socket_dimension + 2 * switch_border;
switch_platform_y = socket_dimension + switch_border + 20;

switch_socket_hole_y_pos = -(switch_platform_y - switch_border);

module switch_platform() {
    difference() {
        cuboid(
            [switch_platform_x, switch_platform_y, switch_platform_z],
            fillet=body_edge_radius,
            edges=EDGES_Z_FR,
            align=V_FRONT + V_TOP
        );
        switch_socket_hole();
    }
    switch_socket_1();
}

module switch_socket_hole() {
    xpos= 0;
    ypos = switch_socket_hole_y_pos;
    zpos = -.001;

    move([xpos, ypos, zpos]) {
        cuboid(
            [socket_hole_dimension, socket_hole_dimension, switch_platform_z + .002],
            align=V_TOP + V_BACK
        );
        ymove(-socket_latch_y / 2 + .001) {
            switch_latch_hole();
        }
        ymove(socket_hole_dimension + socket_latch_y / 2 -.001) {
            switch_latch_hole();
        }
    }
}

module switch_socket_1() {
    xpos = -socket_dimension / 2;
    ypos = socket_dimension - h_border_width + switch_socket_hole_y_pos;

    move([xpos, ypos, switch_z_offset]) {
        switch_socket();
    }
}

module switch_latch_hole() {
    xpos = 0;
    ypos = 0;
    zpos = switch_platform_z - socket_latch_z_offset;

    move([xpos, ypos, zpos]) {
        cuboid([socket_latch_x, socket_latch_y, socket_latch_z], align=V_BOTTOM);
    }
}
switch_platform();
