include <BOSL/constants.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>

include <constants.scad>

controller_x = 18;
controller_y = 36.2;
controller_z = 1.55;
wall_thickness = 1.75;
insert_depth = 2.6;
clearance = 6;

long_side_x = wall_thickness + controller_z + clearance;
long_side_y = controller_y + wall_thickness;
long_side_z = wall_thickness + insert_depth;

short_side_x = long_side_x;
short_side_y = long_side_z + 10;
short_side_z = (2 * wall_thickness) + controller_x;

strain_relief_wall_thickness = wall_thickness * 2;
strain_relief_x_pos = -(short_side_x - .001);
strain_relief_z_pos = wall_thickness + controller_x / 2 - strain_relief_wall_thickness - usb_cable_width / 2;
strain_relief_theta = 42;
strain_relief_x = tan(strain_relief_theta) * strain_relief_z_pos;
strain_relief_y = short_side_y - 10;
strain_relief_z = strain_relief_wall_thickness + usb_cable_width;

mount_x = long_side_x + strain_relief_x;
mount_y = long_side_y + short_side_y;
mount_z = short_side_z;
mount_z_adjustment = wall_thickness / sin(theta);

mount_xpos = body_hollow_x / 2  - mount_y + .001;
mount_ypos = (body_hollow_y /2) - body_hollow_y_adjustment / 2 - short_side_z * cos(theta);
mount_zpos = phone_y * sin(theta) / 2 - short_side_z / 2;


module controller_mount() {
    move([mount_xpos, mount_ypos, mount_zpos]) {
        zrot(90)
        difference() {
            union() {
                yrot((90-theta)) {
                    ymove(-long_side_y) {
                        controller_mount_short_side();
                        controller_mount_long_side();
                        strain_relief();
                    }
                }
            }
            *union() {
                ymove(-.001) {
                    cuboid([mount_x * 3, mount_y * 2, mount_z * 2], align=V_BOTTOM + V_FRONT);
                }
                move([0,-sin(theta) * mount_y, cos(theta) * mount_y]) {
                    cuboid([mount_x * 3, mount_y * 2, mount_z * 2], align=V_BOTTOM + V_FRONT);
                }
            }
        }
    }
}

module controller_mount_short_side() {
    alignment = V_TOP + V_FRONT + V_LEFT;

    difference() {
        cuboid([short_side_x, short_side_y, short_side_z], align=alignment);
        move([-clearance, .001, wall_thickness]) {
            cuboid([controller_z, insert_depth, controller_x], align=alignment);
        }
    }
}

module controller_mount_long_side() {
    alignment=V_TOP + V_BACK + V_LEFT;
    difference() {
        cuboid([long_side_x, long_side_y, long_side_z], align=alignment);
        move([-clearance, -.001, wall_thickness + .001]) {
            cuboid([controller_z, controller_y, insert_depth], align=alignment);
        }
    }

    *long_side_support();
}

module long_side_support() {
    alignment = V_TOP + V_BACK + V_RIGHT;
    support_theta = 35;
    support_y = tan(support_theta) * (cos(theta) * long_side_y);
    support_x = long_side_x;
    support_z = tan(support_theta) * sin(support_theta) * mount_y;

    difference() {
        ymove(-short_side_y) {
            yrot(180) {
                right_triangle([support_x, mount_y, support_z], orient=ORIENT_Y, align=alignment);
            }
        }
    }
}

module strain_relief() {
    alignment = V_TOP + V_FRONT + V_LEFT;
    move([strain_relief_x_pos - .001, 0, strain_relief_z_pos]) {
        difference() {
            cuboid([strain_relief_x, strain_relief_y, strain_relief_z],align=alignment);
            move([.001, .001, strain_relief_wall_thickness]) {
                cuboid(
                    [usb_cable_thickness, strain_relief_y + .002, usb_cable_width + .001],
                    align=alignment
                );
            }
        }
        yrot(180) {
            right_triangle(
                [strain_relief_x, strain_relief_y, strain_relief_z_pos],
                orient=ORIENT_Y,
                align=V_TOP + V_FRONT + V_RIGHT
            );
        }
    }
}

#controller_mount();
