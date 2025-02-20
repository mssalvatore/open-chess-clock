include <BOSL/constants.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>

module phone_clamp_nut_plug() {
    nut_plug_x = 11.1;
    nut_plug_y = 5.8;
    nut_depth = 7;
    nut_diameter = 13;
    nut_cutout_zpos = 3.5;

    difference() {
        cuboid([nut_plug_x, nut_plug_y, nut_depth], align=V_TOP);
        zmove((nut_diameter / 2) + nut_cutout_zpos) {
            yrot(30) {
                cyl(d=nut_diameter, h=nut_depth, orient=ORIENT_Y, $fn=6);
            }
        }

    }
}


phone_clamp_nut_plug();
