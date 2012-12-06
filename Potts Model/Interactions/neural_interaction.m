function [ interaction ] = neural_interaction( type )
%NEURAL_INTERACTION Summary of this function goes here
%   Detailed explanation goes here

if nargin==0
    type='classic';
elseif nargin==1
    if ~ischar(type)
        error('NeuralInter:argin','Argument must be a string');
    end
end

switch type
    case 'classic'
        X=-1:0.001:1;
        dist=[0,Inf];
        pdf=classic(X);
        cdf=cumtrapz(pdf)*0.001;
        [distrib montecarlo]=invcdf(X,cdf,0.001);
    case 'Ising'
        X=1;
        dist=[0,Inf];
        pdf=[];
        cdf=1;
        distrib=[0 1];
        montecarlo=[1 1];
    case 'glasses'
        X=-1:0.001:1;
        dist=[0,Inf];
        pdf=glass(X);
        cdf=cumtrapz(pdf)*0.001;
        [distrib montecarlo]=invcdf(X,cdf,0.001);
        
end

interaction.X=X;
interaction.dist=dist;
interaction.pdf=pdf;
interaction.cdf=cdf;
interaction.distrib=distrib;
interaction.montecarlo=montecarlo;
interaction.name=type;

end


