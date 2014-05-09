tol=0.1;

m3_d= 3;
m3_d_tol=0.15;
m3_d_tight= 2.9; // screwable diameter when no bolts are used (eg. hinge axis)
m3_nut_d= 6 + 0.3; // for hex nuts
m3_nut_h=2.0+0.1;

// Main body constants
back_th= 2; // thickness that holds the central nut
// Space left for the bearing/rod (avoid contacts with the body as with the original item)
hiv= 1.5;		// height of internal bearing void
roundness=3;

thc= m3_nut_h + hiv + back_th;	// main thickness
div= 23;	// diameter of internal bearing void
dsm=8.1;	// small outer diameters
mwd= div + 6.1;	// big diameter

$fs=0.1;
h2h=35;	// hole to hole axis distance

RodBlindEnd();

module torus(diameter,roundness)
{
	translate([0,0,roundness/2])
		rotate_extrude(convexity= 10)
			translate([diameter-roundness/2, 0, 0])
				circle(r= roundness/2);
}
module losange(height, offset=0)
{
	translate([0,0,height/2])
	hull()
	{
		for(side=[-1:2:+1])
			translate([h2h/2*side,0,0]) cylinder(r=dsm/2+offset, h=height, center=true);
		cylinder(r=mwd/2+offset, h=height, center=true);
	}
}
module rlosange(height)
{
	hull()
	{
		for(side=[-1:2:+1])
			translate([h2h/2*side,0,0]) torus(diameter=dsm/2, roundness=height);
		torus(diameter=mwd/2, roundness=height);
	}
}

module RodBlindEnd()
{
	difference()
	{
		// Do the main rounded losange body
		union()
		{
			translate([0,0,roundness/2]) losange(thc-roundness/2);
			rlosange(roundness);
		}
		
		// Remove screw holes
		translate([0,0,-tol])
		{
			for(side=[-1:2:+1])
				translate([h2h/2*side,0,0])
					cylinder(r=m3_d/2+m3_d_tol, h=thc+2*tol);
			cylinder(r=m3_d/2, h=thc+2*tol); // central hole
		}

		// Remove space for the rod/bearing (without letting the bearing too loose of course)
		color([1,0,0]) translate([0,0,thc-hiv]) cylinder(r=div/2, h=hiv+1);

		// Add central hole
		translate([0,0,thc-hiv-m3_nut_h+tol])
		cylinder(r=m3_nut_d/2, h=m3_nut_h, $fn=6);
	}
}
