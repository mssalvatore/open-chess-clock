include <BOSL/constants.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>

include <constants.scad>
use <controller.scad>
use <switches.scad>

cavity_border = 3;
floor_thickness = 2.5;
platform_x = cavity_x + 40;
platform_y = cavity_y + 2 * cavity_border;
platform_z = cavity_z + 2 * floor_thickness;

lid_lip = 1;
wall_thickness = 2;
lid_x = platform_x - wall_thickness - lid_lip;
lid_y = platform_y- wall_thickness - lid_lip;
lid_z = platform_z - (cavity_z) + .002;

fillet = 4;

switch_theta = 45;
phone_theta = 22.5;

screw_shaft_diameter = 6.35;
screw_head_diameter = 12;
screw_head_height = 4;
nut_diameter = 8;
nut_height = 4;
lid_screw_xpos = 10;
lid_screw_ypos = -2;


module platform() {
    controller_xpos = (platform_x - cavity_x) / 2 - cavity_border;
    switch_ypos = -((platform_y / 2) - (sin(switch_theta) * switch_platform_x));
    switch_xpos = (platform_x / 2) - (cos(switch_theta) * switch_platform_x);

    difference() {
        union() {
            difference() {
                union() {
                    cuboid([platform_x, platform_y, platform_z], fillet=fillet, edges=EDGES_Z_ALL, align=V_TOP);
                    switches(switch_xpos, switch_ypos);
                }
                wire_channels(switch_xpos, switch_ypos);
                move([-controller_xpos, 0, floor_thickness]) {
                    controller_cavity();
                }
            }

            xmove(-controller_xpos) controller_mount();
        }
        lid_cutout();
        move([platform_x / 2 * sin(45), -((cavity_y / 2) - (wire_slot_y / 2))  + 1.5 , -.001])
            cyl(d=12, h = 1.75, align=V_TOP);
        move([-platform_x / 2 * sin(switch_theta), -((cavity_y / 2) - (wire_slot_y / 2)) + 5  , -.001])
            cyl(d=12, h = 1.75, align=V_TOP);

        // TODO: Make this parametric
        move([-16, -((cavity_y / 2) -(wire_slot_y / 2) - 0.75), 0]) {
            zrot(90) {
                ground_wire_channel();
                data_wire_channel();
            }
        }

        zmove(floor_thickness)
        ymove(-cavity_y / 2)
        cuboid([platform_x / 2 - 3 * wall_thickness, cavity_y / 3, cavity_z], align=V_TOP + V_RIGHT + V_BACK);
        platform_lid_screw();
    }
}

module platform_lid_screw() {
    nut_shaft_height = nut_height + 0;
    move([lid_screw_xpos, lid_screw_ypos, -.001]) {
        cyl(d=nut_diameter, h=nut_shaft_height, align=V_TOP, $fn=6);
        zmove(nut_shaft_height-.001) {
            cyl(d=screw_shaft_diameter, h=platform_z, align=V_TOP);
        }
    }
}

module switches(switch_xpos, switch_ypos) {
    move([-switch_xpos, switch_ypos, 0]) {
        zrot(-switch_theta) switch_platform();
    }
    move([switch_xpos, switch_ypos, 0]) {
        zrot(switch_theta) switch_platform();
    }
}
module wire_channels(switch_xpos, switch_ypos) {
    move([switch_xpos, switch_ypos, 0]) {
        zrot(switch_theta) {
            ground_wire_channel();
            data_wire_channel();
        }
    }
    move([-switch_xpos, switch_ypos, 0]) {
        zrot(-switch_theta) {
            ground_wire_channel();
            data_wire_channel();
        }
    }
}

module lid_cutout() {
    zpos = platform_z - lid_z + .001;

    zmove(zpos) {
        cuboid([lid_x, lid_y, lid_z], fillet=fillet, edges=EDGES_Z_ALL, align=V_TOP);
    }
}

module lid() {
    difference() {
        union() {
            cuboid([lid_x, lid_y, lid_z], fillet=fillet, edges=EDGES_Z_ALL, align=V_TOP);
            zmove(lid_z - .001) {
                zrot(90) right_triangle([cos(phone_theta) * 31, 10, sin(phone_theta) * 31], align=V_TOP + V_CENTER);
            }
        }
        phone_clamp_screw_hole();
    }
}

module phone_clamp_screw_hole() {
    ymove(-12) {
        xrot(-phone_theta) {
            cyl(d=screw_head_diameter, h=screw_head_height);
            zmove(screw_head_height / 2 - .001){
                cyl(d=screw_shaft_diameter, h=20, align=V_TOP);
            }
        }
    }

    lid_screw();
}

module lid_screw() {
    move([lid_screw_xpos, lid_screw_ypos, lid_z +.001]) {
        cyl(d=screw_head_diameter, h=screw_head_height, align=V_BOTTOM);
        zmove(-.001) {
            cyl(d=screw_shaft_diameter, h=platform_z, align=V_BOTTOM);
        }

    }
}


platform();
ymove(60) lid();
*lid();
*ymove(-platform_y / 2)zrot(-45) switch_platform();
