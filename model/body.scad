include <BOSL/constants.scad>
use <BOSL/paths.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>

use <hotswap_pcb_generator/scad/switch.scad>
include <hotswap_pcb_generator/scad/parameters.scad>

include <constants.scad>
use <controller.scad>
use <tension-bar.scad>

$fn=256;

module body_hollow() {
    difference() {
        prismoid(
            size1=[
                body_hollow_x,
                body_hollow_y
            ],
            size2=[
                body_hollow_x,
                0
            ],
            h=body_hollow_z_peak,
            shift=[0, body_hollow_y / 2]
        );
        zmove(-.001) {
            cuboid(
                [body_hollow_x + 1, body_hollow_y + 1, body_floor_thickness + .002],
                align=V_TOP
            );
        }
    }

}

module lid_recess() {
    cuboid(
        [lid_x, lid_y, lid_z + .001],
        align=V_BOTTOM,
        fillet=body_edge_radius,
        edges=EDGE_FR_RT+ EDGE_FR_LF + EDGE_BK_RT + EDGE_BK_LF

    );
}


module usb_cable_relief() {
    xmove(usb_cable_protrusion - .001) {
        cuboid(
            [
                backplate_width + body_wall_thickness,
                usb_cable_width,
                body_wall_thickness + backplate_thickness + usb_cable_protrusion + .001
            ],
            align=V_BOTTOM + V_LEFT
        );
    }
    move([-.002, 0,0]) {
        cuboid(
            [usb_cable_protrusion, usb_plug_width, body_wall_thickness],
            align=V_BOTTOM + V_RIGHT
        );
    }
}

module phone_socket_cutout() {
    phone_socket_center_z = body_z / 2;
    phone_socket_center_y = (body_y / 2) - (phone_socket_center_z / tan(theta));
    phone_socket_z = body_wall_thickness + .004;

    button_relief_x =  47.5;
    button_relief_x_pos = -(phone_x/2 - button_relief_x /2 - 22.5);
    button_relief_y_pos = phone_y / 2 - .001;

    move([0, -phone_socket_center_y - .002, phone_socket_center_z + .001]) {
        xrot(theta) {
            cuboid([phone_x - .002, phone_y - .002, phone_socket_z], align=V_BOTTOM);
            xmove(phone_x / 2) {
                usb_cable_relief();
            }
            // Button relief
            move([button_relief_x_pos, button_relief_y_pos, 0])
            {
                cuboid([button_relief_x, 2, phone_socket_z], align=V_BOTTOM);
            }
        }
    }
}

module backplate() {
    backplate_center_z = (body_z / 2) - body_floor_thickness;
    backplate_center_y = (
        (body_hollow_y / 2) - body_hollow_y_adjustment - (backplate_center_z / tan(theta))
    );

    move([0, -backplate_center_y - .001, backplate_center_z + .001]) {
        xrot(theta) {
            yspread(phone_y - backplate_width, n=2) {
                cuboid(
                [
                    phone_x + body_wall_thickness,
                    backplate_width + (body_wall_thickness / 2),
                    backplate_thickness
                ],
                align=V_BOTTOM
                );
            }

            xspread(phone_x - backplate_width, n=2) {
                cuboid(
                [
                    backplate_width + body_wall_thickness,
                    phone_y + (body_wall_thickness / 2),
                    backplate_thickness
                ],
                align=V_BOTTOM
                );
            }
        }
    }
}


module cable_channel() {
    segment_unit = body_hollow_z / 3;
    cable_channel_x = 3;
    cable_channel_y = 20;
    channel_theta = -60;
    x_depth = cos(channel_theta) * segment_unit / 3.2 ;

    x = [0, x_depth, x_depth, 0];
    z = [0, -segment_unit * 0.5, 2 * -segment_unit, 2.5 * -segment_unit];
    skew_angle = atan(((lid_y / 3) - cable_channel_y / 2) / z[3]);

    path = [
        [x[0], 0, z[0]],
        [x[1], 0, z[1]],
        [x[2], 0, z[2]],
        [x[3], 0, z[3]]
    ];

    skew_xy(xa=0, ya=-skew_angle) {
        move([body_hollow_x / 2, 0, 0]) {
            extrude_2d_shapes_along_3dpath(path=path) {
                square([cable_channel_x, cable_channel_y], center=true);
            }
        }
    }

}
module body() {
    difference() {
        union() {
            difference() {
                rounded_prismoid(
                    size1=[body_x, body_y],
                    size2=[body_x, 0],
                    h=body_y * tan(theta),
                    shift=[0,body_y / 2],
                    r=body_edge_radius
                );
                move([0, body_hollow_y_adjustment, -.001]) body_hollow();
                zmove(body_z) {
                    cuboid([body_x * 1.1, body_y * 1.1, body_y * tan(theta)], align=V_TOP);
                }

            }
            backplate();
        }
        phone_socket_cutout();
        move([0, (body_y - body_y_top) / 2, body_z + .001]) {
            lid_recess();
            cable_channel();
        }
        color([1, 1, 1, 1]) tension_bar_cutout();
    }

    controller_mount();
    base_plate();
}

module base_plate() {
    zmove(.001) cuboid([body_x, body_y, 1], fillet=body_edge_radius, align=V_BOTTOM, edges=EDGES_Z_ALL);
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

body();
ymove(100) lid();
