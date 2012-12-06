
nGt=cat(2,nGcool, nGcoolB); dim0=3;
k=0;

temp=[];
mag=[];
en=[];
for i=1:numel(nGt)
    %temp=[temp, nGt{i}.temphist];
    nGt{i}.dim=dim0;
    mag=[mag, nGt{i}.maghist];
    en=[en, nGt{i}.enhist];
end
temp=nGt{i}.temphist;

x=(0:(nGt{1}.age-1))';
figure(1+10*k)
clf
plotyy(x,temp,x,mag,'semilogy','plot');
figure(2+10*k)
clf
plotyy(x,temp,x,en,'semilogy','plot');

%%
nmean=11;
[index offset]=meshgrid(1:nGt{1}.age-nmean,0:nmean-1);
indextot=index+offset;
xmean=((nmean+1)/2-1:(nGt{1}.age-1-(nmean+1)/2))';

magmean=[];
enmean=[];
for i=1:numel(nGt)
    magi=mag(:,i);
    magmean=[magmean, mean(magi(indextot))'];
    eni=en(:,i);
    enmean=[enmean, mean(eni(indextot))'];
   
end
tempmean=temp(floor((nmean+1)/2):end-ceil((nmean+1)/2));

figure(3+10*k)
clf
plotyy(xmean,tempmean,xmean,magmean,'semilogy','plot');
figure(4+10*k)
clf
plotyy(xmean,tempmean,xmean,enmean,'semilogy','plot');



%%
% 
% figure(9+10*k);
% clf
% ind=[];
% kmax=6;
% nc=40;
% for k=1:kmax
%     ind=[ind ;(nc*(2*k-1)+1):(nc*2*k+1)];
% end
% hold on
% e2=cell(numel(nGt),1);
% for i=1:numel(nGt)
%     ei=en(:,i);
%     e2{i}=ei(ind)';
%     plot(e2{i});
% end
% 
% % hold all
% % for i=1:numel(nGt)
% %     plot(e2{i});
% % end
