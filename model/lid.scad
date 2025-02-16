include <BOSL/constants.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>

use <hotswap_pcb_generator/scad/switch.scad>
include <hotswap_pcb_generator/scad/parameters.scad>

include <constants.scad>

module lid_recess() {
    cuboid(
        [lid_x, lid_y, lid_z + .001],
        align=V_BOTTOM,
        fillet=body_edge_radius,
        edges=EDGE_FR_RT+ EDGE_FR_LF + EDGE_BK_RT + EDGE_BK_LF

    );
}

module lid() {
    difference() {
        union() {
            difference() {
                cuboid(
                    [lid_x, lid_y, lid_z],
                    align=V_TOP,
                    fillet=body_edge_radius,
                    edges=EDGE_FR_RT+ EDGE_FR_LF + EDGE_BK_RT + EDGE_BK_LF
                );
                xspread(switch_spacing, 2) switch_socket_hole();
            }
            xspread(switch_spacing, 2) switch_socket_1();
        }

        ground_wire_channel();
        left_data_wire_channel();
        right_data_wire_channel();
    }
}


module switch_socket_hole() {
    zmove(-.001) cuboid([socket_hole_dimension, socket_hole_dimension, lid_z + .002], align=V_TOP);
    zmove(lid_z - socket_latch_z_offset) {
        xmove(socket_latch_x_offset) {
            switch_latch_hole();
        }
        xmove(-socket_latch_x_offset) {
            switch_latch_hole();
        }
    }
}

module switch_latch_hole() {
    cuboid([socket_latch_x, socket_latch_y, socket_latch_z], align=V_BOTTOM);
}

module switch_socket_1() {
    zrot(90) move([-socket_dimension / 2, socket_dimension / 2, switch_z_offset]) switch_socket();
}

module ground_wire_channel() {
        zmove(switch_z_offset) wire_channel([0, -3*mx_schematic_unit], true, lid_x * 1.5);
}

module left_data_wire_channel() {
    channel_length = lid_x / 2;
    channel_midpoint = switch_spacing - lid_lip - (2 * socket_dimension);
    move([channel_midpoint, 2 * mx_schematic_unit, switch_z_offset]) {
        wire_channel([0, 0], true, channel_length);
    }
}

module right_data_wire_channel() {
    // the wire_channel() module produces channels that are off-center by 4 units
    recenter_adjustment = -4 * mx_schematic_unit;

    channel_y = 2 * mx_schematic_unit;
    channel_length = lid_x / 2 + (2 * socket_dimension);
    channel_midpoint = -(switch_spacing / 2 - lid_x / 4);
    channel_end = channel_midpoint + channel_length / 2;

    wire_channel_bend_offset = wire_channel_bend_diameter / 4;
    bend_1_x = channel_end + wire_channel_bend_offset;
    bend_1_y = channel_y + wire_diameter;

    move([channel_midpoint, 0, switch_z_offset])
        wire_channel([-recenter_adjustment, channel_y], true, channel_length);
    move([bend_1_x, bend_1_y, 0])
        wire_channel_bend();
    move([bend_1_x + channel_length / 2, bend_1_y + wire_channel_bend_offset, switch_z_offset])
        wire_channel([-recenter_adjustment, 0], true, channel_length);
}

module wire_channel_bend() {
    cyl(d = wire_channel_bend_diameter, h = 2.25 * wire_diameter, center=true);
}

lid();
