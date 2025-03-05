include <BOSL/constants.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>

include <constants.scad>

lid_lip = 1;
lid_x = platform_x - body_wall_thickness - lid_lip;
lid_y = platform_y- body_wall_thickness - lid_lip;
lid_tolerance = 0.2;



wedge_y = cos(phone_theta) * phone_clamp_width;
wedge_ypos = -((lid_y - wedge_y) / 2 - body_wall_thickness);

wedge_z = sin(phone_theta) * phone_clamp_width;
wedge_wall_thickness = 3;
wedge_wall_height = 3;

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

module lid() {
    difference() {
        union() {
            cuboid([lid_x, lid_y, lid_z], fillet=fillet, edges=EDGES_Z_ALL, align=V_TOP);
            wedge();
        }
        ymove(wedge_ypos) {
            phone_clamp_screw_channel();
        }
        lid_screw();
    }
}

module wedge() {
    move([0, wedge_ypos, lid_z - .001]) {
        zrot(90) {
            right_triangle([wedge_y, phone_clamp_depth, wedge_z], align=V_TOP + V_CENTER);
            zmove(wedge_wall_height) {
                wedge_walls();
            }
        }
    }
}

module wedge_walls() {
    yspread(phone_clamp_depth + wedge_wall_thickness - .002, n=2) {
        zmove(-.001) {
            right_triangle([wedge_y,  wedge_wall_thickness, wedge_z], align=V_TOP + V_CENTER);
        }
        cuboid( [wedge_y, wedge_wall_thickness, wedge_wall_height], align=V_BOTTOM + V_CENTER);
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

lid();

*intersection() {
    lid();
    ymove(8)
    zmove(-.001)
    cuboid([28, 50, 20], align=V_TOP + V_FRONT);
}
