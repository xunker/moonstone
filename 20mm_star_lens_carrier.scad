/*
  For 20mm * 11mm PMMA TIR lenses like: https://www.amazon.com/gp/product/B07VZL6N2Z/

  Replaces/replicates the white plastic plastic housing that comes with the lenses.

  For starboard COB leds like: https://www.amazon.com/gp/product/B07DHB61BH/

  Assumes the main LED body will be ~8mm * 2.5mm (excluding "bubble")
*/

/* Scale the rendered output by this multiple to account for filament shrinkage,
such as if you are using ABS that tends to shrink from 8%-10%. */
shrink_factor = 1.02;

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
led_lead_l = 7;
led_bubble_d = 5.5;

// other

inner_channel_d = lens_ridge_d - 1.5;

// housing_addt = 1;
housing_addt = 0;
// housing_l = lens_total_l+board_t+led_h + housing_addt;
housing_l = lens_cone_l+lens_ridge_l+board_t+led_h + housing_addt;
housing_d = lens_ridge_d + 2;

ff = 0.01;

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

module housing_cutouts_mock() {
  // pcb cutout
    translate([0, 0, 0]) cylinder(d=board_d, h=board_t);
    // ridge cutout
    translate([0, 0, board_t+led_h+lens_cone_l]) cylinder(d=lens_ridge_d, h=lens_ridge_l);
    // led cutout
    translate([0, 0, board_t]) led();
}

module housing_cutouts_real() {
  translate([0, 0, 0])
      lens_and_led(include_castelations=false);
}

module housing() {
  difference() {
    union() {
      difference() {
        cylinder(d=housing_d, h=housing_l);

        // centre channel
        translate([0, 0, -ff]) cylinder(d=inner_channel_d, h=housing_l+(ff*2));
      }

      translate([0, 0, board_t]) {
        cylinder(d=inner_channel_d, h=led_h-ff);
      }
    }

    translate([0, 0, housing_addt])
      // housing_cutouts_mock();
      housing_cutouts_real();
  }
}

module housing_cross_section() {
  intersection() {
    translate([-housing_d/2, 0, 0]) cube([housing_d, housing_d/2, housing_l+(ff*2)]);
    translate([0, 0, -board_t])
      housing();
  }
}

module housing_no_lower() {
  intersection() {
    translate([-housing_d/2, -housing_d/2, 0]) cube([housing_d, housing_d, housing_l+(ff*2)]);
    translate([0, 0, -board_t])
      housing();
  }
}

// lens();
// led();
// star_board();
// translate([0, 0, housing_addt])
//   %lens_and_led();

scale([shrink_factor, shrink_factor, shrink_factor]) {
  // housing();
  // housing_cross_section();
  housing_no_lower();
}
