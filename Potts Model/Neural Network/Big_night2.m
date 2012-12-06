matlabpool 2

tic
nG3D=neuralGrid('glasses', 2, [50 50 50]);
nGcool=cooling(nG3D,100,2,-2:0.1:2);
nGcool=decay(nGcool,5000);
half(nGcool);
save('3DGcool_decay','nGcool')
clear nGcool
toc

tic
nG3DB=copy(nG3D);
nG3DB.B=0.01;
nGcoolB=cooling(nG3DB,100,2,-2:0.1:2);
nGcoolB=decay(nGcoolB,5000);
half(nGcoolB);
save('3DGBcool_decay','nGcoolB')
clear nGcoolB
toc

tic
nG3D2=neuralGrid('glasses', 2, [50 50 50]);
nGcool2=cooling(nG3D2,100,2,-2:0.1:2);
nGcool2=decay(nGcool2,5000);
half(nGcool2);
save('3DG2cool_decay','nGcool2')
clear nGcool2
toc

tic
nG3D2B=copy(nG3D2);
nG3D2B.B=0.01;
nGcool2B=cooling(nG3D2B,100,2,-2:0.1:2);
nGcool2B=decay(nGcool2B,5000);
half(nGcool2B);
save('3DG2Bcool_decay','nGcool')
clear nGcool2B
toc


matlabpool close force local