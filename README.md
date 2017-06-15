# odemcmc

Implementation of probabilistic ODE model structure inference using MCMC methods


## Authors

* Juho Timonen (juho.timonen@aalto.fi)
* Based on LEM modeling implementation by Jukka Intosalmi [http://research.ics.aalto.fi/csb/software/lem/]


## Contents

### Main functions

* computeAllUlpp.m - Compute the unnormalized log-posterior value for each allowed model

* mainSim.m - Main function for running inference in simulated data cases where the ulpp values have been pre-computed using computeAllUlpp.m

* createSimulatedDataAndOpt.m - Main function for creating simulated data and formulating the inference problem

* mainTh17.m - Main function for structure inference with real data


### Folders

* src - Functions needed in the inference

* data_and_options - Example simulated and real datasets with options that define the inference problem

* results - Results for simulated and real data inference


## Requirements

* Matlab [https://se.mathworks.com/products/matlab.html]
* Sundials + sundialsTB [https://computation.llnl.gov/projects/sundials]

Tested with Matlab 2016a, 2016b and sundials 2.4.0 
