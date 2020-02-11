include <common.scad>;
include <20mm_star_lens.scad>;
include <20mm_star_lens_carrier.scad>;
led_lead_l = 5;

housing_l = 11;
housing_d = lens_ridge_d + 3;

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
      translate([0, 0, 5]) rotate([0, 0, 180]) rotate([6, 0, 0]) cylinder(d=outer_ridge_d*1.3, h=outer_ridge_max_t);
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
  %handle_cross_section();

  lens_angle = 35;

  housing_y_offset = (outer_d - housing_d)/2;

  // translate([outer_l-housing_l, 0, 4])
  // translate([3.6, 0, 0]) rotate([0,lens_angle,0])
  // translate([0, outer_d/2, outer_d/2]) rotate([0, 90, 0]) {
  //   scale([1,1,1]) {
  //     housing_cross_section();

  //     // r / h = degrees
  //     cone_h = led_h*10;
  //     cone_base_r = cone_h / tan(60); // make cone with 60 degree angle
  //     %translate([0, 0, 0]) cylinder(d1=0, d2=cone_base_r*2, h=cone_h);
  //     %color("blue") cylinder(d=1, h=cone_h);
  //   }
  // }

  difference() {
    hull() {
      difference() {
        scale([1, 0.98, 1]) translate([0, outer_d/2, outer_d/2]) rotate([0, 90, 0]) translate([0, 0, outer_l]) rotate([0, 0, 90]) difference() {
            cylinder(d=outer_ridge_d, h=outer_ridge_max_t);
            translate([0, 0, 6.5]) rotate([0, 0, 180]) rotate([6, 0, 0]) cylinder(d=outer_ridge_d*1.3, h=outer_ridge_max_t);
            // translate([0, 0, -ff]) cylinder(d=outer_ridge_d, h=outer_ridge_max_t+(ff*2));
          }
      }

      /* lens assb hull */
      translate([0, -(outer_d*0.02)/2, 0])
      translate([outer_l-housing_l, 0, 6.5])
      translate([6.8+1.5, 0, 0]) rotate([0,lens_angle,0])
      translate([0, outer_d/2, outer_d/2]) rotate([0, 90, 0]) {
        // translate([0, 0, -housing_l/4])
        // cylinder(d=housing_d, h=housing_l*1.25, center=false);
        cylinder(d=housing_d+2, h=housing_l, center=false);

      }
    }

     /* lens assb cutout */
    translate([0, -(outer_d*0.02)/2, 0])
    translate([outer_l-housing_l, 0, 6.5])
    translate([6.8+1.5, 0, 0]) rotate([0,lens_angle,0])
    translate([0, outer_d/2, outer_d/2]) rotate([0, 90, 0]) {
      // translate([0, 0, -housing_l/4])
      // cylinder(d=housing_d, h=housing_l*1.25, center=false);
      cylinder(d=housing_d, h=housing_l*2, center=false);
      // %cylinder(d=housing_d, h=housing_l, center=false);
    }
  }
}
