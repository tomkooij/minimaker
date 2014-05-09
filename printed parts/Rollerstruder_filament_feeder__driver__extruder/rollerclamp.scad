include <polyScrewThread.scad>

//
// TODO:
// - ditch the thread and use a flat cap screwed to the base with 3x m3 screws
// - fragilize the cone (eg. with a hollow backbone facing the gaps)

//
// Print with 
// - 0.2 mm layer & bottom/top thickness
// - 1.6 m walls
// - 100% infill
// Nb: I have a 0.4 mm nozzle


$fn=50;

PI=3.141592;
tol=0.1;

// Filament and bowden tube
bowdenplug_bowden_diam= 6.15;
bowdenplug_bowden_inner_diam= 4;
bowdenplug_filament_tube= bowdenplug_bowden_diam + 0.1; // letting the bowden tube through all the parts is better in fact!

// Main sizes
bowdenplug_diameter= 20;			// outer diameter of the thread
bowdenplug_body_height=25;			// how tall is the threaded part (in the nut)
bowdenplug_body_unused_thread_height= 4; // the male part of the thread is shortnened by this amount to make the assembly sexier

// Screw nut
bowdenplug_nut_diam= bowdenplug_diameter+14;	// distance between nut flats
bowdenplug_nut_grip_size=3; // how big are the nut ears
bowdenplug_nut_cap_height=4; // top thickness that holds the cone

// Outside/plug sizes (the important values for the holder)
bowdenplug_base_diameter= bowdenplug_diameter - 3;
bowdenplug_base_height= 6;									// identical heights of the square clamp and the base cylinder
bowdenplug_base_width= bowdenplug_base_diameter + 3;	// horizontal size of the square base

// Cone sizes
bowdenplug_cone_int_d= bowdenplug_bowden_diam + 0.2;
bowdenplug_cone_ext_d_min= bowdenplug_cone_int_d + 2.5;
bowdenplug_cone_ext_d_max= bowdenplug_cone_ext_d_min + 1.8;
bowdenplug_cone_friction_d= 0.15; // how tight is the cone into the body (ie. offset on diameter)

// Thread guts
bowdenplug_body_thread_steph= 4;
bowdenplug_body_thread_degrees= 55;

bowdenplug_start_base= -bowdenplug_base_height*2;

//////////////// DRAW PARTS ////////////////
//
// bowdenplug_base_carve(); // use externally to remove the plug shape from a support
// bowdenplug_body(); // includes the useful bowdenplug_base(false)
// rotate([180,0,0]) bowdenplug_cone();
// rotate([180,0,0]) bowdenplug_nut();
//
////////////////////////////////////////////

module bowdenplug_cone(positiveShape=true)
{
	if(positiveShape)
		translate([0,0,bowdenplug_body_height*2+5]) rotate([180,0,0])
			bowdenplug_inner_cone(bowdenplug_cone_int_d, bowdenplug_body_height, bowdenplug_cone_ext_d_max, bowdenplug_cone_ext_d_min);
	else // carve into the body
		translate([0,0,bowdenplug_body_height+tol]) rotate([180,0,0])
			bowdenplug_inner_cone(-1, bowdenplug_body_height+tol, bowdenplug_cone_ext_d_max-bowdenplug_cone_friction_d, bowdenplug_cone_ext_d_min-bowdenplug_cone_friction_d);
}

module bowdenplug_filament()
{
	color([1,0.8,0.8])
	{
		translate([0,0,-bowdenplug_base_height*2-10-tol])
			cylinder(r=bowdenplug_filament_tube/2, h= 100, $fn=18);
		translate([0,0,-bowdenplug_base_height])
			cylinder(r=bowdenplug_bowden_diam/2, h=100, $fn=20);
	}
}

// Screw thread
module bowdenplug_body()
{
	difference()
	{
		union()
		{
			screw_thread(bowdenplug_diameter, bowdenplug_body_thread_steph, bowdenplug_body_thread_degrees, bowdenplug_body_height-bowdenplug_body_unused_thread_height, PI/2, 2);
			translate([0,0,-bowdenplug_base_height*2])
				bowdenplug_base();
		}
		bowdenplug_cone(false);
		bowdenplug_filament();
	}
}


module bowdenplug_base()
{
	difference()
	{
		union()
		{
			translate([-bowdenplug_base_width/2,-bowdenplug_base_width/2,0])
			{
				// TODO: instead of an exact cube, we want slightly rounded corners (so it is a bit easier to insert in the feeder body)
				cube([bowdenplug_base_width, bowdenplug_base_width, bowdenplug_base_height+tol]);
			}
			translate([0,0,bowdenplug_base_height])
				cylinder(r=bowdenplug_base_diameter/2, h=bowdenplug_base_height+tol, $fn=40);
		}
		translate([0,0,-tol*2])
			cylinder(r=bowdenplug_filament_tube/2, h=bowdenplug_base_height+2*tol, $fn=20);
		translate([0,0,bowdenplug_base_height-tol])
			cylinder(r=bowdenplug_bowden_diam/2, h=bowdenplug_base_height+3*tol, $fn=20);
		// And remove lateral maintaining screw holes
		translate([-bowdenplug_base_width/2-tol,0,bowdenplug_base_height/2])
			rotate([0,90,0])
				cylinder(r=3/2, h=bowdenplug_base_width+2*tol, $fn=20);

	}
}

module bowdenplug_base_carve(tolerance=.1, screw_tolerance=1)
{
	// Cubic base
	translate([0,0,bowdenplug_base_height/2-tolerance])
	hull()
	{
		cube([bowdenplug_base_width+tolerance, bowdenplug_base_width+tolerance, bowdenplug_base_height+tol+2*tolerance], center=true);
		translate([50,0,0]) cube([bowdenplug_base_width+tolerance, bowdenplug_base_width+tolerance, bowdenplug_base_height+tol+2*tolerance], center=true);
	}

	// Cylindrical shoulder to lock
	translate([0,0,bowdenplug_base_height-tolerance])
	hull() {
		cylinder(r=bowdenplug_base_diameter/2+tolerance, h=bowdenplug_base_height+tol+2*tolerance, $fn=40);
		translate([50,0,0]) cylinder(r=bowdenplug_base_diameter/2+tolerance, h=bowdenplug_base_height+tol+2*tolerance, $fn=40);
	}

	// Screw ghost
	translate([0,0,2*bowdenplug_base_height])
	hull() {
		cylinder(r=bowdenplug_diameter/2+screw_tolerance/2, h=bowdenplug_body_height, $fn=40);
		translate([50,0,0]) cylinder(r=bowdenplug_diameter/2+screw_tolerance/2, h=bowdenplug_body_height, $fn=40);
	}
	
	// filament (b/c the function is used to carve the plug object)
	translate([0,0,-bowdenplug_base_height*2-tol])
	hull() {
		cylinder(r=bowdenplug_filament_tube/2+tolerance, h= 10+bowdenplug_base_height*2, $fn=18);
		translate([50,0,0]) cylinder(r=bowdenplug_filament_tube/2+tolerance, h= 10+bowdenplug_base_height*2, $fn=18);
	}
	translate([0,0,bowdenplug_base_height*2])
	hull()
	{
		cylinder(r=bowdenplug_bowden_diam/2+tolerance, h=bowdenplug_body_height+bowdenplug_base_height*2, $fn=20);
		translate([50,0,0]) cylinder(r=bowdenplug_bowden_diam/2+tolerance, h=bowdenplug_body_height+bowdenplug_base_height*2, $fn=20);
	}
}



// Screw nut
bowdenplug_nut_cap_height_d= sin(60)*bowdenplug_nut_diam - 4;
module bowdenplug_nut()
{
	translate([0,0,bowdenplug_body_height+5+bowdenplug_body_height+5])
	difference()
	{
			union()
			{
				// The nut body
				cylinder(h=bowdenplug_body_height + bowdenplug_nut_cap_height, r=sin(60)*bowdenplug_nut_diam/2, $fn=6, center=false);
				// Nut ears to help screwing (knurled finish is really cool but less efficient imho!)
				for(a=[0,120,240])
				{
					rotate([0,0,a]) translate([bowdenplug_nut_diam/2-bowdenplug_nut_grip_size*3/4,0,0])
					{
						translate([0,0,bowdenplug_nut_grip_size])
						{
							sphere(r=bowdenplug_nut_grip_size);
							cylinder(r=bowdenplug_nut_grip_size, h=bowdenplug_body_height+bowdenplug_nut_cap_height-2*bowdenplug_nut_grip_size);
						}
						translate([0,0,bowdenplug_body_height+bowdenplug_nut_cap_height-bowdenplug_nut_grip_size]) sphere(r=bowdenplug_nut_grip_size);
					}
				}
			}
			// Remove internal threading
			hex_countersink_ends(bowdenplug_body_thread_steph/2,bowdenplug_diameter,bowdenplug_body_thread_degrees,0.5,bowdenplug_body_height);
			intersection()
			{
				translate([0,0,-tol]) cylinder(r=bowdenplug_diameter/2+2, h=bowdenplug_body_height+2*tol);
				screw_thread(bowdenplug_diameter,bowdenplug_body_thread_steph,bowdenplug_body_thread_degrees,bowdenplug_body_height,0.5,-2);
			}
			// Remove bowden tube input hole
			bowdenplug_filament();
	}
}

module bowdenplug_inner_cone(id=6,ch=16,od1=9.2,od2=7.8,gap=2)
{
	// Cone body (based on my cone for the standard bowden clamp http://www.thingiverse.com/thing:25636)
	// Internal ripples
	rippler=0.3;	// internal ripple width (at base of cone, will be zero on top)
	rippleh=1;	// internal ripple height
	ripples=2;	// internal ripple spacing (will be added to rippleh, ie one 1-mm shoulder with 2mm in between)

	if(id<=0) // just draw the cone (useful to remove material to another part)
	{
		cylinder(r1=od1/2, r2=od2/2, h=ch);
	}
	else
	{
		difference()
		{
			cylinder(r1=od1/2, r2=od2/2, h=ch);
			translate([0,0,-tol])
			{
				cylinder(r=id/2,h=ch+2*tol);
				color([1,1,1]) translate([-gap/2,-tol,0]) cube([gap, max(od1,od2)/2+2*tol, ch+2*tol]);
			}
			for(i=[-tol:(ripples+rippleh):ch-rippleh-2*tol])
				translate([0,0,i])
					cylinder(r=id/2+rippler * (ch-i)/ch, h=rippleh);
		}
	}
}
