# odemcmc

Implementation of probabilistic ODE model structure inference using MCMC methods


## Authors

* Juho Timonen (juho.timonen@aalto.fi)
* Based on LEM modeling implementation by Jukka Intosalmi [http://research.ics.aalto.fi/csb/software/lem/]


## Contents

### Main functions

computeAllUlpp.m - Compute the unnormalized log-posterior value for each allowed model

mainSim.m - Main function for running inference in simulated data cases where the ulpp values have been pre-computed using computeAllUlpp.m

createSimulatedDataAndOpt.m - Main function for creating simulated data and formulating the inference problem

mainTh17.m - Main function for structure inference with real data


### Folders

src - folder containing functions needed in the inference

data_and_options - folder containing example simulated and real datasets with options that define the inference problem

results - folder containing results for simulated and real data inference