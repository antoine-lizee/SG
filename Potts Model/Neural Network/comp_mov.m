function handle= comp_mov( objcell,fig,fps)
%COMP_MOV Summary of this function goes here
%   Detailed explanation goes here
if nargin<2
    fig=1;
end
if nargin<3
    fps=10;
end
if ~isa(objcell{1},'neuralGrid')
    error('NeuralGrid input only please !!');
end

figure(fig);
n=numel(objcell);
s1=size(objcell,1);
s2=size(objcell,2);
axes=zeros(n);
for k=1:n
    h{k}=objcell{k}.nodes;
    axes(k)=subplot(s1,s2,k,'YTick',zeros(1,0),'XTick',zeros(1,0),'NextPlot','replacechildren','DataAspectRatio',[1 1 1]);
    box(axes(k),'on');
    set(axes(k),'DefaultImageCDataMapping','scaled');
    colormap(gray);
    image(h{k}(:,:,1));
    axis tight;
end

for i=1:size(h{1},3);
    for k=1:n
        image(h{k}(:,:,i),'parent',axes(k));
        title(axes(k),['NETWORK AGE:' num2str(i)]);
    end
    drawnow;
    pause(1/fps);
end


end

