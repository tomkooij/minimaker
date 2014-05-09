
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

base_tol=0.15;

fitting_d= 0*(9.5 - 0.5); // zero to use a blind rivet nut, else specify your push-fit d
fitting_h= 6;

m3_head_d= 5.5;
m3_head_h= 1.6; 
m3_d_tight= 3 - 0.15;

// Filament and bowden tube
bowdenplug_bowden_diam= 6.15;
bowdenplug_bowden_inner_diam= 4;
bowdenplug_filament_tube= bowdenplug_bowden_diam + 0.1; // letting the bowden tube through all the parts is better in fact!

// Main sizes
bowdenplug_diameter= 20;			// outer diameter of the thread
bowdenplug_body_unused_thread_height= 4; // the male part of the thread is shortnened by this amount to make the assembly sexier

// Outside/plug sizes (the important values for the holder)
bowdenplug_base_diameter= bowdenplug_diameter - 3;
bowdenplug_base_height= 6;									// identical heights of the square clamp and the base cylinder
bowdenplug_base_width= bowdenplug_base_diameter + 3;	// horizontal size of the square base

bowdenplug_start_base= -bowdenplug_base_height*2;

//////////////// DRAW PARTS ////////////////
//
bowdenplug_body(); // includes the useful bowdenplug_base(false)
//
////////////////////////////////////////////

br_toth= 16.4;
br_main_d= 8.8+0.2;
br_should_d= 12;
br_should_th= 1.6;
br_lower_id= 7.4;
br_lower_ih= 7.4;
br_top_id= 4.9;

br_m3holder_off= br_should_d/2 + 3/2;

module blind_rivet()
{
	difference()
	{
		union()
		{
			cylinder(r=br_should_d/2, h=br_should_th);
			cylinder(r=br_main_d/2, h=br_toth);
		}
		/*translate([0,0,-tol])
		{
			cylinder(r=br_lower_id/2, h=br_lower_ih+tol);
			cylinder(r=br_top_id/2, h=br_toth+2*tol);
		}*/
	}
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
		translate([0,0,-bowdenplug_base_height*2])
			bowdenplug_base();
		bowdenplug_filament();
	}
}

module hull_extrude()
{
  hull()
  {
    child(0);
    translate([0,-bowdenplug_base_width,0]) child(0);
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
				translate([+base_tol/2,+base_tol/2,0])
				cube([bowdenplug_base_width-base_tol, bowdenplug_base_width-base_tol, bowdenplug_base_height-base_tol]);
			}
// translate([0,0,bowdenplug_base_height]) cylinder(r=bowdenplug_base_diameter/2, h=bowdenplug_base_height+tol, $fn=40);
			if(fitting_d>0)
				translate([0,0,bowdenplug_base_height-tol]) cylinder(r=bowdenplug_base_diameter/2, h=fitting_h, $fn=40);
			else
				translate([0,0,bowdenplug_base_height-tol]) cylinder(r=bowdenplug_base_diameter/2, h=2*br_should_th, $fn=40);
		}
		translate([0,0,-tol*2])
			cylinder(r=bowdenplug_filament_tube/2, h=bowdenplug_base_height+2*tol, $fn=20);
		translate([0,0,bowdenplug_base_height-tol])
			cylinder(r=bowdenplug_bowden_diam/2, h=bowdenplug_base_height+3*tol, $fn=20);

		// And remove lateral maintaining screw holes
		translate([-bowdenplug_base_width/2-tol,0,bowdenplug_base_height/2])
			rotate([0,90,0])
				cylinder(r=3/2, h=1, $fn=20);

	      translate([0,0,bowdenplug_base_height-br_should_th/2])
	      {
					if(fitting_d>0)
						cylinder(r=fitting_d/2,h=br_should_th+10);
					else
					{
						scale([1.02,1.02,1])
						{
							hull_extrude()
							{
								union()
								{
									cylinder(r=br_should_d/2+tol,h=br_should_th+0.1);
									translate([0,0,br_should_th+0.1-tol]) 					
							cylinder(r1=br_should_d/2+tol,r2=br_should_d/2-0.8,h=0.8);
								}
							}
							hull_extrude()
							{
								cylinder(r=br_should_d/2-0.8,h=br_toth+0.2);
							}
						}
						%blind_rivet();
						translate([0, -(br_should_d/2+3/2+0.1), br_should_th])
							#m3_screw();
					}
	      }
	}
}

screw_h= 8;
module m3_screw()
{
  cylinder(r=m3_head_d/2+0.3,h=m3_head_h);
  translate([0,0,-screw_h]) cylinder(r=m3_d_tight/2,h=screw_h+tol);
}