include <BOSL/constants.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>

include <constants.scad>
use <controller.scad>
use <switches.scad>


lid_lip = 1;
lid_x = platform_x - body_wall_thickness - lid_lip;
lid_y = platform_y- body_wall_thickness - lid_lip;
lid_tolerance = 0.2;

switch_theta = 45;
phone_theta = 22.5;

phone_clamp_width = 31;
phone_clamp_depth = 21.1;
phone_clamp_screw_shaft_diameter = 7;
phone_clamp_screw_head_diameter = 12;
phone_clamp_screw_head_height =  5;
phone_clamp_screw_hole_ypos = -cos(phone_theta) * lid_z;
phone_clamp_screw_gap = 4.8;

lid_screw_shaft_diameter = 5;
lid_screw_head_diameter = 10;
lid_screw_head_height = 1.6;
lid_nut_diameter = 10.4;
lid_screw_xpos = phone_clamp_depth / 2 + lid_screw_head_diameter / 2 + 1;

wedge_y = cos(phone_theta) * phone_clamp_width;
wedge_ypos = -((lid_y - wedge_y) / 2 - body_wall_thickness);



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

module lid_cutout() {
    zpos = platform_z - lid_z - .003;

    zmove(zpos) {
        cuboid(
            [lid_x + lid_tolerance, lid_y + lid_tolerance, lid_z + .004],
            fillet=fillet,
            edges=EDGES_Z_ALL, align=V_TOP
        );
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


module lid() {
    wedge_z = sin(phone_theta) * phone_clamp_width;
    wedge_wall_thickness = 3;
    wedge_wall_height = 3;
    difference() {
        union() {
            cuboid([lid_x, lid_y, lid_z], fillet=fillet, edges=EDGES_Z_ALL, align=V_TOP);
            move([0, wedge_ypos, lid_z - .001]) {
                zrot(90) {
                    right_triangle([wedge_y, phone_clamp_depth, wedge_z], align=V_TOP + V_CENTER);
                    zmove(wedge_wall_height) {
                        yspread(phone_clamp_depth + wedge_wall_thickness - .002, n=2) {
                            zmove(-.001) {
                                right_triangle([wedge_y,  wedge_wall_thickness, wedge_z], align=V_TOP + V_CENTER);
                            }
                            cuboid([wedge_y, wedge_wall_thickness, wedge_wall_height], align=V_BOTTOM + V_CENTER);
                        }
                    }
                }
            }
        }
        ymove(wedge_ypos) {
            phone_clamp_screw_channel();
        }
        lid_screw();
    }
}

module phone_clamp_screw_channel() {
    channel_y = 50;

    ypos = phone_clamp_screw_hole_ypos + phone_clamp_screw_shaft_diameter / 2;
    zpos = lid_z + tan(phone_theta) * ((wedge_y / 2) - ypos) ;

    screw_head_y_offset = (phone_clamp_screw_head_diameter - phone_clamp_screw_shaft_diameter) / 2;

    move([0, ypos, zpos]) {
        xrot(-phone_theta) {
            zmove(-phone_clamp_screw_gap) {
                cuboid(
                    [phone_clamp_screw_shaft_diameter, channel_y, phone_clamp_screw_gap],
                    align=V_TOP + V_FRONT
                );
                cyl(d=phone_clamp_screw_shaft_diameter, h=phone_clamp_screw_gap, align=V_TOP);
                move([0, screw_head_y_offset, .001]) {
                    cuboid(
                        [
                            phone_clamp_screw_head_diameter,
                            channel_y,
                            phone_clamp_screw_head_height + 1
                        ],
                        align=V_BOTTOM + V_FRONT
                    );
                cyl(
                    d=phone_clamp_screw_head_diameter,
                    h=phone_clamp_screw_head_height + 1,
                    align=V_BOTTOM
                );
                }
            }
        }
    }

}

module lid_screw() {
    screw_head_height_adjustment = 30;

    move([lid_screw_xpos, 0, lid_z +.001]) {
        zmove(screw_head_height_adjustment) {
            cyl(
                d=lid_screw_head_diameter,
                h=lid_screw_head_height + screw_head_height_adjustment,
                align=V_BOTTOM
            );
        }
        zmove(-.001) {
            cyl(d=lid_screw_shaft_diameter, h=platform_z, align=V_BOTTOM);
        }

    }
}


platform();
ymove(65) lid();
