%% First step, about 1h
% two spin glasses temperatures, test of global/local memory
% short periods
T=repmat([0.1 0.05],1,6);
B=[0.001 0.002];
n_cycles=40;
test_Step
save('step1_0-1_0-05_6_40','nGstep')
clear

%% Second step, about 1h
% two colder spin glasses temperatures, test of global/local memory
% short periods
T=repmat([0.02 0.05],1,6);
B=[0.001 0.002];
n_cycles=40;
test_Step
save('step1_0-02_0-05_6_40','nGstep')
clear

%% Third step, about 1h
% two colder spin glasses temperatures, test of global/local memory
% long periods
T=repmat([0.1 0.05],1,2);
B=[0.001 0.002];
n_cycles=150;
test_Step
save('step1_0-1_0-05_2_150','nGstep')
clear

%% First cooling
%Fast cooling
matlabpool 4
nGcool0=neuralGrid('classic', 2, [400 400]);
nGcool0.B=0.001;
nGcool=cooling(nGcool0,2,2);
save('fast_cool','nGcool');
clear


%% Second cooling
%slow cooling
nGcool0=neuralGrid('classic', 2, [400 400]);
nGcool0.B=0.001;
nGcool=cooling(nGcool0,2,10);
save('slow_cool','nGcool');
clear

matlabpool close force local

%% Test for glasses ditribution
matlabpool 4
nGglass0=neuralGrid('glasses',2,[400 400]);
nGglass0.B=0.001;
nGglass=cooling(nGglass0,2,4,-2:0.1:2);
save('glass_cool','nGglass');
clear
matlabpool close force local
