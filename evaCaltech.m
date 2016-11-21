p = genpath('../toolbox');
addpath(p);
p = genpath('../../DATA/code3.2.1');
addpath(p);
clear all
close all
resDir = '../../DATA/Caltech/res/';
resfiles = {'ev-Reasonable-ACF.mat',...
            'ev-Reasonable-HOG.mat',...
            'ev-Reasonable-VJ.mat',...
            'ev-Reasonable-MT-DPM.mat',...
            'ev-Reasonable-CCF.mat',...
            'ev-Reasonable-TA-CNN.mat',...
            'ev-Reasonable-Checkerboards.mat',...
            'ev-Reasonable-CompACT-Deep.mat',...
            'ev-rpn_origin.mat'};
types = {'g-','m-','k-','y','r-','c-','k--','b--','b-'};

n = length(resfiles);
assert(n == length(types));
res=cell(1,n);
names = cell(1,n);
gts = cell(1,n);
dts = cell(1,n);

for i = 1:n
    res{i} = load([resDir '/' resfiles{i}]);
    names{i} = res{i}.R.stra;
    gts{i} = res{i}.R.gtr;
    dts{i} = res{i}.R.dtr;
end
names{n} = 'RPN+';
yMin = 100;
xMax = 0;
for i = 1:n
    [xs,ys] = bbGt('compRoc',gts{i},dts{i},1);
    ys = 1 - ys;
    hold on;
    plot(xs,ys,types{i},'LineWidth',3);
    
    yMin=min(yMin,min(ys)); 
    xMax=max(xMax,max(xs));
   
end
xlabel('false positives per image','FontSize',18,'FontWeight','bold');
ylabel('miss rate','FontSize',18,'FontWeight','bold');

grid on
yt=[.05 .1:.1:.5 .64 .8]; ytStr=int2str2(yt*100,2);
for i=1:length(yt), ytStr{i}=['.' ytStr{i}]; end
set(gca,'XScale','log','YScale','log',...
        'YTick',[yt 1],'YTickLabel',[ytStr '1'],...
        'XMinorGrid','off','XMinorTic','off',...
        'YMinorGrid','off','YMinorTic','off');
title('ROC of Caltech','FontSize',14);
xlim([0 xMax]);
ylim([yMin, 1]);
legend(names,'Location','sw');
saveas(gcf,'images/testCaltech.jpg');
