tol=0.1;
// Main body constants
h2h=35.0;	// hole to hole axis distance
mwd=28;	// max width of main body
thc=3;	// main thickness
dsm=7.3;	// small diameter
dsc= 3;		// screw diameter
// Space left for the bearing/rod (avoid contacts with the body as with the original item)
div= 23;	// diameter of internal bearing void
hiv= 1;		// height of internal bearing void
// Internal conic pin to prevent the rod to come in contact
tcpt= 0.2;	// tolerance of central pin (ie. rod free play)
dcpb= 5;	// diameter of central pin (base)
dcpt= 1;	// diameter of central pin (top)

$fs=0.2;
$fn=80;

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
		translate([-h2h/2,0,0]) cylinder(r=dsm/2+offset, h=height, center=true);
		translate([+h2h/2,0,0]) cylinder(r=dsm/2+offset, h=height, center=true);
		cylinder(r=mwd/2+offset, h=height, center=true);
	}
}
module rlosange(height, offset=0)
{
	hull()
	{
		translate([-h2h/2,0,0]) torus(diameter=dsm/2, roundness=height);
		translate([+h2h/2,0,0]) torus(diameter=dsm/2, roundness=height);
		torus(diameter=mwd/2, roundness=height);
	}
}

roundness=1;
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
			translate([-h2h/2,0,0]) cylinder(r=dsc/2, h=thc+2*tol);
			translate([+h2h/2,0,0]) cylinder(r=dsc/2, h=thc+2*tol);
			// Remove space for the rod/bearing (without letting the bearing lose of course)
			//color([1,0,0]) translate([0,0,thc-hiv]) cylinder(r=div/2, h=hiv+1);

			// rod hole
			translate([0,0,0]) cylinder(r1=7,r2=7,h=20);
		}

	}
	// Add central pin to keep the rod from getting too close (this will surely wear out though)
	//translate([0,0,thc-hiv-tol]) cylinder(r1=dcpb/2, r2=dcpt, h=hiv-tcpt+tol);
}
