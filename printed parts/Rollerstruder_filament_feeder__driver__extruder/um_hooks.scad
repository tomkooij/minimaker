//
// Mounting arms for the ultimaker
//

tol=0.02; // a tolerance mostly used for better openscad rendering

um_hook_total_th= 16.3; // total thickness
um_hook_wall_th= 6.5-1.4; // inidividual jaw thickness (keep some room b/c of little string overhangs)
um_hook_rounded_top_radius= 12.6; // the rounded shoulder
um_hook_jaws_space_in= 6.5 - 1.1; // top clamp thickness
um_hook_jaws_space_out= 7.7 - 1.4; // bottom clamp thickness
um_hook_jaws_height= 8; // how long are the hook downwards (in the plug)
um_hook_jaws_spacing= 28.1; // how far are the top/bottom hook pair spaced
um_hook_jaws_th_skew= 0; // make the jaws end thinner (eg. 2mm, but only useful if you disable support below)

um_hook_support_th=0.51; // support wall thickness (to be removed after print)
um_hook_support_wall_th= 0.54; // wall thickness (value such that Cura/SK does not discard it!)

module um_hook_rounded_shoulder(delta_r=0)
{
	intersection()
	{
		rotate([0,0,90]) cylinder(r=um_hook_rounded_top_radius+delta_r, h=um_hook_total_th);
		cube([(um_hook_rounded_top_radius+delta_r)*2,(um_hook_rounded_top_radius+delta_r)*2,um_hook_total_th]);
	}
}

jtol=1;
module um_hook_pair()
{
	// One pair of UM mounting arms
	difference()
	{
		union() // draw both hooks at once, we carve them afterwards
		{
			um_hook_rounded_shoulder();
			hull()
			{
				translate([um_hook_jaws_space_in,0,0])
					cube([um_hook_rounded_top_radius-um_hook_jaws_space_in,tol,um_hook_total_th]);
				translate([um_hook_jaws_space_out,-um_hook_jaws_height,0])
					cube([um_hook_rounded_top_radius-um_hook_jaws_space_out,tol,um_hook_total_th]);
			}
		}
		// Carve the space bewteen the jaws
		translate([0,-um_hook_jaws_height-jtol,um_hook_wall_th])
		{
			hull() // make it overhang-friendly (no support required)
			{
				cube([jtol,um_hook_jaws_height+um_hook_rounded_top_radius+2*jtol, um_hook_total_th - 2*um_hook_wall_th]);
				translate([um_hook_rounded_top_radius+2*jtol,0,-um_hook_jaws_th_skew/2])
					cube([jtol,um_hook_jaws_height+um_hook_rounded_top_radius+2*jtol, um_hook_total_th - 2*um_hook_wall_th + um_hook_jaws_th_skew]);
			}
		}
	}

	// Add a temporary thin "skin" on the jaws to be removed after printing (no need for structure)
#color([0.5,0.5,0.5]) if(um_hook_support_th>0) // go and repair with cloud.netfabb.com if you use need :(
	{
		translate([um_hook_jaws_space_out,-um_hook_jaws_height+tol,tol]) // external end of jaws
			cube([um_hook_rounded_top_radius-um_hook_jaws_space_out,um_hook_support_wall_th,um_hook_total_th-2*tol]);
		translate([-tol,-tol,0])
		intersection()
		{
			union()
			{
				translate([0.2,0,tol]) // internal, near wall
					cube([um_hook_rounded_top_radius-um_hook_jaws_space_in,um_hook_support_wall_th,um_hook_total_th-2*tol]);

				translate([0,0,0]) difference()
				{
						um_hook_rounded_shoulder(0);
						translate([-tol,-tol,-tol]) um_hook_rounded_shoulder(-um_hook_support_th);
				}
			}
			translate([0.2,0,0])
			cube([um_hook_rounded_top_radius*2,um_hook_rounded_top_radius*2,um_hook_total_th-2*tol]);
		}
	}
}

reinforcement_wall_th=1.6;
module um_diag_walls(dir)
{
	hull()
	{
		translate([wall_th,(dir<0?reinforcement_wall_th:0),-um_hook_total_th/2])
			cylinder(r=reinforcement_wall_th, h=um_hook_total_th);
		translate([0,0,um_hook_total_th/2-tol])
			cube([wall_th,reinforcement_wall_th,tol]);
		translate([-um_hook_total_th/2,0,-um_hook_total_th/2])
			cube([wall_th+um_hook_total_th/2,reinforcement_wall_th,4+tol]);
	}
	hull()
	{
		translate([-um_hook_total_th/2,0,-um_hook_total_th/2])
			cube([wall_th+um_hook_total_th/2,reinforcement_wall_th,4+tol]);
		translate([-um_hook_total_th/2-4,-dir*2,-um_hook_total_th/2])
			cube([wall_th+um_hook_total_th/2,reinforcement_wall_th,4+tol]);
	}
}

module um_hooks(wall_th, height)
{
	translate([0,0,um_hook_total_th/2])
	{
		difference()
		{
			union()
			{
				// Main wall
				cube([wall_th, um_hook_jaws_spacing + 2*um_hook_jaws_height, um_hook_total_th], center=true);
				// Angled reinforcements
				translate([-wall_th/2,(um_hook_jaws_spacing + 2*um_hook_jaws_height)/2,0])
					um_diag_walls(1);
				translate([-wall_th/2,-(um_hook_jaws_spacing + 2*um_hook_jaws_height)/2-reinforcement_wall_th,0])
					um_diag_walls(-1);
			}
			// Add three m3 holes (makes a more robust part, and allows fixing extra stuff...)
			cylinder(r=3/2, h=um_hook_total_th+2*tol, center=true);
			translate([0,-um_hook_jaws_spacing/2,0]) cylinder(r=3/2, h=um_hook_total_th+2*tol, center=true);
			translate([0,+um_hook_jaws_spacing/2,0]) cylinder(r=3/2, h=um_hook_total_th+2*tol, center=true);
		}
	}

	// Rounded reinforcement towards the motor plate and feeder tower
	//translate([0,height/2,0]) { sphere(r=3); rotate([0,-90,0]) cylinder(r=3,h=width+10); }
	translate([wall_th/2,height/2-um_hook_rounded_top_radius,0])
	{
		um_hook_pair();
		translate([0,-um_hook_jaws_spacing,0])
			um_hook_pair();
	}
}
