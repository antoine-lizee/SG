function Test_interactionfunction(name)
%Use this function to test and display interaction functions

x=(-1:0.01:1)'; 
y=name(x);
plot(x,y);
xlabel('Interaction between two neurons')
ylabel('pdf of J, interaction factor')
title('Representation of the pdf of the interaction factor')

int=quad(name,-1,1);
disp(sprintf('The interaction function must be normalized by %g',int));

end