Spin Glasses
==

## Intro

This library has been created for the simulation of spin glasses and other complex networks.  
I used OOP features of MATLAB to implement the code efficiently. In addition the simulation uses .MEX files that are compiled in C for speed of execution, and the computations are distibuted by the parallel processing features of MATLAB.  
All the code has been written by me and is thereby my property.

Antoine Lizée, antoine.lizee@polytechnique.edu


## Running one example

I included one example of a result from the simulations in the root (the .mat file), which should give the reader insights on the aim of this personal study. To visualize this result, just execute in MATLAB the following lines after having added all the files to the path:

    load 'step1_0-1_0-05_6_40'  
    for i=1:length(nGstep), nGstep{i}.dim=2; end  
    i=1; % Choose the index of the network  
    nGstep{i}.movie(1,100)

and maximise the resulting window.


