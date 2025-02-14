include <BOSL/constants.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>

include <constants.scad>

controller_thickness = 1.55;
controller_mount_wall_thickness = 1.75;
controller_x = 18;
controller_y = 36.2;
controller_insert_depth = 2.6;
controller_z_clearance = 7;
controller_mount_x = controller_x + (2 * controller_mount_wall_thickness);
controller_mount_y = controller_insert_depth + controller_mount_wall_thickness;
controller_mount_z = controller_z_clearance + controller_thickness + controller_mount_wall_thickness;

module controller_mount() {
    xpos = body_hollow_x / 2 + .001;
    ypos = (body_hollow_y /2) + body_hollow_y_adjustment - cos(theta) * controller_mount_x + controller_mount_wall_thickness;
    zpos = controller_mount_y - .001;
    move([xpos, ypos, zpos]) {
        xrot(-(90-theta)) {
            ymove(-controller_mount_y) {
                yrot(-90) {
                    xmove(controller_mount_x / 2) {
                        controller_mount_short_side();
                    }
                    controller_mount_long_side();
                }
            }
        }
    }
}

module controller_mount_short_side() {
    difference() {
        cuboid([controller_mount_x, controller_mount_y, controller_mount_z], align=V_TOP + V_BACK);
        move([0, -.001, controller_z_clearance]) {
            cuboid(
                [controller_x, controller_insert_depth, controller_thickness],
                align=V_TOP + V_BACK
            );
        }
    }
}
module controller_mount_long_side() {
    difference() {
        cuboid(
            [
                controller_insert_depth + controller_mount_wall_thickness,
                controller_y + controller_mount_wall_thickness,
                controller_mount_z
            ],
            align=V_TOP + V_FRONT + V_RIGHT
        );
        move([controller_mount_wall_thickness + .001, .001, controller_z_clearance]) {
            cuboid(
                [
                    controller_insert_depth,
                    controller_y - controller_insert_depth / 2,
                    controller_thickness
                ],
                align=V_TOP + V_FRONT + V_RIGHT
            );
        }
    }
}
