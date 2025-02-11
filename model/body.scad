include <BOSL/constants.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>

use <hotswap_pcb_generator/scad/switch.scad>
include <hotswap_pcb_generator/scad/parameters.scad>

include <constants.scad>

$fn=64;

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
        [lid_x + lid_tolerance, lid_y + lid_tolerance, lid_z + .001],
        align=V_BOTTOM,
        fillet=body_edge_radius,
        edges=EDGE_FR_RT+ EDGE_FR_LF + EDGE_BK_RT + EDGE_BK_LF

    );
}

module pcb_mount() {
    yrot(-90) {
        xmove(pcb_mount_x / 2) {
            difference() {
                cuboid([pcb_mount_x, pcb_mount_y, pcb_mount_z], align=V_TOP + V_BACK);
                move([0, -.001, pcb_z_clearance]) {
                    cuboid([pcb_x, pcb_insert_depth, micro_pcb_thickness], align=V_TOP + V_BACK);
                }
            }
        }
        difference() {
            cuboid(
                [pcb_insert_depth + pcb_mount_wall_thickness, pcb_y, pcb_mount_z],
                align=V_TOP + V_FRONT + V_RIGHT
            );
            move([pcb_mount_wall_thickness + .001, .001, pcb_z_clearance]) {
                cuboid(
                    [pcb_insert_depth, pcb_y + .002, micro_pcb_thickness],
                    align=V_TOP + V_FRONT + V_RIGHT
                );
            }
        }
    }
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

    move([0, -phone_socket_center_y - .002, phone_socket_center_z + .001]) {
        xrot(theta) {
            cuboid([phone_x - .002, phone_y - .002, body_wall_thickness + .004], align=V_BOTTOM);
            xmove(phone_x / 2) {
                usb_cable_relief();
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

module tension_bar_cutout() {
    cutout_x = tension_bar_x + (2 * tension_bar_tolerance);
    cutout_y = (2 * tension_bar_y) - tension_bar_wall;
    cutout_z = tension_bar_z + tension_bar_tolerance ;

    z_pos = cos(theta) * cutout_z + sin(theta) * cutout_y;
    y_pos = (body_y / 2) - tension_bar_wall - (z_pos / tan(theta));

    move([0, -y_pos, z_pos]) {
        xrot(theta) {
            cuboid([cutout_x, cutout_y, cutout_z], align=V_BOTTOM + V_FRONT);
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
        }
        color([1, 1, 1, 1]) tension_bar_cutout();
    }

    xmove(body_hollow_x / 2 + .001) {
        ymove((body_hollow_y / 2) - pcb_mount_y + body_hollow_y_adjustment + .001) {
            zmove(pcb_mount_y - .001) {
                pcb_mount();
            }
        }
    }
}

module switch_socket_hole() {
    zmove(-.001) cuboid([socket_hole_dimension, socket_hole_dimension, lid_z + .002], align=V_TOP);
}

module switch_socket_1() {
    move([-socket_dimension / 2, socket_dimension / 2, switch_z_offset]) switch_socket();
}

module lid() {
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

body();
ymove(100) lid();
