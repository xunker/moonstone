include <common.scad>;

difference() {
  cylinder(d=cavity_d, h=cavity_l, $fn=64);
  // translate([0, locating_pin_h/2.5, 1]) scale([1, 0.93, 1]) cylinder(d=cavity_d*0.9, h=cavity_l-1+(ff*2));

  translate([-locating_pin_w/2, -cavity_d/2, -ff]) cube([locating_pin_w, locating_pin_h, cavity_l+(ff*2)]);
}
