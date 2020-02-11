include <common.scad>;

cavity_l = 5;

difference() {
  union() {
    difference() {
      cylinder(d=cavity_d, h=cavity_l, $fn=64);

      translate([-locating_pin_w/2, -cavity_d/2, -ff]) cube([locating_pin_w, locating_pin_h, cavity_l+(ff*2)]);
    }

    difference() {
      scale([1, 0.98, 1])
      translate([0, 0, cavity_l])
      difference() {
          cylinder(d=outer_ridge_d, h=outer_ridge_max_t, $fn=64);
          translate([0, 0, 6.5]) rotate([0, 0, 180]) rotate([6, 0, 0]) cylinder(d=outer_ridge_d*1.3, h=outer_ridge_max_t);
        }
    }
  }

  translate([0, locating_pin_h/2, -ff]) scale([0.8, 0.75, 1]) cylinder(d=cavity_d*0.9, h=cavity_l+outer_ridge_max_t);
}
