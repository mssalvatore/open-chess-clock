include <BOSL/constants.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>

include <constants.scad>

slot_zpos = controller_bottom_clearance - (controller_z / 2);

module controller_mount() {
    controller_total_x = controller_mount_short_side_x + controller_mount_long_side_x;
    xpos = (controller_mount_short_side_x - controller_insert_depth) / 2 - (cavity_x - controller_total_x) / 2;
    ypos = -controller_mount_long_side_y + cavity_y / 2;

    move([xpos, ypos, 0]){
        difference() {
            union() {
                controller_mount_long_side();
                controller_mount_short_side();
            }
        }
    }
}

module controller_mount_long_side() {
    alignment=V_TOP + V_BACK;

    slot_xpos = -(controller_mount_long_side_x - controller_y) / 2 + .001;
    slop_ypos = -.001;

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
            cuboid([controller_y + 1, controller_insert_depth, controller_z], align=alignment);
        }
    }
}

module controller_mount_short_side() {
    alignment = V_TOP + V_FRONT + V_LEFT;

    slot_xpos = .001;
    slot_ypos = -.001;

    xpos = -(controller_mount_long_side_x / 2 - controller_insert_depth / 2 - .001);
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
    ymove(cavity_y / 2) {
        cuboid([cavity_x, cavity_y, cavity_z], fillet=fillet, edges=EDGES_Z_LF, align=V_TOP + V_FRONT);
        move([cable_channel_xpos, cable_channel_ypos, 0]) {
            cuboid(
                [cable_channel_length, cable_channel_dimension, cable_channel_dimension],
                align=V_TOP + V_FRONT + V_RIGHT
            );
        }
        move([0, -cavity_y, 0.001]) {
            cuboid([wire_slot_x, wire_slot_y, 5], align=V_BOTTOM + V_BACK);
        }
        strain_relief_recess();
    }
}

module strain_relief_recess() {
    tolerance = 0.35;
    cutout_x = strain_relief_lip_z + tolerance;
    cutout_y = cavity_z + strain_relief_lip + 2 * tolerance;
    cutout_z = cavity_z + strain_relief_lip + 2 * tolerance;

    xpos = cavity_x / 2  + cable_channel_length - cutout_x + .001;
    ypos = cable_channel_ypos + (strain_relief_lip / 2 + tolerance);
    zpos = -(strain_relief_lip / 2 + tolerance);

    move([xpos, ypos, zpos]) {
        cuboid(
            [
                cutout_x,
                cutout_y,
                cutout_z
            ],
            fillet = strain_relief_fillet + tolerance,
            edges=EDGES_X_ALL,
            align=V_TOP + V_FRONT + V_RIGHT
        );
    }
}

*intersection() {
    controller_mount();
    #cuboid([controller_mount_long_side_x, controller_mount_short_side_y + 10, 20], align=V_BACK + V_TOP + V_LEFT);
}
controller_mount();

*controller_cavity();
