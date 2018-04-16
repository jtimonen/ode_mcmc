# ode_mcmc

Implementation of probabilistic ODE model structure inference using MCMC methods

## Authors

* Juho Timonen (juho.timonen@aalto.fi)
* Based on LEM modeling implementation by Jukka Intosalmi [http://research.ics.aalto.fi/csb/software/lem/]

### Main functions

Main functions for running the inference in simulated data cases where the model probabilities have been precomputed
* main_sim_1.m
* main_sim_23.m

Function for precomputing model probabilities
* precompute.m

Main functions for creating simulated data and formulating an inference problem
* defineSimProblem_1.m
* defineSimProblem_2.m
* defineSimProblem_3.m

Main function for structure inference with real data
* main_Th17.m

## Requirements

* Matlab [https://se.mathworks.com/products/matlab.html]
* Sundials + sundialsTB [https://computation.llnl.gov/projects/sundials]

Tested with Matlab 2016b and sundials 2.4.0 

## References

* J. Timonen, H. Mannerström, H. Lähdesmäki and J. Intosalmi, "A probabilistic framework for molecular network structure inference by means of mechanistic modeling," in IEEE/ACM Transactions on Computational Biology and Bioinformatics.

URL: http://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=8334413&isnumber=4359833
