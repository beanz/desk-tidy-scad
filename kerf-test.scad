$bom=0;
th = 3;
tab = 10;
use <bnz.scad>
module kerf_test(d = 0.1) {
  difference() {
    square([tab * 2,th*2]);
    for (i=[-1,1]) {
      txy(tab+i*tab, th) ty(th/2) square([tab-d,th], center = true);
    }
  }
  ty(th*2+1) difference() {
    square([tab*2,th*2]);
    tx(tab) ty(th/2) square([tab-d,th], center = true);
  }
}

ty(th*4+2) {
  kerf_test(0.00);
  tx((tab*2+1)*1) kerf_test(0.05);
}
tx((tab*2+1)*0) kerf_test(0.10);
tx((tab*2+1)*1) kerf_test(0.15);
tx((tab*2+1)*2) kerf_test(0.20);
tx((tab*2+1)*3) kerf_test(0.25);
tx((tab*2+1)*4) kerf_test(0.30);
