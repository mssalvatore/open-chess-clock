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
// the wire_channel() module produces channels that are off-center by 4 units
wire_channel_center_adjustment = 4 * mx_schematic_unit;
wire_channel_protrusion = 10;
wire_channel_length = switch_platform_y - switch_border + wire_channel_protrusion;

module switch_platform() {
    difference() {
        union() {
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

        ground_wire_channel();
        data_wire_channel();
    }
}

module ground_wire_channel() {
    platform_wire_channel(-3 * mx_schematic_unit);
}

module data_wire_channel() {
    platform_wire_channel(2 * mx_schematic_unit);
}

module platform_wire_channel(xpos) {
    ypos = wire_channel_center_adjustment - (wire_channel_length / 2) + wire_channel_protrusion;
    zpos = switch_z_offset;
        move([xpos, ypos, zpos]) {
            zrot(90)wire_channel([0, 0], true, wire_channel_length);
        }
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
