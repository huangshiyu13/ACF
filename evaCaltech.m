p = genpath('../toolbox');
addpath(p);
p = genpath('../../DATA/code3.2.1');
addpath(p);
clear all;

resDir = '/Users/shiyuhuang/Desktop/results/UsaTest';
resfiles = {'ev-Reasonable-ACF-Caltech.mat',...
            'ev-Reasonable-SA-FastRCNN.mat'};
types = {'r-','b-'};
n = length(resfiles);
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

for i = 1:n
    [xs,ys] = bbGt('compRoc',gts{i},dts{i},1);
    ys = 1 - ys;
    hold on;
    plot(xs,ys,types{i},'LineWidth',3);
    set(gca,'XScale','log','YScale','log',...
        'XMinorGrid','on','XMinorTic','on',...
        'YMinorGrid','on','YMinorTic','on');
    title('ROC');
    xlim([0 10]);
    ylim([0 1]);
    xlabel('false positives per image','FontSize',14);
    ylabel('miss rate','FontSize',14);
end
legend(names);
saveas(gcf,'images/test.jpg');
