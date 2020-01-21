/*
  For 20mm * 11mm PMMA TIR lenses like: https://www.amazon.com/gp/product/B07VZL6N2Z/

  Replaces/replicates the white plastic plastic housing that comes with the lenses.

  For starboard COB leds like: https://www.amazon.com/gp/product/B07DHB61BH/

  Assumes the main LED body will be ~8mm * 2.5mm (excluding "bubble")
*/
include <common.scad>;
include <20mm_star_lens.scad>;

led_lead_l = 7;

/* Scale the rendered output by this multiple to account for filament shrinkage,
such as if you are using ABS that tends to shrink from 8%-10%. */
shrink_factor = 1.02;

// other

inner_channel_d = lens_ridge_d - 1.5;

// housing_addt = 1;
housing_addt = 0;
// housing_l = lens_total_l+board_t+led_h + housing_addt;
housing_l = lens_cone_l+lens_ridge_l+board_t+led_h + housing_addt;
housing_d = lens_ridge_d + 2;

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
