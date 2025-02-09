include <BOSL/constants.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>

use <hotswap_pcb_generator/scad/switch.scad>
include <hotswap_pcb_generator/scad/parameters.scad>

include <constants.scad>

$fn=64;

module body_hollow() {
    thickness_offset_x = 2 * body_wall_thickness;
    thickness_offset_y = body_wall_thickness + body_front_thickness;
    rounded_prismoid(
        size1=[
            body_x - thickness_offset_x,
            calculate_y_offset(body_y - thickness_offset_y, body_wall_thickness, body_theta)
        ],
        size2=[
            body_x - thickness_offset_x,
            calculate_y_offset(body_y - thickness_offset_y, body_z - body_wall_thickness, body_theta)
        ],
        h=body_z - body_wall_thickness + .001,
        shift=[0, (body_y - body_y_top) / 2],
        r=body_edge_radius
    );

}

module lid_recess() {
    cuboid(
        [lid_x + lid_tolerance, lid_y + lid_tolerance, lid_z + .001],
        align=V_BOTTOM,
        fillet=body_edge_radius,
        edges=EDGE_FR_RT+ EDGE_FR_LF + EDGE_BK_RT + EDGE_BK_LF

    );
}
module body() {
    difference() {
        rounded_prismoid(
            size1=[body_x, body_y],
            size2=[body_x,body_y_top],
            h=body_z,
            shift=[0,(body_y - body_y_top) / 2],
            r=body_edge_radius
        );
        move([0, (body_front_thickness - body_wall_thickness) / 2, body_wall_thickness]) body_hollow();
        move([0, (body_y - body_y_top) / 2, body_z]) lid_recess();
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
