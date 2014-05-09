include <rollerclamp.scad>
include <um_hooks.scad>


$fn=0;
$fa=1;
$fs=0.5;

tol=0.02;

//
// TODO:
//
// - add more thru-holes to allow a near empty fill (esp. in the tower)?
//

// HISTORY:
//
// v5.3b
// - restored body height (I'm dumb, that's the third time!)
//
// v5.3
// - reduced body height by 2mm (error!)
// - dropped all references and sizes of the non-existing MK6 bolt
// - better/safer carving of the main bearing (done at the end)
// - reinforced internal bowden support near the hobbed bolt
// - reinforced a bit the hinge
// - removed more material in the bowden plug base
//
// v5.2b
// - using slightly smaller m3_head_d and m3_head_h for the head of the hinge bolt/axis
// - angled idler axis centered
// - added diagonal reinforcement for the UM jaws
// - filled gap bewteen main bearing rings and tower (faster print / less robust?)
// - thicker wall for the filament holder bolt head
// - cura settings: 0.38mm nozzle, 0.2mm layer th, 1.2 wall th, 2mm bottom/top, skin option, loops/infill/perimeters
// - added a cup-like bowden support near the hobbed bolt & idler bearing

// v5.1
// - re-increased wall to 4mm
// - wider range for sliding motor adjustment
// - added um jaws reinforcement towards main plate
// - gutter a bit higher

// v5
// - re-fixed UM jaws support for cura (damn!)
// - slightly bigger um jaws
// - added a lateral screw in the motor mount to push/maintain the motor against the big wheel
// - rounded outer tower corner (cosmetic)
// - bearing column bevel (cosmetic)
// 

// v4bis
// - Reduce overhang no the protruding spring arms (b/c the ~10 first sliced layers are all in the same direction in cura with a 1-pass outer skin!)
// - Put bowden tubes as thermal insulators so that the plate does not bend
// - Give more room between plate & motor to screw regular 20mm m3 screw

// v4
// - Re-re-fix the UM jaws support structures :'(
// - stepper mount holes: make slots for the heat isolators made of bowden tub sections?
// - reduce motor mount hole reinforcement height
// - Fix pos of general usage screw (pseudo filament holder)

// v3
// - more interleaved arms for the hinge!
// - bigger slices on the spring hole pieces to be removed
// - fix AGAIN the UM jaws!
// - more freeplay for the 3 nuts (esp. in the tower)
// - add a bit more vertical space for the hinge?
// - (may be) find/add a thing to autoclean the hobbed bolt (to remove clogged plastic)
// - make the main bearing overhang slightly conic (ie. printer-friendly)
// - filament guide diameter 0.5 bigger
// - same for the plug removal vertical screw
//
// v2
// - added a nut for securing the bowden clamp with the lateral screw
// - switch from m3 to m4 for the spring bolt (as it needs to be >= 50mm!)
// - less tolerance on the bowden plug receptor
// - re-attach the plug tower
// - move the bearing clearance on the idler a bit further to the outside
// - small hole in the clamp support strutures to make it more detachable
// - fix the protruding hinge bolt without washers on the big wheel -- use filament? :s
// - restore um jaws support wall ==>  check STL !!
// - fix the idler bearing axis void on the hinge?
// - reduce tower base size (hull) / or carve it
// - fix the logo depth again (no protruding)
// - fill the bottom of the idler bearing m8 hole?
// - laterally move the motor plate and jaws upwards (would free the spring bolt along the motor btw)
//


print_layer_w= 0.8+tol; // slightly more than the nozzle width (print parameter) -- Cura just ignores too thin walls! :(
print_layer_th= 0.2; // the sliced layer height (print parameter)
wall_th= 4; 	// generic wall diameter (4.0 is good & enough)
hair_tube_d= print_layer_th/2 - tol; // to reinforce internal structures (makes a hollow print possible)

debug_what="all"; // all/big/nema/hobbedbolt/none

body_height= 22; // total height of the main body (5c was 20, too short)
axis_to_axis= 38; // distance between the motor and hobbed bolt axes


m3_d= 3;
m3_d_tight= 2.9; // screwable diameter when no bolts are used (eg. hinge axis)
m3_nut_d= 6; // for hex nuts
m3_head_h= 1.6;
m3_head_d= 5.5;
m3_nut_h= 2.0;
m3_nylock_h= 3.8;
m3_nut_tol= 0.4;

m4_d= 4;
m4_d_tight= 3.7; // screwable diameter when no bolts are used
m4_nut_d= 8;
m4_nut_tol= 0.15;
m4_nut_h= 3.15;

m6_d= 5.7; // wtf? why not 6?
m6_nut_d= 11.5;
m6_nut_h= 4; // standalone nuts are 4.7mm!

m8_d= 8;
m8_d_tight= 7.78; // for the bolt holding the idler bearing (needs a tight fit)
m8_nut_d= 14.6;
m8_nut_h= 5.5;
m8_nut_d_freeplay=0.15; // for embossing an m8 nut

brg_608_th=7;
brg_608_outer_d=22;
brg_608_inner_d=8;
brg_608_shoulder= 1; // shoulder for the hobbed bolt bearings

spring_bolt_d= m6_d * 1.10; // 10% bigger
spring_bolt_head_d= m6_nut_d + 0.5; // was 12.65 ipo 11.5 (ie. +1.15)
spring_bolt_head_h= m6_nut_h;
spring_hole_shoulder_diam= spring_bolt_head_d + 2; // fix according to nut size
spring_hole_friendly= 2; // conicity of the spring holes body
springArmAddSupport= false;
arm_vbolt_hole_pos=[1,7,0];
arm_vbolt_body_shift=1;
arm_vbolt_outer_d= 1.4;

motor_lateral_shift= 8;
motor_support_length= 46;
motor_support_width= 44;
motor_support_wall_th= 5; // base plate and hook wall thickness (was 6)
motor_umhook_wall_th= 7; // base plate and hook wall thickness (was 6)
motor_mount_freeplay= 3; // longitudinal freeplay (to tune the distance between the 2 cogwheels)

motor_bowden_gutter_height= 3.5; // how tall are the gutters
motor_bowden_gutter_height= 6;
motor_bowden_gutter_extralen=[39-axis_to_axis+5, 39-axis_to_axis+1];
motor_mount_latscrew_posy= 1;
motor_mount_latscrew_rotate=25+4;
motor_mount_latscrew_shift=18;

// The idler arm
idler_th= 2.3; // idler wall thickness (esp. around axes)
idler_inner_diam= 8;
idler_length_to_spring= 21+3; // length of the idler arm (spring side)
idler_brg_gap= 0.6;
idler_hinge_d= 10;
idler_bolt_thread_height= 30+tol;
idler_bearing_axis_angle= 1.5; // inside angle, to make the idler bearing push the filament slightly inwards (was 2)

logoth=-0.4; // logo emboss offset (fuzzy...)

brg_spacing= body_height - 2*brg_608_th;

arm_hinge_count= 6;
arm_hinge_height= body_height/arm_hinge_count;

filament_diam=3;
big_wheel_th= 6.1;
big_wheel_nut= m8_nut_d;
big_wheel_diam=70;
small_wheel_diam=14;
wheel_overlap= 2.2;

// Debug constants
hobbedbolt_diam= 13; // 14.5;
hobbedbolt_height= 7.8;
hobbedbolt_groovepos=3.5; // from internal side
hobbedbolt_groove_tore= 11.6;
hobbedbolt_groove_depth= 1; // groove depth (more specifically: how much the filament is pushed within the hobbed bolt)
filament_x= -hobbedbolt_diam/2 + hobbedbolt_groove_depth/2 - filament_diam/2; // for hobbedbolt
filament_z= body_height + hobbedbolt_groovepos + 0.25; // slight gap between the hobbed bolt head and bearing?
filament_pos= [filament_x, 0, filament_z];

idler_closest_dist= -hobbedbolt_diam/2 - brg_608_outer_d/2 -(1.1/2)*0.5; // closest position of the idler bearing axis to the hobbedbolt bolt (computed for a 1.1mm filament, though the design expects 3mm filament in the first place)

// Idler dimensions
hinge_offset= [-2.0,-1,0]; // to tune the hinge axis a bit (will push the plug tower accordingly)
hinge_axis_pos= hinge_offset + [idler_closest_dist+idler_inner_diam-idler_th, brg_608_outer_d/2, 0]; // the hinge side (right side)
idler_hinge_d_gap= 1.1; // rotational room around the body and idler around the hinge axis
idler_arm_end_pos= [idler_closest_dist+idler_inner_diam-idler_th-2, -idler_length_to_spring, 0]; // the spring side (left side)

// Manully tuned body hinge reinforcement towards the tower & embedding the bearing
hinge_body_direction= [19,7-3.2,0]; // tune the hinge axis position (take care of the bottom bearing!)
hinge_out_direction= [-3,10,0];

end_of_body_near_idler= idler_closest_dist+brg_608_outer_d/2;
end_of_body_near_spring= idler_arm_end_pos[1] - idler_th;

spring_head_pos_y= idler_arm_end_pos[1] + spring_bolt_d/2;
spring_head_pos_z= body_height - spring_hole_shoulder_diam/2 - spring_hole_friendly;
spring_head_th= idler_inner_diam; // spring head thickness
spring_head_hfreeplay= 3;
spring_head_hfreeplay_offset=0.4; // 0.5 to center the freeplay on the idler arm

nema_screw_diam = m3_d;
nema_screw_distance_to_axis = 43/2; // distance from axis (43mm from one screw to the opposite, for a NEMA 17)
nema_collar_diam= 23;
nema_additional_space_for_mount= 4+motor_mount_freeplay;
nema_screw_offset= cos(45) * nema_screw_distance_to_axis;

feeder_roundness= 2.4;
feeder_holder_size_x= bowdenplug_base_width + 2*wall_th;
feeder_holder_size_z= filament_z;
feeder_holder_pos_z= feeder_holder_size_z - bowdenplug_base_height - 1.5*wall_th;
feeder_plug_expell_y= 3; // wall thickness near the bolt (only useful for retractation)
feeder_holder_size_y= 2*bowdenplug_base_height-1 + feeder_plug_expell_y;
feeder_holder_start_y= hinge_axis_pos[1] + idler_hinge_d/2 + idler_hinge_d_gap;

bowden_clamp_tower_origin= [filament_x - feeder_holder_size_x/2, feeder_holder_start_y, 0];

idle_spring_groove_d= 9;

idler_display_rotation=13; // view angle - mostly for debugging, where 13 reduces retraction when printing - range is [-40,13]
idler_th_reinforcement=1; // added thickness on the idler half towards the hinge
idler_freeplay_to_main_bearings=1.2; // so that the hobbed bolt bearings may "enter" the idler arm when it can get closer
idler_freeplay_to_main_bearings_offset=[-0.5,-2,0]; // fine tune according to how the idler may get closer to the hobbed bolt

//=============================================
// Modules
//=============================================

module cylinder_oblong(radius, height, freeplay)
{
	hull()
	{
		translate([-(freeplay)/2,0,0]) cylinder(r=radius,h=height, center=true);
		translate([+(freeplay)/2,0,0]) cylinder(r=radius,h=height, center=true);
	}
}

module cylinder_rounded(r, h)
{
	translate([0,0,r])
	{
		sphere(r=r);
		cylinder(r=r, h=h-2*r);
	}
	translate([0,0,h-r]) sphere(r=r);
}

module cylinder_for_overhang(r, h, dh)
{
	cylinder(r=r, h=h-dh);
	translate([0,0,h-dh-tol])
		cylinder(r1=r, r2=0, h=dh+tol);
}

module bolt_hole(thread_d, nut_d, nut_h, nut_conic_h, nut_conic_end_d=0, total_h, nut_fn= 40)
{
	if(thread_d>0 && total_h>0) cylinder(r=thread_d/2, h=total_h);
	hull() // head slot
	{
		if(nut_d>0 && nut_h>0) cylinder(r=nut_d/2, h=nut_h, $fn=nut_fn);
		if(nut_conic_h>0)
			if(nut_conic_end_d<=0)
				translate([0,0,nut_h]) cylinder(r1=nut_d/2, r2=thread_d/2, h=nut_conic_h, $fn=nut_fn);
			else
				translate([0,0,nut_h]) cylinder(r1=nut_d/2, r2=nut_conic_end_d/2, h=nut_conic_h, $fn=nut_fn);
	}
}

module cylinder_hollow_rounded(diam_int, diam_ext, length)
{
	translate([0,0,(diam_ext-diam_int)/4])
		rotate_extrude()
			translate([(diam_ext+diam_int)/4, 0, 0])
				circle(r = (diam_ext-diam_int)/4, $fn = 40);
	translate([0,0,(diam_ext-diam_int)/4])
		difference()
		{
			cylinder(r=diam_ext/2, h=length-(diam_ext-diam_int)/2);
			translate([0,0,-tol]) cylinder(r=diam_int/2, h=length-(diam_ext-diam_int)/2+2*tol);
		}
	translate([0,0,length-(diam_ext-diam_int)/4])
		rotate_extrude()
				translate([(diam_ext+diam_int)/4, 0, 0])
					circle(r = (diam_ext-diam_int)/4, $fn = 40);
}



module nema_support(width, height, thickness) 
{
	difference()
	{
		union()
		{
			// main motor mount plate that we build upon
			cube([width+nema_additional_space_for_mount, height, thickness], center=true);
			// Add the bowden gutters (thermal insulators)
			motor_mount_bowden_gutter("add",width+nema_additional_space_for_mount, height, thickness);
			// Support for the motor slide screw (lateral screw)
			motor_mount_latscrew("add", width,height,thickness);
		}
		// Carve all mounting holes
		motor_mount_holes(width, height, thickness, nema_screw_diam);
		
		// Carve most of the motor plate (collar space)
		hull()
		{
			cylinder_oblong(radius=nema_collar_diam/2, height=thickness+2*tol, freeplay=motor_mount_freeplay);
			// Remove some material (faster print and more cooling?)
			translate([0,0,-thickness/2-tol])
			{
				for(r=[0:180:181])
					rotate([0,0,r])
					{
						hull()
						{
							translate([nema_collar_diam/2+7,7,0]) cylinder(r=2,h=thickness+2*tol);
							translate([nema_collar_diam/2+10,-7,0]) cylinder(r=2,h=thickness+2*tol);
						}
					}
			}
		}
	}
}

module motor_mount_bowden_gutter(operation, width, height, thickness)
{
	if(operation=="add")
	{
		for(a=[0:1:1.1])
		rotate([0,0,a*180]) scale([2*(a-0.5),1,1])
			difference()
				translate([-width/2,nema_screw_offset-motor_bowden_gutter_height/2,thickness/2-tol])
					cube([width+motor_bowden_gutter_extralen[a],motor_bowden_gutter_height,motor_bowden_gutter_height-1]);
	}
	else // "carve"
	{
		// And carve the bowden gutters
		for(a=[0:1:1.1])
		rotate([0,0,a*180]) scale([2*(a-0.5),1,1])
				translate([0,nema_screw_offset,thickness+motor_bowden_gutter_height])
					rotate([0,90,0])
						cylinder(r=8/2, h=width+motor_bowden_gutter_extralen[a], center=true);
	}
}

module motor_mount_holes(width, height, thickness, screw_d)
{
	translate([0,0,-thickness/2-tol])
	for(a=[0:90:359])
		rotate([0,0,a]) translate([nema_screw_offset,nema_screw_offset,0])
	{
		hull()
		{
			translate([-cos(a)*motor_mount_freeplay/2,+sin(a)*motor_mount_freeplay/2,0])
			cylinder(r=screw_d/2, h= thickness+10+2*tol);
			translate([cos(a)*motor_mount_freeplay/2,-sin(a)*motor_mount_freeplay/2,0])
			cylinder(r=screw_d/2, h= thickness+10+2*tol);
		}
		hull() // motor mount screw oblong holes
		{
			translate([-cos(a)*motor_mount_freeplay/2,+sin(a)*motor_mount_freeplay/2,0])
			bolt_hole(
				thread_d= screw_d,
				nut_d= m3_nut_d+0.1,
				nut_h= m3_nut_h,
				nut_conic_h= 0.8,
				total_h= 0/*thickness+10+2*tol*/);
			translate([cos(a)*motor_mount_freeplay/2,-sin(a)*motor_mount_freeplay/2,0])
			bolt_hole(
				thread_d= screw_d,
				nut_d= m3_nut_d+0.1,
				nut_h= m3_nut_h,
				nut_conic_h= 0.8,
				total_h= 0/*thickness+10+2*tol*/);
		}
	}

	motor_mount_latscrew("carve", width,height,thickness);

	// And carve the bowden gutters
	motor_mount_bowden_gutter("carve", width, height, thickness);
}


module motor_mount_latscrew(operation, width,height,thickness)
{
	if(operation=="add")
	{
		for(i=[0:180:359]) rotate([0,0,i])
			translate([-nema_screw_offset,nema_screw_offset,motor_mount_latscrew_posy])
			{
				intersection() {
					union()
					{
						hull()
						{
							rotate([0,-90,motor_mount_latscrew_rotate])
								translate([0,0,-motor_mount_latscrew_shift+3])
								{
									// max r is thickness/2+motor_mount_latscrew_posy
									cylinder(r=thickness/2+motor_mount_latscrew_posy, h=motor_mount_latscrew_shift-10+m3_nut_h);
									translate([0,0,motor_mount_latscrew_shift-10+m3_nut_h])
										cylinder(r1=m3_nut_d/2,r2=m3_d, h=2);
								}
							translate([6,2.8,-1])
								scale([1.1,0.9,0.8])
									sphere(r=6.2);
						}
					}
					translate([-50,3,-thickness/2-motor_mount_latscrew_posy]) cube([100,10,thickness*3]);
				}
			}

	}
	else // if(operation=="carve")
	{
		// Now, add a 45° screw + nut to push/lock the motor against the big wheel
		for(i=[0:180:359])
			rotate([0,0,i])
				translate([-nema_screw_offset,nema_screw_offset,motor_mount_latscrew_posy])
					rotate([0,-90,motor_mount_latscrew_rotate])
		{
			translate([0,0,-motor_mount_latscrew_shift]) cylinder(r=m3_d_tight/2, h=motor_mount_latscrew_shift+1); // screw axis
			translate([-5,0,-motor_mount_latscrew_shift-20+1]) hull() // carve the motor mount body for the head
			{
				cylinder(r=m3_nut_d/2+m3_nut_tol, h=20+m3_nut_h);
				translate([10,0,0]) cylinder(r=m3_nut_d/2+m3_nut_tol, h=20+m3_nut_h);
			}

			translate([0,0,-8]) // screw nut
				hull()
				{
					cylinder(r=m3_nut_d/2+m3_nut_tol, h=m3_nut_h+m3_nut_tol+0.1, $fn=6);
					translate([-10,0,0]) cylinder(r=m3_nut_d/2+m3_nut_tol, h=m3_nut_h+m3_nut_tol+0.1, $fn=6);
				}
		}
	}
}



module debug_nema17()
{
	%union()
	{
		translate([0,0,32.7/2]) cube([42,42,32.7], center=true);
		cylinder(r=3, h=59);
	}
}

module debug_hobbedbolt_with_filament(vertical_offset= -2*tol)
{
	// Show the MK6 bolt and filament
	%union()
	{
		translate([0,0,filament_z - hobbedbolt_groovepos])
			difference()
			{
				cylinder(r=hobbedbolt_diam/2, h=hobbedbolt_height); // bolt
				translate([0, 0, hobbedbolt_groovepos])
					rotate_extrude(convexity = 2)
						translate([hobbedbolt_groove_tore/2+hobbedbolt_groove_depth, 0, 0])
							scale([1,0.5,1]) circle(r = hobbedbolt_groove_depth, $fn = 60);
			}
		// The filament
		translate([filament_x,-50,  filament_z])
		rotate([-90,0,0])
			cylinder(r=filament_diam/2, h=100, $fn=20); // bolt
	}
}

module debug_bearing_608()
{
	%difference()
	{
		cylinder(r= brg_608_outer_d/2, h=brg_608_th);
		translate([0,0,-tol]) cylinder(r= brg_608_inner_d/2, h=brg_608_th + 2*tol);
		translate([0,0,-tol]) cylinder(r= 17.5/2, h=0.66);
		translate([0,0,brg_608_th-0.66+tol]) cylinder(r= 17.5/2, h=0.66);
	}
}

module debug_big_wheel()
{
	%union()
	{
		difference()
		{
			cylinder(r=big_wheel_diam/2, h=big_wheel_th);
			translate([0,0,-tol]) cylinder(r=big_wheel_nut/2, h=big_wheel_th+2*tol, $fn=6);
		}
		// And small wheel
		translate([ (big_wheel_diam+small_wheel_diam)/2 - wheel_overlap,motor_lateral_shift,-tol])
			cylinder(r=small_wheel_diam/2, h=big_wheel_th+2*tol);
	}
}

module debug_m8_bolt(h_thread) // points upside
{
	%union()
	{
		cylinder(r=m8_nut_d/2, h=m8_nut_h, $fn=6);
		cylinder(r=8/2-0.2, m8_nut_h+h_thread, $fn=20);
	}
}

// Show (non printable) crosshairs at current position
module dbg()
{
	%color([0,0,0]) %union()
	{
		translate([0,0,-100]) cylinder(r=0.25, h=200, $fn=80);
		rotate([90,0,0]) translate([0,0,-100]) cylinder(r=0.25, h=200, $fn=80);
		rotate([0,90,0]) translate([0,0,-100]) cylinder(r=0.25, h=200, $fn=80);
	}
}

module debug_idler_bearing()
{
	%translate([idler_closest_dist,0,body_height+idler_brg_gap]) // the idler bearing
		translate([-sin(idler_bearing_axis_angle)*idler_bolt_thread_height/2,0,0])
				rotate([0,idler_bearing_axis_angle,0])
	{
		debug_bearing_608();
		translate([0,0,brg_608_th+m8_nut_h+0.1])
			rotate([180,0,0])
				debug_m8_bolt(idler_bolt_thread_height);
	}
}

// Show some debug ghosts
module debug_ghosts()
{
	union()
	{
		if(debug_what=="all" || debug_what=="big")
		{
			translate([0,0,-big_wheel_th-0.75]) debug_big_wheel();
			translate([0,0,-tol]) debug_bearing_608();
			translate([0,0, brg_608_th+brg_spacing]) debug_bearing_608();
		}
		
		if(debug_what=="all" || debug_what=="hobbedbolt")
			debug_hobbedbolt_with_filament();

		/*
		if(debug_what=="all" || debug_what=="plug")
		{
			translate([filament_x, feeder_holder_start_y + feeder_plug_expell_y-tol, filament_z])
				rotate([-90,-90,0])
					bowdenplug_body();
		}
		*/

		if(debug_what=="all" || debug_what=="nema")
		{
			translate([38,motor_lateral_shift,32+motor_support_wall_th+motor_bowden_gutter_height]) rotate([180,0,0])
				debug_nema17();


		}
	}
}


module body()
{
	difference()
	{
		union()
		{
			difference()
			{
				union()
				{
					// The body main part
					difference()
					{
						union()
						{
							// Main vertical body part (that holds the main bearings)
							hull()
							{
								cylinder(r=brg_608_outer_d/2+wall_th, h=body_height-2);
								translate([0,0,body_height-2])
									rotate_extrude(convexity = 10, $fn = 100)
										translate([brg_608_outer_d/2+wall_th-2, 0, 0])
											circle(r = 2, $fn = 100);
							}
							// Connect the base plate to the motor mount plate (idler opposite side)
							union()
							{
								// Link to motor baseplate
								translate([axis_to_axis-motor_support_length/2-10/2,motor_lateral_shift,motor_support_wall_th/2])
									cube(size=[8+tol*2, motor_support_width, motor_support_wall_th], center=true);
								// Connect the base plate to the motor mount plate (idler side)
								hull()
								{
									// main axis cylinder (for now, with no hole in it)
									cylinder(r=brg_608_outer_d/2+wall_th, h= motor_support_wall_th);
									// Link to motor baseplate
									translate([axis_to_axis-motor_support_length/2,motor_lateral_shift-motor_support_width/4,motor_support_wall_th/2])
										cube(size=[tol*2, motor_support_width/2, motor_support_wall_th], center=true);
								}
							}
						}
						// Finally, chop/flatten the body to leave room for the idler arm
						translate([end_of_body_near_idler-50/2,0,body_height/2]) // 100 should be enough
							cube([50, motor_support_width*2, body_height + 2*tol], center=true);
						// Carve the fn6 nut and m3 screw in the arm
						translate([end_of_body_near_idler, 0, 0])
								translate([0,spring_head_pos_y,spring_head_pos_z])
									spring_head("carve");
					}

					// Extends body for the spring fixed end and filament holder
					translate([end_of_body_near_idler, 0, 0])
						difference()
						{
							union()
							{
								hull()
								{
									translate([idler_th+idler_inner_diam/2, 0, 0])
										cylinder(r=idler_inner_diam/2+idler_th, h=body_height); // main axis
									// Spring head (bolt/body side)
									translate([0,spring_head_pos_y,spring_head_pos_z])
										spring_head("add");
								}
								translate([0,spring_head_pos_y,spring_head_pos_z])
									spring_head("support");
							}
							// Re-carve the fn6 nut and m3 screw in the arm
							translate([0,spring_head_pos_y,spring_head_pos_z])
								spring_head("carve");

							// carve the spring nut
							translate([spring_head_th-0.5,spring_head_pos_y,spring_head_pos_z])
								rotate([0,90,0]) rotate([0,0,30*0])
									cylinder(r=spring_bolt_head_d/2, h=spring_bolt_head_h, $fn=6);
						}
				}
				
				// And carve a cylindrical space between the two axis bearings
				translate([0,0,-tol])
					cylinder(r=brg_608_outer_d/2 - brg_608_shoulder, h= body_height + 2*tol);
			}
			
			// Nema motor mount
			translate([axis_to_axis,motor_lateral_shift,motor_support_wall_th/2])
			{
				nema_support(motor_support_length, motor_support_width, motor_support_wall_th);
				translate([(motor_support_length+nema_additional_space_for_mount)/2-tol,0,-motor_support_wall_th/2])
					translate([wall_th/2-tol,0, 0])
						um_hooks(motor_umhook_wall_th, motor_support_width);
			}

			// Add the idler hinge support (we'll draw it from the hinge axis origin)
			body_idler_hinge();

			// The lateral tower that holds the bowden clamp
			bowden_clamp_tower();
		}
		
		carve_main_bearings();
	}
}

module carve_main_bearings()
{
	union()
	{
		translate([0,0,-tol]) union()
		{
			// the bottom bearing hole has a conic top (else it may print badly)
			cylinder(r=brg_608_outer_d/2, h= brg_608_th+tol);
			translate([0,0,brg_608_th])
			{
				cylinder(r1=brg_608_outer_d/2-0.1, r2=brg_608_outer_d/2-2.5, h= 2.5);
				cylinder(r=brg_608_outer_d/2-2.5, h= brg_608_th+brg_spacing+tol);
			}
		}
		translate([0,0, brg_608_th+brg_spacing]) cylinder(r=brg_608_outer_d/2, h= brg_608_th+tol + 100);
	}
}

module bct_cylinder(x,y, base_roundness=0)
{
	translate([x,y,0])
		difference()
		{
			hull()
			{
				if(base_roundness<=0)
				{
					cylinder(r=feeder_roundness, h=bowden_clamp_tower_z-feeder_roundness-2*tol);
					translate([0,0,bowden_clamp_tower_z-feeder_roundness]) sphere(r=feeder_roundness);
				}
				else
				{
					translate([0,0,base_roundness])
					{
						sphere(r=base_roundness);
						cylinder(r=base_roundness, h=bowden_clamp_tower_z-base_roundness*2-2*tol);
					}
					translate([0,0,bowden_clamp_tower_z-base_roundness])
						sphere(r=base_roundness);
				}
			}
			// Internal vertical hair-sized holes to reinforce the structure (in case of a hollow print)
			translate([0,-sin(4)*bowden_clamp_tower_z/2,print_layer_th*4]) rotate([-4,0,0])
			%cylinder(r=hair_tube_d/2, h=bowden_clamp_tower_z-print_layer_th*8);
		}
}

bowden_clamp_tower_base_hole_d= 7;
bowden_clamp_tower_z= feeder_holder_size_z+bowdenplug_base_width/2;
module bowden_clamp_tower()
{
	// Dirty cup-like bowden support near the hobbed bolt & idler bearing
	translate([filament_x,bowden_clamp_tower_origin[1],filament_z])
		hull()
		{
			intersection()
			{
				rotate([90,0,0]) cylinder(r1=10/2, r2=8/2, h=9);
				translate([-5,-7,body_height-filament_z-tol]) cube([10,10,6]); // open from the top
			}
			translate([0,0,body_height-filament_z-tol]) cube([3.8,8,tol],center=true);
		}
	
	translate(bowden_clamp_tower_origin)
	difference()
	{
		union()
		{
			tower_locking_nut("add");

			hull()
			{
				bct_cylinder(feeder_roundness,feeder_roundness); // near the hinge
				bct_cylinder(feeder_holder_size_x-feeder_roundness,feeder_roundness); // near the motor
				bct_cylinder(2,feeder_holder_size_y-2,2); // outside corner
				bct_cylinder(feeder_holder_size_x-feeder_roundness, feeder_holder_size_y-feeder_roundness); // outside motor corner
			}
			// ad-hoc (aka dirty) Link/contact with the main bearing column
			translate([feeder_holder_size_x/2-0.1,-5,tol])
				cube([feeder_holder_size_x/2, 6.5, body_height-tol]);
		}

		tower_locking_nut("carve");

		// Embossed TecRD logo on the tower base
		translate([feeder_holder_size_x/2, feeder_holder_size_y, body_height/2-2])
		{
			translate([0,-logoth,0])
			rotate([90,0,180])
				scale([0.8,0.8,1])
				scale([0.18,0.18,1]) translate([-76.5,-817.9,-0.5]) linear_extrude(height=50) 	import(file = "tecrd_logo_vecto_nb_only_lines.dxf");
		}
		
		// Vertical see-through hole to the bottom (helps unplugging the plug & remove some metrial when printing)
		translate([wall_th + bowdenplug_base_width/2,
			feeder_plug_expell_y + bowdenplug_base_height/2,
			-bowden_clamp_tower_origin[2]-tol])
		{
			hull()
			{
				translate([-bowdenplug_base_width/2+3.5,0,0])
					cylinder(r=(bowdenplug_base_height)/2-1, h=14);
				translate([bowdenplug_base_width/2-3.5,0,0])
					cylinder(r=(bowdenplug_base_height)/2-1, h=14);
			}
		}
	}
}

module tower_locking_nut(action)
{
		if(action=="carve")
		{
			// Side holes with semi-captive nut for small optional screws to hold the boden plug in place
			translate([0*feeder_holder_size_x-tol, feeder_plug_expell_y + bowdenplug_base_height/2, bowden_clamp_tower_z-bowdenplug_base_width/2])
				rotate([0,90,0])
				{
					translate([0,0,-2])
						cylinder(r=m3_d_tight/2, h=2+feeder_holder_size_x/2+2*tol);
					translate([0,0,(feeder_holder_size_x-bowdenplug_base_width)/2-m3_nut_h-m3_nut_tol-2*tol]) cylinder(r=m3_nut_d/2+m3_nut_tol, h=m3_nut_h+m3_nut_tol+3*tol, $fn=6);
					// motor side (useless): translate([0,0,feeder_holder_size_x-(feeder_holder_size_x-bowdenplug_base_width)/2]) cylinder(r=m3_nut_d/2+m3_nut_tol, h=m3_nut_h+m3_nut_tol+3*tol, $fn=6);
				}
		}
		else // if(action=="add")
		{
			// Support for side holes with semi-captive nut for small optional screws to hold the boden plug in place
			translate([0*feeder_holder_size_x-tol, feeder_plug_expell_y + bowdenplug_base_height/2, bowden_clamp_tower_z-bowdenplug_base_width/2])
				rotate([0,90,0]) hull()
				{
					cylinder(r=m3_nut_d/2+1.2, h=2*tol);
					translate([0,0,-1]) cylinder(r=m3_nut_d/2, h=2*tol);
				}
		}
}


module feeder_plug_inprint()
{
	// The bowden clamp space
	translate([filament_x, feeder_holder_start_y + feeder_plug_expell_y-tol, filament_z])
		rotate([-90,-90,0])
			bowdenplug_base_carve();
}

module body_idler_hinge(additive=1)
{
color([0.5,0.5,0])
	difference()
	{
		// Hinge support on body
		intersection()
		{
			translate(hinge_axis_pos) hull()
			{
				cylinder(r=idler_hinge_d/2+tol, h=body_height-tol);
				translate(hinge_body_direction)
					cylinder(r=2, h=body_height-tol);
				translate(hinge_out_direction) // reinforcement towards the outside
					cylinder(r=2, h=body_height-tol);
			}
			// Intersect it with this to keep it out of the tower guts
			translate([-50,1,0])
				cube([100, feeder_holder_start_y+2*tol, body_height+tol]);
		}

		
		// remove the hinge axis
		translate(hinge_axis_pos)
			cylinder(r=m3_d_tight/2, h=body_height + 2*tol, $fn=20);

		// and the spaces in the body for the idler arms
		for(h=[0:2*arm_hinge_height:body_height-tol])
		{
			translate([0, 0, h  + body_height/arm_hinge_count - print_layer_th])
			hull()
			{
				translate(hinge_axis_pos)
					cylinder(r=idler_hinge_d/2 + idler_hinge_d_gap, h= arm_hinge_height + print_layer_th*2 + tol, $fn=30);
				translate(hinge_axis_pos + [-10,0,0])
					cylinder(r=idler_hinge_d/2 + idler_hinge_d_gap, h= arm_hinge_height + print_layer_th*2 + tol, $fn=30);
				translate([idler_closest_dist,0,0])
					cylinder(r=brg_608_outer_d/2, h= arm_hinge_height + print_layer_th*2 + tol, $fn=30);
			}
		}

		translate(hinge_axis_pos+[0, 0, 0.5*body_height/arm_hinge_count])
			hinge_h_reinforcement();
	}
}

module hinge_h_reinforcement()
{
		for(h=[0:2*arm_hinge_height:body_height-tol])
			translate([0, 0, h])
				rotate([-90,0,-55])
					translate([0,0,-idler_hinge_d/2-tol])
						for(x=[-m3_d_tight*3:0.8:m3_d_tight*2])
							translate([x,0,-idler_hinge_d])
								cylinder(r=hair_tube_d, h=idler_hinge_d*3,$fn=3);
}

module spring_head(step="add", freeplay=0)
{
	translate([spring_head_th/2,0,0]) // will be build on x>0
	{
		if(step=="support")
		{
			if(springArmAddSupport)
			{
				// make it printer-friendly (avoid overhang) by adding a wall to be removed after print
				translate([0,-spring_hole_shoulder_diam/2,-spring_head_pos_z])
				{
					cube([print_layer_w,-spring_head_pos_y+spring_hole_shoulder_diam/2,spring_head_pos_z]);
					cylinder(r=4, h=1);
				}
			}
		}
		else if(step=="add")
		{
			// Spring fat reinforced head
			hull()
			{
				if(freeplay<=0)
					rotate([0,90,0])
						cylinder(r=spring_hole_shoulder_diam/2, h=spring_head_th, center=true);
				else 	rotate([0,90,0])
				{
					translate([0,-freeplay*spring_head_hfreeplay_offset,0])
						cylinder(r=spring_hole_shoulder_diam/2, h=spring_head_th, center=true);
					translate([0,freeplay*(1-spring_head_hfreeplay_offset),0])
						cylinder(r=spring_hole_shoulder_diam/2, h=spring_head_th, center=true);
				}
				rotate([0,90,0]) cylinder(r=spring_hole_shoulder_diam/2 + spring_hole_friendly, h=1, center=true);
				// Rounded base around the m3 hole
				translate(arm_vbolt_hole_pos-[0, (freeplay==0?arm_vbolt_body_shift:0), spring_head_pos_z])
					cylinder(r=m3_nut_d/2+arm_vbolt_outer_d,h=5);
			}
		}
		else // "carve"
		{
			// Remove free play on the idler arm
			if(freeplay<=0)
				rotate([0,90,0]) cylinder(r=spring_bolt_d/2, h=spring_head_th + 5, center=true);
			else rotate([0,90,0])
			{
				hull()
				{
					translate([0,-freeplay*spring_head_hfreeplay_offset,0])
						cylinder(r=spring_bolt_d/2, h=spring_head_th + 5, center=true);
					translate([0,+freeplay*(1-spring_head_hfreeplay_offset),0])
						cylinder(r=spring_bolt_d/2, h=spring_head_th + 5, center=true);
				}
				
				// And slight vertical groove perpendicular to the oblong hole
				translate([+10,0,-spring_head_th])
					rotate([0,-90,0])
						cylinder(r=idle_spring_groove_d/2, h=20);
			}
			// Two thin slices to be removed after printing (avoids impossible overhangs)
			translate([-spring_head_th/2-2,-spring_hole_shoulder_diam,-spring_bolt_d/2]) cube([spring_head_th+4,spring_hole_shoulder_diam,print_layer_th*2+tol]);

			translate([-spring_head_th/2-2,-spring_hole_shoulder_diam,spring_bolt_d/2-(print_layer_th*2+tol)]) cube([spring_head_th+4,spring_hole_shoulder_diam,print_layer_th*2+tol]);

			// no guide, but still a hole for a general usage screw
			translate(arm_vbolt_hole_pos-[0,(freeplay==0?arm_vbolt_body_shift:0),spring_head_pos_z+tol])
			rotate([0,0,-10])
				bolt_hole(thread_d=m3_d_tight,
					nut_d=m3_nut_d+m3_nut_tol,
					nut_h=m3_nylock_h+m3_nut_tol,
					nut_conic_h=0.6,
					total_h= body_height+2*tol+10, nut_fn=6);
				// bolt_hole(thread_d, nut_d, nut_h, nut_conic_h, total_h, nut_fn= 40)
			}
	}
}

module idler()
{
	translate(hinge_axis_pos)
		rotate([0,0,idler_display_rotation-tol])
			translate(-hinge_axis_pos) // debug
	{
		color([0.6,0.6,0.8])
			difference()
		{
			// The idler arm
			union()
			{
				// Solid body of the idler arm (spring side)
				hull()
				{
					translate([idler_closest_dist,0,0])
						cylinder(r=idler_inner_diam/2+idler_th, h= body_height); // central cylinder

					translate([idler_closest_dist-idler_inner_diam/2-idler_th,spring_head_pos_y,spring_head_pos_z])
						spring_head("add", spring_head_hfreeplay);
				}
				translate([idler_closest_dist-idler_inner_diam/2-idler_th,spring_head_pos_y,spring_head_pos_z])
					spring_head("support");
					
				// Solid body of the idler arm (hinge side)
				hull()
				{
					translate([idler_closest_dist,0,0])
						cylinder(r=idler_inner_diam/2+idler_th+idler_th_reinforcement, h= body_height); // central part
					translate([0,0,body_height/2])
						translate(hinge_axis_pos) cylinder(r=idler_hinge_d/2, h=body_height, center=true); // hinge cylinder
					translate([-idler_th_reinforcement,0,body_height/2])
						translate(hinge_axis_pos) cylinder(r=idler_hinge_d/2, h=body_height, center=true); // reinforcement of the hinge towards the outside
				}
				// bearing small shoulder
				translate([idler_closest_dist,0,0])
					cylinder(r=idler_inner_diam/2+2, h= body_height + idler_brg_gap);
			}

			// Remove some material for the protruding main bolt bearings
			translate(idler_freeplay_to_main_bearings_offset)
				translate([0,0,-tol])
					cylinder(r=brg_608_outer_d/2+idler_freeplay_to_main_bearings, h=body_height+tol+1,$fn=40);

			// Remove screwable bolt hole for the idler bearing
			translate([idler_closest_dist,0,body_height+idler_brg_gap+brg_608_th - idler_bolt_thread_height -tol])
				translate([-sin(idler_bearing_axis_angle)*idler_bolt_thread_height/2,0,0])
					rotate([0,idler_bearing_axis_angle,0])
						cylinder(r=m8_d_tight/2, h= idler_bolt_thread_height);

			// Carve a m3 general usage hole
			//translate([idler_closest_dist-1,spring_head_pos_y*0.7,-tol]) cylinder(r=3/2, h= idler_bolt_thread_height+2*tol);

			// Carve the body hinge part within the idler
			translate(hinge_axis_pos)
			{
				for(h=[0:2*arm_hinge_height:body_height-tol])
				{
					translate([0, 0, h-tol])
					hull()
					{
						cylinder(r=idler_hinge_d/2+idler_hinge_d_gap, h=arm_hinge_height);
						translate([-5,5,0]) // carve to the outside (to allow wide opening of the idler arm)
							cylinder(r=idler_hinge_d/2+idler_hinge_d_gap, h=arm_hinge_height);
					}
				}
				translate([0,0, body_height-m3_head_h+tol]) // room for the screw head (hobbed bolt side)
					cylinder(r=m3_head_d/2, h=m3_head_h); // tho it makes the hinge a bit more fragile
			}

			// Remove hinge axis on the idler
			translate(hinge_axis_pos-[0,0,tol])
				cylinder(r=m3_d_tight/2+tol, h=body_height + 2*tol, $fn=12);

			// Remove spring inner
			translate([idler_closest_dist-idler_inner_diam/2-idler_th,spring_head_pos_y,spring_head_pos_z])
				spring_head("carve", spring_head_hfreeplay);

			translate(hinge_axis_pos+[0, 0, 1.5*body_height/arm_hinge_count])
				hinge_h_reinforcement();
		}
		if(debug_what=="all" || debug_what=="brg")
			debug_idler_bearing();
	}
}

module idler_standalone()
{
		idler();
		// You need this when you want to print the idler alone!
		intersection()
		{
			body_idler_hinge();
			translate(hinge_axis_pos) cylinder(r=idler_hinge_d/2+2, h=body_height*2 + 2*tol);
		}
}


%debug_ghosts();
difference()
{
	union()
	{
		body();
		idler();
//		idler_standalone()
	}
	// Carve the body with the plug
	feeder_plug_inprint();
}
