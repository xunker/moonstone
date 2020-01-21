include <common.scad>;
include <20mm_star_lens.scad>;
include <20mm_star_lens_carrier.scad>;
led_lead_l = 5;

cavity_d = 28;
cavity_l = 122;

outer_ridge_d = 31;
outer_ridge_min_t = 3;
outer_ridge_max_t = 7;

locating_pin_h = 3;
locating_pin_w = 2.2;

outer_d = cavity_d * 1.2;
outer_l = cavity_l * 1.1;

microusb_body_t = 2.4;
microusb_connector_t = 3; // "flare" at opening of connector
microusb_body_w = 7.4;
microusb_connector_w = 8.0; // ditto flare
microusb_l = 5.5;

module handle() {
  translate([0, outer_d/2, outer_d/2]) rotate([0, 90, 0]) {
    difference() {
      cylinder(d=outer_d, h=outer_l);
      translate([0, 0, outer_l - cavity_l]) cylinder(d=cavity_d, h=cavity_l+ff);
    }

    // locating pin
    translate([(cavity_d/2)-((outer_d-cavity_d)/2), -locating_pin_w/2, 0]) cube([locating_pin_h, locating_pin_w, outer_l]);

    // outer ridge
    translate([0, 0, outer_l]) rotate([0, 0, 90]) difference() {
      cylinder(d=outer_ridge_d*1.2, h=outer_ridge_max_t);
      translate([0, 0, 5]) rotate([6, 0, 0]) cylinder(d=outer_ridge_d*1.3, h=outer_ridge_max_t);
      translate([0, 0, -ff]) cylinder(d=outer_ridge_d, h=outer_ridge_max_t+(ff*2));
    }
  }
}

module handle_cross_section() {
  difference() {
    handle();
    translate([-ff, -outer_d/2, -outer_d/4]) cube([outer_l+outer_ridge_max_t+(ff*2), outer_d, outer_d*2]);
  }


}

module microusb() {
  cube([microusb_connector_w, microusb_l, microusb_connector_t], center=true);
}

module microusb_board() {
  microusb();
  translate([-microusb_body_w/3,0,-microusb_connector_t/1.5]) cube([microusb_body_w*1.5, microusb_l*2, 1.6], center=true);
}

// // simulate handle height while walking
// translate([0, 0, 30*25.4])
// // simulate handle angle while walking
// rotate([0, -8, 0])
  /*
    * 60 degree lens
      * 8 deg handle angle
        * 30 inches high
          * 20 degree lens angle,
            * beam hits the ground at about 40 inches (3.3ft) from user.
          * 25 degree lens angle,
            * beam hits the ground at about 35 inches (2.9ft) from user.
          * 35 degree lens angle,
            * beam hits ground at about 25.5 inches (2.1ft) from user, midpoint at 5.5 feet.

  */
union() {
  handle_cross_section();

  lens_angle = 35.5;

  housing_y_offset = (outer_d - housing_d)/2;

  translate([outer_l-housing_l, 0, 4])
  translate([3.6, 0, 0]) rotate([0,lens_angle,0])
  translate([0, outer_d/2, outer_d/2]) rotate([0, 90, 0]) {
    scale([1,1,1]) {
      housing_cross_section();

      // r / h = degrees
      cone_h = led_h*10;
      cone_base_r = cone_h / tan(60); // make cone with 60 degree angle
      %translate([0, 0, 0]) cylinder(d1=0, d2=cone_base_r*2, h=cone_h);
      %color("blue") cylinder(d=1, h=cone_h);
    }
  }

  translate([outer_l-housing_l, 0, 0])
  translate([18, 0, 13])
  translate([0, outer_d/2, outer_d/2])
  rotate([0, 0, 0])
  microusb_board();
}


// %translate([0, (outer_ridge_d/2)+2, 0]) cube([1,1,outer_ridge_max_t]);
// %translate([0, -(outer_ridge_d/2)-3, 0]) cube([1,1,outer_ridge_min_t]);
// outer_ridge_d = 31;
// outer_ridge_min_t = 3;
// outer_ridge_max_t = 7;
