include <BOSL/constants.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>

include <constants.scad>

tension_bar_tolerance = 0.25;
tension_bar_x_depth = 3;
tension_bar_wall = 1.25;
tension_bar_x = phone_x + 2 * tension_bar_x_depth;
tension_bar_y = 4;
tension_bar_z = phone_z - 2 * tension_bar_wall;

cutout_x = tension_bar_x + (2 * tension_bar_tolerance);
cutout_y = 16;
cutout_z = tension_bar_z + tension_bar_tolerance ;



module tension_bar_cutout() {
    z_pos = cos(theta) * cutout_z + sin(theta) * cutout_y;
    y_pos = (body_y / 2) - tension_bar_wall - (z_pos / tan(theta));

    move([0, -y_pos, z_pos]) {
        xrot(theta) {
            cuboid([cutout_x, cutout_y, cutout_z], align=V_BOTTOM + V_FRONT);
        }
    }
}

module tension_bar(height) {
    text_depth = 0.2;
    size = tension_bar_z / 2;
    text_x_pos = -2 * size / 2;
    text_y_pos = -size / 2;
    text_z_pos = (height / 2) - text_depth + .001;

    difference() {
        xrot(90) cuboid([tension_bar_x, height, tension_bar_z], align=V_CENTER);
        move([text_x_pos, text_y_pos, text_z_pos]) {
            linear_extrude(text_depth) text(str(height, " mm"), size=size);
       }
    }
}


module tension_bar_inserts() {
    zmove(0.5) tension_bar(1);
    zmove(1) ymove(1 * (tension_bar_z + 2)) tension_bar(2);
    zmove(2) ymove(2 * (tension_bar_z + 2)) tension_bar(4);
    zmove(4) ymove(3 * (tension_bar_z + 2)) tension_bar(8);
}

tension_bar_inserts();
