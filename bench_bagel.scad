
$fn = 50;

/*
union() {
    cylinder(d=70-3, h=30);

    translate([0,0,3]) {
        cylinder(d=70, h=30-(3*2));
    }

    torus(d=70, r=3);

    translate([0,0,30-(3*2)]) {
        torus(d=70, r=3);
    }
}
*/

r=3;
h=30;
d=70;
bolt_d=5.48;
bolt_corner_width=11.05;
riser_height=12.4;
threaded_insert_w=4.8;
threaded_insert_d=5;

difference() {

    union() {
        body();
        topBoltHoleSupports();
    }

    translate([0, 0, r]) boltHeadCutout();
    
    topBoltHolePattern();
}

module topBoltHoleSupports() {
    support_d = threaded_insert_w * 1.6;
    for(i=[0:90:270]) {
        rotate([0,0,i]) translate([0,h-(d/2*0.1),r]) {
            linear_extrude(h-r*2) {
               circle(d=support_d);
               translate([0,support_d/2,0]) square(support_d,support_d,center=true);
            }
        }
    }
}

module topBoltHolePattern() {
    for(i=[0:90:270]) {
        rotate([0,0,i]) translate([0,h-(d/2*0.1),h-r-threaded_insert_d]) threadedInsert();
    }
}

module threadedInsert() {
    cylinder(h=threaded_insert_d, d=threaded_insert_w);
}

module boltHeadCutout(hex_corner_width) {
    linear_extrude(h) circle(bolt_corner_width/2*1.1, $fn=6);
}

module body() {
    rotate_extrude() rotate([0,0,90]) bodyCrossSection();
}

module bodyCrossSection() {
    union() {
        translate([h-r,d/2-r,0]) pie_slice(r, a=90);
        translate([r,d/2-r,0]) rotate([0,0,90]) pie_slice(r, a=90);


        polygon(points=[
            [0,bolt_d*1.2],
            [0,d/2-r],
            [r,d/2-r],
            [r,d/2],
            [h-r,d/2],
            [h-r,d/2-r],
            [h-r,d/2*0.6],
            [h-(d/2*0.4),d/2-r],
            [r,d/2-r],
            [r,bolt_corner_width/2*1.1+1.4],
            [riser_height,bolt_corner_width/2*1.1+1.4],
            [riser_height,bolt_d*0.6],
            [0,bolt_d*0.6]
        ]);
    }
}

module pie_slice(r=3.0, a=30) {
  polygon(points=[
    [0, 0],
    for(theta=0; theta<a; theta=theta+$fa)
      [r*cos(theta), r*sin(theta)],
    [r*cos(a), r*sin(a)]
  ]);
}
