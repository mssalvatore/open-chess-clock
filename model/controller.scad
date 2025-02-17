include <BOSL/constants.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>

include <constants.scad>

controller_x = 18;
controller_y = 36.2;
controller_z = 1.55;
wall_thickness = 1.75;
insert_depth = 2.6;

top_clearance = 5;
bottom_clearance = 7.5;

long_side_x = controller_y + wall_thickness;
long_side_y = wall_thickness + insert_depth;
long_side_z = bottom_clearance + controller_z + top_clearance;

short_side_x = long_side_y;
short_side_y = (2 * wall_thickness) + controller_x;
short_side_z = long_side_z;


cavity_x = long_side_x + short_side_x - insert_depth;
cavity_y = 42;
cavity_z = long_side_z;

cable_channel_dimension = cavity_z;

module controller_mount() {
    xpos = (short_side_x - insert_depth) / 2;

    xmove(xpos){
        controller_mount_long_side();
        controller_mount_short_side();
    }
}

module controller_mount_long_side() {
    alignment=V_TOP + V_BACK;

    slot_xpos = -(long_side_x - controller_y + .002) / 2;
    slop_ypos = -.001;
    slot_zpos = bottom_clearance - (controller_z / 2);

    difference() {
        cuboid([long_side_x, long_side_y, long_side_z], align=alignment);
        move([slot_xpos, -.001, slot_zpos]) {
            cuboid([controller_y, insert_depth, controller_z], align=alignment);
        }
    }
}

module controller_mount_short_side() {
    alignment = V_TOP + V_FRONT + V_LEFT;

    slot_xpos = .001;
    slot_ypos = .001;
    slot_zpos = bottom_clearance - (controller_z / 2);

    xpos = -(long_side_x / 2 - insert_depth - .001);
    ypos = long_side_y;

    move([xpos, ypos, 0]) {
        difference() {
            cuboid([short_side_x, short_side_y, short_side_z], align=alignment);
            move([slot_xpos, slot_ypos, slot_zpos]) {
                cuboid([insert_depth, controller_x, controller_z], align=alignment);
            }
        }
    }
}

module controller_cavity() {
    cable_channel_xpos = cavity_x / 2 - .001;
    cable_channel_ypos = -(long_side_y - insert_depth + (controller_x / 2) - cable_channel_dimension / 2);

    ymove(long_side_y) {
        cuboid([cavity_x, cavity_y, cavity_z], align=V_TOP + V_FRONT);
        move([cable_channel_xpos, cable_channel_ypos, 0]) {
            cuboid(
                [50, cable_channel_dimension, cable_channel_dimension],
                align=V_TOP + V_FRONT + V_RIGHT
            );
        }
        move([0, -cavity_y, 0.001]) {
            cuboid([cavity_x / 2, cavity_x / 4, 5], align=V_BOTTOM + V_BACK);
        }
    }
}

controller_mount();

#controller_cavity();
