//render = "3d";
//render = "logical";
render = "cuts";
$bom=0;
use <bnz.scad>;
base_width = 100;
base_depth = 80;
th = 3;
full_height = 150;
base_height = 15;
pen_height = 110;
pen_width = 45;
pen_depth = 45;
eta = 0.01;
tab = 20;

module 3d(h = th) {
  linear_extrude(height = h) children();
}

module tabh(d = 0.15) {
  tx(-d/2) square([tab+d, th]);
}

module tabv(d = 0.15) {
  ty(-d/2) square([th, tab+d]);
}

module base() {
  difference() {
    square([base_width,base_depth]);
    for (i = [0:tab*2:base_width]) {
      // front tabs
      tx(i) tabh();
      // back tabs
      txy(i, base_depth-th) tabh();
    }
    for (i = [tab:tab*2:base_depth]) {
      // left tabs
      ty(i) tabv();
      // right tabs
      txy(base_width-th, i) tabv();
    }
    // front pen tabs
    for (i = [0:tab*2:pen_width]) {
      txy(base_width-i, base_depth-pen_depth) tabh();
    }
    // left pen tabs
    for (i = [tab:tab*2:pen_depth]) {
      txy(base_width-pen_width, base_depth-pen_depth+i) tabv();
    }
  }
}

module front() {
  difference() {
    square([base_width, base_height+th]);
    // shallow cut
    txy(20, base_height) square([18, base_height]);
    // deep cut
    txy(38, base_height-th) square([18, base_height]);
    // bottom tabs
    for (i = [tab:tab*2:base_width]) {
      tx(i) tabh();
    }
    // left tab
    ty(th) square([th, base_height/2]);
    // right tab
    txy(base_width-th, th) square([th, base_height/2]);
  }
}

module pen_front() {
  difference() {
    square([pen_width,pen_height+th]);
    // right tabs
    for (i = [0:tab*2:pen_height+th]) {
      txy(pen_width-th, i) tabv();
    }
    // bottom tabs
    for (i = [0:tab*2:pen_width]) {
      tx(pen_width-(tab+i)) tabh();
    }
    // left tabs
    for (i = [0:tab*2:pen_height+th]) {
      ty(i) tabv();
    }
  }
}

module back() {
  difference() {
    square([base_width,full_height+th]);
    // bottom tabs
    for (i = [tab:tab*2:base_width]) {
      tx(i) tabh();
    }
    // left tab
    square([th, base_height+th]);
    // right tabs
    for (i = [0:tab*2:pen_height+th]) {
      txy(base_width-th, i) tabv();
    }
    // pen tabs
    txy(base_width-pen_width, tab) tabv();
    txy(base_width-pen_width, tab*3) tabv();
    txy(base_width-pen_width, tab*5) square([th, tab-10+th]);
  }
}

module left() {
  difference() {
    square([base_height+th, base_depth]);
    // shallow cut
    txy(base_height, 12) square([base_height, 12]);
    // deep cut
    txy(base_height-th, 24) square([base_height, 12]);
    // bottom tabs
    for (i = [0:tab*2:base_depth]) {
      ty(i) tabv();
    }
    // front tab
    tx(base_height/2+th) square([base_height/2, th]);
  }
}

module pen_left() {
  difference() {
    square([pen_height+th, pen_depth]);
    for (i = [tab:tab*2:pen_height]) {
      // front tabs
      tx(i) tabh();
      // front tabs
      txy(i-tab, pen_depth-th) tabh();
    }
    for (i = [0:tab*2:pen_width]) {
      ty(i) tabv();
    }
  }
}

module right() {
  difference() {
    union() {
      square([base_height+th, base_depth]);
      ty(base_depth-pen_depth) square([pen_height+th, pen_depth]);
    }
    // bottom tabs
    for (i = [0:tab*2:base_depth]) {
      ty(i) tabv();
    }
    // front tab
    tx(base_height/2+th) square([base_height/2, th]);
    // back tabs
    for (i = [tab:tab*2:pen_height+th]) {
      txy(i, base_depth-th) tabh();
    }
    // pen front tabs
    for (i = [tab:tab*2:pen_height+th]) {
      txy(i, base_depth-pen_depth) tabh();
    }
  }
}

if (render == "3d") {
  color("yellow") 3d() base();
  color("red") ty(th) rx(90) 3d() front();
  color("red") txy(base_width-pen_width, th+(base_depth-pen_depth)) rx(90) 3d() pen_front();
  color("blue") ty(base_depth) rx(90) 3d() back();
  color("green") tx(th) ry(-90) 3d() left();
  color("green") txy(th+(base_width-pen_width), base_depth-pen_depth) ry(-90) 3d() pen_left();
  color("magenta") tx(base_width) ry(-90) 3d() right();

  // kindle
  //%txyz(8, 8, base_height) rz(-30) rx(-20) tx(-115/2) cube([115, 7, 165]);
  // phone vertical
  //%txyz(8, 8, base_height) rz(-30) rx(-20) tx(-85/2) cube([85, 7, 165]);
  // phone horizontal
  %txyz(15, 15, base_height-th) rz(-30) rx(-20) tx(-165/2) cube([165, 7, 85]);
} else {
  if (render == "logical") {
    color("yellow") base();
    color("green") tx(-2) mirror([1,0,0]) left();
    color("magenta") tx(base_width+2) right();
    color("red") ty(-2) mirror([0,1,0]) front();
    color("blue") ty(base_depth+2) back();
    color("red") txy(base_width+2, -pen_width) rz(90) mirror([0,1,0]) pen_front();
    color("green") txy(base_width+2,-2-pen_width) mirror([0,1,0]) pen_left();
  } else {
    color("yellow") base();
    txy(base_width+pen_height,19) rz(90) color("green") left();
    color("magenta") txy(base_width+2, th) right();
    tx(base_width+base_height+th+4) color("red") front();
    color("blue") ty(base_depth+2) back();
    color("red") txy(base_width+2, base_depth+th+2) pen_front();
    color("green") txy(base_width+pen_width+pen_depth+4, base_depth+th+2) rz(90) pen_left();
  }
}
