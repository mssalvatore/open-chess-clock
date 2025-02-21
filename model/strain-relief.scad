include <BOSL/constants.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>

include <constants.scad>

strain_relief_x = cavity_z + .5;
strain_relief_y = cavity_z + .5;
strain_relief_z = 12;


lip = 2;
lip_z = 1;

usb_cable_diameter = 4.0;
usb_cable_radius = usb_cable_diameter / 2;

hole_ypos = strain_relief_y / 2 - usb_cable_radius - 3.5;

xflip_copy() {
    xmove(-1.5) {
        left_half() {
            difference() {
                union() {
                    cuboid([strain_relief_x, strain_relief_y, strain_relief_z], align=V_TOP);
                    zmove(.001) {
                        cuboid(
                            [strain_relief_x + lip, strain_relief_y + lip, lip_z],
                            fillet=2,
                            edges=EDGES_Z_ALL,
                            align=V_BOTTOM
                        );
                    }
                }
                move([0, hole_ypos, -lip_z])
                cyl(d = usb_cable_diameter, h = strain_relief_z + lip_z + .002, align=V_TOP);
            }
        }
    }
}
