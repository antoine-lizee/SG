    
parfor i=1:4
    nG3D2{i}=neuralGrid('glasses', 2, [40 40 40]);
    nG3D2{i}.incr_aging(200);
    nG3D2{i}.B=0.01
    nG3D2{i}.incr_aging(200);
    nG3D2{i}.B=0.0;
    nG3D2{i}.T=0.01
    nG3D2{i}.incr_aging(200);
    nG3D2{i}.B=0.01
    nG3D2{i}.incr_aging(200);
end