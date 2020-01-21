/*
  For 20mm * 11mm PMMA TIR lenses like: https://www.amazon.com/gp/product/B07VZL6N2Z/

  Replaces/replicates the white plastic plastic housing that comes with the lenses.

  For starboard COB leds like: https://www.amazon.com/gp/product/B07DHB61BH/

  Assumes the main LED body will be ~8mm * 2.5mm (excluding "bubble")
*/
include <common.scad>;

// Lens
lens_ridge_d = 20;
lens_ridge_l = 1.15;

lens_front_d = 17.6;
lens_front_l = 1;

lens_cone_l = 11 - (lens_ridge_l + lens_front_l);

lens_aperture_d = 6;

lens_total_l = lens_cone_l + lens_ridge_l + lens_front_l;

// LED Star Board
board_d = 20;
board_t = 1.22;
castelations = 6;
castelation_r = 2.5;

led_d = 8.25;
led_h = 2.5; // just body, not bubble
led_lead_w = 4;
led_lead_l = 3;
led_bubble_d = 5.5;


module lens() {
  cylinder(d=lens_front_d, h=lens_front_l);
  translate([0, 0, lens_front_l]) {
    cylinder(d=lens_ridge_d, h=lens_ridge_l, $fn=48);
      translate([0, 0, lens_ridge_l]) {
        cylinder(d2=lens_aperture_d, d1=lens_front_d, h=lens_cone_l);
      }
  }
}

module star_board(include_castelations=true) {
  difference() {
    cylinder(d=board_d, h=board_t, $fn=48);
    if (include_castelations) {
      for(deg=[0:(360/castelations):360]) {
        rotate([0, 0, deg]) translate([board_d/2, 0, -ff]) cylinder(r=castelation_r, h=board_t+(ff*2));
      }
    }
  }
  translate([0, 0, board_t]) led();
}

module led() {
  cylinder(d=led_d, h=led_h, $fn=32);
  translate([-((led_lead_l*2)+led_d)/2, -led_lead_w/2, 0]) cube([(led_lead_l*2)+led_d, led_lead_w, led_h]);
  translate([0, 0, led_h]) sphere(d=led_bubble_d, $fn=16);
}

module lens_and_led(include_castelations=true) {
  translate([0, 0, lens_total_l+board_t+led_h]) rotate([0, 180, 0]) lens();
  star_board(include_castelations);
}

// lens_and_led();
