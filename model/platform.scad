include <BOSL/constants.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>

include <constants.scad>
use <controller.scad>
use <switches.scad>
use <lid.scad>

switch_theta = 45;

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

            zmove(floor_thickness) xmove(-controller_xpos) controller_mount();
        }
        lid_cutout();
        wire_bends();
        right_switch_wire_channels();
        extra_material_removal();
        platform_lid_screw();
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


module wire_bends() {
    move([platform_x / 2 * sin(45), -((cavity_y / 2) - (wire_slot_y / 2))  + 1.5 , -.001])
        cyl(d=12, h = 1.75, align=V_TOP);
    move([-platform_x / 2 * sin(switch_theta), -((cavity_y / 2) - (wire_slot_y / 2)) + 5  , -.001])
        cyl(d=12, h = 1.75, align=V_TOP);
}

module right_switch_wire_channels() {
    // TODO: Make this parametric
    move([-22, -((cavity_y / 2) -(wire_slot_y / 2) - 0.75), 0]) {
        zrot(90) {
            ground_wire_channel();
            data_wire_channel();
        }
    }
}

module extra_material_removal() {
    // TODO: This should be defined in terms of the USB cable channel Y dimension.
    move([-1, -cavity_y / 2, floor_thickness]) {
        cuboid([platform_x / 1.8 - 3 * body_wall_thickness, cavity_y / 2.5, cavity_z], align=V_TOP + V_RIGHT + V_BACK);
    }
}

module platform_lid_screw() {
    nut_shaft_height = platform_z / 2;
    move([lid_screw_xpos, 0, -.001]) {
        cyl(d=lid_nut_diameter, h=nut_shaft_height, align=V_TOP, $fn=6);
        zmove(nut_shaft_height-.001) {
            cyl(d=lid_screw_shaft_diameter, h=platform_z, align=V_TOP);
        }
    }
}


platform();
ymove(65) lid();
