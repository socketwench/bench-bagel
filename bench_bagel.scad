Select = 0; // [0:Preview, 1:Body, 2:Riser, 3:Lid]

r=3;
h=30;
d=70;
bolt_d=5.6;
bolt_corner_w=11.05;
bolt_head_h=6;
riser_height=12.4;
Threaded_insert_w=4.8;
Threaded_insert_d=5;
Threaded_insert_bold_d=3.8;

/* [Advanced] */
$fn = 100;

if (Select==0) {
    part_body();
    part_riser();
    part_lid();
} else if (Select==1) {
    part_body();
} else if (Select==2) {
    part_riser();
} else if (Select==3) {
    part_lid();
}

module part_lid() {
    difference() {
        translate([0,0,h-r]) union() {
            cylinder(h=r, d=d-(r*2)-0.6);
            
            translate([0,0,-1]) union() {
                difference() {
                    cylinder(h=1, r=d/2*0.6-0.4);
                    cylinder(h=1, r=bolt_corner_w/2*1.1+2);
                }         
            }
        }
        translate([0,0,h-r]) lidBoltHolePattern();                           
        cylinder(d=bolt_d+0.8, h=h);
    }
}

module lidBoltHolePattern() {
    for(i=[0:90:270]) {
        rotate([0,0,i]) translate([0,h-(d/2*0.1),0]) union() {
            cylinder(d=Threaded_insert_bold_d,h=r);
            translate([0,0,r/2-0.2]) {
                cylinder(r1=Threaded_insert_bold_d/2,r2=Threaded_insert_bold_d,h=r/2+0.2);
            }
        }
    }
}

module part_riser() {
    difference() {
        riserBody();
        
        cylinder(d=bolt_d+0.8, h=h);
        
        translate([0,0,h-r-bolt_head_h]) {
            linear_extrude(bolt_head_h) circle(bolt_corner_w/2*1.1, $fn=6);
            
            translate([0,0,bolt_head_h*-1]) {
                cylinder(h=bolt_head_h, r1=bolt_d/2, r2=bolt_corner_w/2*1.1, $fn=6);
            }
        }
    }
    
}

module riserBody() {
    union() {
        translate([0,0,riser_height]) cylinder(r=bolt_corner_w/2*1.1+1.4, h=h-r-riser_height);
        
        hex_section_h = riser_height-r-bolt_head_h;
        
        translate([0,0,riser_height-hex_section_h]) linear_extrude(hex_section_h) circle(bolt_corner_w/2*1.05, $fn=6);
    }
}

module part_body() {
    difference() {

        union() {
            body();
            topBoltHoleSupports();
        }

        translate([0, 0, r]) boltHeadCutout();
        
        topBoltHolePattern();
    }
}

module topBoltHoleSupports() {
    support_d = Threaded_insert_w * 1.6;
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
        rotate([0,0,i]) translate([0,h-(d/2*0.1),h-r-Threaded_insert_d]) threadedInsert();
    }
}

module threadedInsert() {
    cylinder(h=Threaded_insert_d, d=Threaded_insert_w);
}

module boltHeadCutout(hex_corner_width) {
    linear_extrude(h) circle(bolt_corner_w/2*1.1, $fn=6);
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
            [r,bolt_corner_w/2*1.1+1.4],
            [riser_height,bolt_corner_w/2*1.1+1.4],
            [riser_height,bolt_d/2+0.4],
            [0,bolt_d/2+0.4]
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
