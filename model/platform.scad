include <BOSL/constants.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>

include <constants.scad>
use <controller.scad>
use <switches.scad>

cavity_border = 5;
floor_thickness = 2.5;
platform_x = cavity_x + 40;
echo(cavity_y);
platform_y = cavity_y + 2 * cavity_border;
platform_z = cavity_z + 2 * floor_thickness;

lid_lip = 1;
wall_thickness = 2;
lid_x = platform_x - wall_thickness - lid_lip;
lid_y = platform_y- wall_thickness - lid_lip;
lid_z = platform_z - (cavity_z) + .002;

fillet = 4;

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

            xmove(-controller_xpos) controller_mount();
        }
        lid_cutout();
        move([platform_x / 2 * sin(45), -((cavity_y / 2) - (wire_slot_y / 2))  , -.001])
            cyl(d=12, h = 1.75, align=V_TOP);
        move([-platform_x / 2 * sin(switch_theta) - 2, -((cavity_y / 2) - (wire_slot_y / 2))  , -.001])
            cyl(d=12, h = 1.75, align=V_TOP);

        // TODO: Make this parametric
        move([-15, -((cavity_y / 2) -(wire_slot_y / 2)), 0]) {
            zrot(90) {
                ground_wire_channel();
                data_wire_channel();
            }
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

platform();
*ymove(-platform_y / 2)zrot(-45) switch_platform();
