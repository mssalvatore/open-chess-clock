include <BOSL/constants.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>

use <hotswap_pcb_generator/scad/switch.scad>
include <hotswap_pcb_generator/scad/parameters.scad>

include <constants.scad>

$fn=64;

module body_hollow() {
    thickness_offset_x = 2 * body_wall_thickness;
    rounded_prismoid(
        size1=[
            body_x - thickness_offset_x,
            body_hollow_y_bottom
        ],
        size2=[
            body_x - thickness_offset_x,
            body_hollow_y_top
        ],
        h=body_z - body_wall_thickness + .001,
        shift=[0, (body_hollow_y_bottom - body_hollow_y_top) / 2],
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

module pcb_mount() {
    difference() {
        cuboid([pcb_mount_x, pcb_mount_y, pcb_mount_z], align=V_TOP + V_BACK);
        move([0, -.001, pcb_z_clearance]) cuboid([pcb_x, pcb_insert_depth, micro_pcb_thickness], align=V_TOP + V_BACK);
    }
    move([pcb_mount_hole_x, -pcb_mount_hole_y, 0]) {
        cyl(d=pcb_mount_hole_diameter * 1.5, h=pcb_z_clearance, align=V_TOP);
        zmove(pcb_z_clearance) cyl(d=pcb_mount_hole_diameter, h=micro_pcb_thickness * 1.5, align=V_TOP);
    }
}

module phone_socket_cutout() {
    center_z = body_z / 2;
    center_y = (body_y / 2) - (center_z / tan(body_theta));
    move([0, -center_y - .001, center_z + .001]) {
        xrot(body_theta) {
            cuboid([phone_x - .001, phone_y - .001, body_front_thickness + .002], align=V_BOTTOM);
        }
    }
}

module body() {
    body_hollow_y_adjustment = (body_front_thickness - body_wall_thickness);

    difference() {
        rounded_prismoid(
            size1=[body_x, body_y],
            size2=[body_x,body_y_top],
            h=body_z,
            shift=[0,(body_y - body_y_top) / 2],
            r=body_edge_radius
        );
        move([0, body_hollow_y_adjustment, body_wall_thickness]) body_hollow();
        move([0, (body_y - body_y_top - (body_hollow_y_adjustment / 2)) / 2, body_z]) lid_recess();
        phone_socket_cutout();
    }

    ymove(-pcb_mount_y + (body_hollow_y_bottom / 2) + body_hollow_y_adjustment + .001) {
        zmove(body_wall_thickness - .001) {
            pcb_mount();
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
