include <BOSL/constants.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>

include <constants.scad>


module controller_mount() {
    controller_total_x = controller_mount_short_side_x + controller_mount_long_side_x - controller_insert_depth;
    xpos = (controller_mount_short_side_x - controller_insert_depth) / 2 - (cavity_x - controller_total_x) / 2;
    ypos = -controller_mount_long_side_y + cavity_y / 2;

    move([xpos, ypos, 0]){
        controller_mount_long_side();
        controller_mount_short_side();
    }
}

module controller_mount_long_side() {
    alignment=V_TOP + V_BACK;

    slot_xpos = -(controller_mount_long_side_x - controller_y) / 2 + .001;
    slop_ypos = -.001;
    slot_zpos = controller_bottom_clearance - (controller_z / 2);

    difference() {
        cuboid(
            [
                controller_mount_long_side_x,
                controller_mount_long_side_y,
                controller_mount_long_side_z
            ],
            align=alignment
        );
        move([slot_xpos, -.001, slot_zpos]) {
            cuboid([controller_y, controller_insert_depth, controller_z], align=alignment);
        }
    }
}

module controller_mount_short_side() {
    alignment = V_TOP + V_FRONT + V_LEFT;

    slot_xpos = .001;
    slot_ypos = -.001;
    slot_zpos = controller_bottom_clearance - (controller_z / 2);

    xpos = -(controller_mount_long_side_x / 2 - controller_insert_depth - .001);
    ypos = controller_mount_long_side_y;

    move([xpos, ypos, 0]) {
        difference() {
            cuboid(
                [
                    controller_mount_short_side_x,
                    controller_mount_short_side_y,
                    controller_mount_short_side_z
                ],
                align=alignment
            );
            move([slot_xpos, slot_ypos, slot_zpos]) {
                cuboid([controller_insert_depth, controller_x, controller_z], align=alignment);
            }
        }
    }
}

module controller_cavity() {
    cable_channel_xpos = cavity_x / 2 - .001;
    cable_channel_ypos = -(controller_mount_long_side_y - controller_insert_depth + (controller_x / 2) - cable_channel_dimension / 2);

    ymove(cavity_y / 2) {
        cuboid([cavity_x, cavity_y, cavity_z], align=V_TOP + V_FRONT);
        move([cable_channel_xpos, cable_channel_ypos, 0]) {
            cuboid(
                [50, cable_channel_dimension, cable_channel_dimension],
                align=V_TOP + V_FRONT + V_RIGHT
            );
        }
        move([0, -cavity_y, 0.001]) {
            cuboid([wire_slot_x, wire_slot_y, 5], align=V_BOTTOM + V_BACK);
        }
    }
}

controller_mount();

#controller_cavity();
