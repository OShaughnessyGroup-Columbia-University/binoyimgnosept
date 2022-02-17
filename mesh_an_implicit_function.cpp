#include <CGAL/Surface_mesh_default_triangulation_3.h>
#include <CGAL/Complex_2_in_triangulation_3.h>
#include <CGAL/make_surface_mesh.h>
#include <CGAL/Implicit_surface_3.h>
#include <CGAL/squared_distance_3.h>
#include <CGAL/IO/Complex_2_in_triangulation_3_file_writer.h>
#include <cmath>
#include <fstream>
#include <algorithm> 
#include <functional>
#include <cstdlib>
#include <iostream>
#include <vector>

// typical usage ./mesh_an_implicit_function 0.02 2 1.85 30 0.01 0.01 wtfc3_1_10min_septum.off
// here 1.85 is the ring radius, the others are some parameters.
// see the rest of the code to understand what they mean.

// default triangulation for Surface_mesher
typedef CGAL::Surface_mesh_default_triangulation_3 Tr;
// c2t3
typedef CGAL::Complex_2_in_triangulation_3<Tr> C2t3;
typedef Tr::Geom_traits GT;
typedef GT::Sphere_3 Sphere_3;
typedef GT::Point_3 Point_3;
typedef GT::FT FT;
// ignore following two lines, they came with the CGAL example
//typedef FT (*Function)(Point_3);
//typedef CGAL::Implicit_surface_3<GT, Function> Surface_3;
typedef std::function<FT(Point_3)> Function;
typedef CGAL::Implicit_surface_3<GT, Function> Surface_3;

double stadiumR(double p, double L, double R)
{
   /* 
   Given an angle, p
   obtain r(p) where r is radial coordinate of the stadium curve.
   by stadium curve, i mean a running track with
   two straight regions of length L and two
   semicircles of radius R.
   */
  double xs;
  double ys;
  double al;
  
  // get the angle to between -pi and pi
  if (p > 3.1415926535897931) {
    p -= 6.2831853071795862;
  }

  // following code just sets up the stadium and is all math
  xs = 0.0;
  ys = 0.0;
  al = std::atan(L / (2.0 * R));
  if ((0.0 <= p) && (p <= 1.5707963267948966)) {
    if (p <= 1.5707963267948966 - al) {
      ys = p + std::asin(L / (2.0 * R) * std::sin(p));
      xs = L / 2.0 + R * std::cos(ys);
      ys = R * std::sin(ys);
    } else {
      xs = R * (1.0 / std::tan(p));
      ys = R;
    }
  } else if ((1.5707963267948966 < p) && (p <= 3.1415926535897931)) {
    if (3.1415926535897931 - p <= 1.5707963267948966 - al) {
      ys = (3.1415926535897931 - p) + std::asin(L / (2.0 * R) * std::sin
        (3.1415926535897931 - p));
      xs = L / 2.0 + R * std::cos(ys);
      ys = R * std::sin(ys);
    } else {
      xs = R * (1.0 / std::tan(3.1415926535897931 - p));
      ys = R;
    }

    xs = -xs;
  } else {
    if (p < 0.0) {
      ys = stadiumR(-p, L, R);
      xs = ys * std::cos(p);
      ys = -ys * std::sin(p);
    }
  }
  return std::sqrt(xs * xs + ys * ys);
}

FT stadium (double H, 
	double L0,double R0, std::vector<double> &dr,
	Point_3 p) {
		
   /*
	  returns a positive number if point is outside surface
	  a negative number if point is within surface
	  
	  surface is generated by rotating an ellipse centered at
	  ((R0+(L+H)/2),0,0) and in y = 0 plane 
	  with small and long axes b and a about the z axis
	  
	  b = H/2
	  a = L0/2
	  
	  H is thickness of septum
	  R0 is radius of inner septum edge
	  L0 is the long axis of the elliptical cross-section
	  
	  For the format Point_3 and all the CGAL functions,
	  refer to the package CGAL, in particular the 3D 
	  surface mesh creating module of CGAL.
  */
	
  double rc = R0+(L0+H)/2;
  double px = 0;
  double pz = 0;
  double th = 0;
  double r = 0;
  
  double th2 = 0;
  int N = dr.size();
  double dth = 2*3.1415/N;

  int elem = 0;

  Point_3 prot(0,0,0);
  Point_3 pc(0,0,0);

  // adjust parameters based on the irregular nature of the septum
  th2 = std::atan2(p.y(),p.x());
  if (th2 < 0) th2 = th2 + 6.2832;
  elem = th2/dth;
  if (elem > N - 1) elem = N - 1;
  L0 = L0 - dr[elem];
  rc = rc + dr[elem]/2;
  
  px = std::sqrt(p.x()*p.x() + p.y()*p.y());
  pz = p.z();
  prot = Point_3(px,0,pz);
  th = std::atan2(pz,px-rc);
  r = stadiumR(th,L0,H/2);
  pc = Point_3(rc,0,0);
    
  return std::sqrt(CGAL::squared_distance(prot,pc)) - r;

}

int main(int argc, char *argv[]) {
  Tr tr;            // 3D-Delaunay triangulation
  C2t3 c2t3 (tr);   // 2D-complex in 3D-Delaunay triangulation
  // defining the surface
  
  // following are geometric parameters
  double H = 0.2;	// thickness of septum
  double Rcell = 2; // radius of cell
  double R0 = 1;	// radius of inner septum edge
  double L0 = Rcell-R0-H;	// length of flat part of septum
  double angle_bound = 30;  // min angle of triangles
  double radius_bound = 0.01; // technical, see the cgal link
  double distance_bound = 0.01; // technical, see cgal link

  // read r(theta) information -- the septum edge
  std::vector<double> dr;
  double tempNum = 0;  // a temporary double variable
  
  // cgal link is secn. 3.1 in 
  // http://doc.cgal.org/latest/Surface_mesher/index.html
  
  // output file name
  char * outFileName = "out_ell.off";

  // File with the r(theta) information;
  char * rThetaFileName = "blahblah.txt";
  
  // input file with r(theta) information
  std::ifstream File;

  // get all inputs from command line
  if(argc < 8){
	std::cout << "Usage ./programname H Rcell R0 " <<
		"angle-bound radius-bound distance-bound outfilename r_theta_file" <<
		"(all in micron and degrees)" 
		<< std::endl;

        std::cout << "r_theta_file is a file with N entries which represent ";
        std::cout << "corrections about a circular septum edge " << std::endl;
        std::cout << "ith line gives the correction at the angle ";
        std::cout << "2*pi*i/N where N is the total number of lines " << std::endl;
	std::cout << "This input is optional " << std::endl;
        
	std::cout << "Also see secn. 3.1 in http://doc.cgal.org/latest/Surface_mesher/index.html " <<
		"for info on what the 3 bounds mean " << std::endl;
	return 1;
  }
  
  // set inputs from command line
  try{
	  H = std::atof(argv[1]);
	  Rcell = std::atof(argv[2]);
	  R0 = std::atof(argv[3]);
	  angle_bound = std::atof(argv[4]);
	  radius_bound = std::atof(argv[5]);
	  distance_bound = std::atof(argv[6]);
	  outFileName = argv[7];
  } catch (const std::exception& e) { 
	std::cout << "Error. Run the file without any arguments to get more information " << std::endl;
	return 1;
  }

  if(argc == 9){
	  rThetaFileName = argv[8];
	  File.open(rThetaFileName);
	  if(File.good()){
		  while(File >> tempNum) dr.push_back(tempNum);
	  } else {
		  std::cout << "Supplied file not found" << std::endl;
		  return 1;
	  }
  
  } else { 
	  for(tempNum = 0; tempNum < 1000; tempNum++) dr.push_back(0);
	  //for(cnt = 0; cnt < N; cnt++) dr[cnt] = 0.1*std::sin(6*cnt*2*3.1415/N);
  }

  L0 = Rcell-R0-H;
  
  // set up surface object
  Surface_3 surface(
	[&H,&L0,&R0,&dr](Point_3 p)->FT{ return stadium(H,L0,R0,dr,p);},
	Sphere_3(CGAL::ORIGIN, 10.)); // bounding sphere
  // Note that "10." above is the *squared* radius of the bounding sphere!
  
  // defining meshing criteria
  CGAL::Surface_mesh_default_criteria_3<Tr> criteria(angle_bound,  // angular bound
                                                     radius_bound,  // radius bound
                                                     distance_bound); // distance bound
  // meshing surface and write to file
  CGAL::make_surface_mesh(c2t3, surface, criteria, CGAL::Non_manifold_tag());
  std::ofstream out(outFileName);
  CGAL::output_surface_facets_to_off (out, c2t3);
  std::cout << "Final number of points: " << tr.number_of_vertices() << "\n";
  return 0;
  
  /* // legacy code
  Surface_3 surface(sphere_function,             // pointer to function
                    Sphere_3(CGAL::ORIGIN, 10.)); // bounding sphere
  */
}
