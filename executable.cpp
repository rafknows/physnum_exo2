#include <iostream>
#include <fstream>
#include <iomanip>
#include "ConfigFile.h" // Il contient les methodes pour lire inputs et ecrire outputs 
#include <valarray>
#include <cmath> // Se usi fun
using namespace std;

class Exercice2
{

private:
  double t, dt, tFin;
  double m, g, L;
  double Omega, kappa;
  double theta, thetadot;
  double B0, B1;
  double mu;
  double om_0, om_1, nu, Ig;
  double I;


  int N_excit, nsteps_per, Nperiod;
  int sampling;
  int last;
  ofstream *outputFile;

  void printOut(bool force)
  {
    if((!force && last>=sampling) || (force && last!=1))
    {
      double emec = (1/2) * I * pow(Omega, 2) - mu * B0; // TODO: Evaluer l'energie mecanique
      double pnc  = 0.0; // TODO: Evaluer la puissance des forces non conservatives

      *outputFile << t << " " << theta << " " << thetadot << " " << emec << " " << pnc << endl;
      last = 1;
    }
    else
    {
      last++;
    }
  }

    // TODO define angular acceleration functions and separate contributions
    // for a[0] = function of (x,t), a[1] = function of (v)
  valarray<double> acceleration(double x, double v, double t_)
  {
    valarray<double> acc = valarray<double>(2);

    acc[0] = - (mu / I) * sin(x) * (B0 + B1 * sin(Omega * t)); // angular acceleration depending on x and t only
    acc[1] = - (kappa / I) * v; // angular acceleration depending on v only

    return acc;
  }


    void step()
  {
    // TODO: implement the extended Verlet scheme Section 2.7.4
    double thetadot_half;
    valarray<double> a = acceleration(theta, thetadot, t); //using position and velocity at step j
    //theta        = 0.0; 
    //thetadot     = 0.0;

    theta = theta + thetadot * dt + (1.0/2.0) * (a[0] + a[1]) * pow(dt, 2); //step j+1
    thetadot_half = thetadot + (1.0/2.0) * (a[0] + a[1]) * dt; //step j+1/2

    valarray<double> step_a = acceleration(theta, thetadot_half, t +dt); //acc using j+1 position 
    valarray<double> half_step_a2 = acceleration(theta, thetadot_half, t +dt/2); //acc using j+1/2 velocity 
    
    thetadot = thetadot + (1.0/2.0) * (a[0] + step_a[0]) * dt  + half_step_a2[1] * dt;

  }


public:
  Exercice2(int argc, char* argv[])
  {
    const double pi=3.1415926535897932384626433832795028841971e0;
    string inputPath("config.in"); // Fichier d'input par defaut
    if(argc>1) // Fichier d'input specifie par l'utilisateur ("./Exercice2 config_perso.in")
      inputPath = argv[1];

    ConfigFile configFile(inputPath); // Les parametres sont lus et stockes dans une "map" de strings.

    for(int i(2); i<argc; ++i) // Input complementaires ("./Exercice2 config_perso.in input_scan=[valeur]")
      configFile.process(argv[i]);

    Omega    = configFile.get<double>("Omega");     // frequency of oscillating magnetic field
    kappa    = configFile.get<double>("kappa");     // coefficient for friction
    m        = configFile.get<double>("m");         // mass
    L        = configFile.get<double>("L");         // length
    B1       = configFile.get<double>("B1");     //  B1 part of magnetic fields (oscillating part amplitude)
    B0       = configFile.get<double>("B0");     //  B0 part of magnetic fields (static part amplitude)
    mu       = configFile.get<double>("mu");     //  magnetic moment 
    theta    = configFile.get<double>("theta0");    // initial condition in theta
    thetadot = configFile.get<double>("thetadot0"); // initial condition in thetadot
    sampling = configFile.get<int>("sampling");     // number of time steps between two writings on file
    N_excit  = configFile.get<int>("N_excit");      // number of periods of excitation
    Nperiod  = configFile.get<int>("Nperiod");      // number of periods of oscillation of the eigenmode
    nsteps_per= configFile.get<int>("nsteps");      // number of time step per period

    I = (1.0 / 12.0) * m * pow(L, 2);

    // Ouverture du fichier de sortie
    outputFile = new ofstream(configFile.get<string>("output").c_str());
    outputFile->precision(15);


    // define auxiliary variables if you need/want
    double T = (2 * pi) / Omega;
    // TODO: implement the expression for tFin, dt
    
    if(N_excit>0){
      // simulate N_excit periods of excitation
      tFin = N_excit * T;
      dt   = T / nsteps_per;
    }
    else{
      // simulate Nperiod periods of the eigenmode
      tFin = Nperiod * T;
      dt   = T / nsteps_per;
    } 
    cout << "final time is "<<"  "<< tFin << endl; 

  }
  

  ~Exercice2()
  {
    outputFile->close();
    delete outputFile;
  };

    void run()
  {
    t = 0.;
    last = 0;
    printOut(true);

    while( t < tFin-0.5*dt )
    {
      step();
      t += dt;
      printOut(false);
    }
    printOut(true);
  };

};

int main(int argc, char* argv[])
{
  Exercice2 engine(argc, argv);
  engine.run();

  return 0;
}
