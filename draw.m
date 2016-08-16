clear all
close all
p = genpath('../toolbox');
addpath(p);

fid1=fopen('draw.cfg');
groundtruth = '';
testFiles={};
testNames={};
type={};
i = 0;
while ~feof(fid1)
    aline=fgetl(fid1);
    if i == 0,
        groundtruth = aline;
    else
       strs = regexp(aline, ' ', 'split');
       testFiles{i} = strs{1}; 
       testNames{i} = strs{2};
       type{i} = strs{3};
    end
    i=i+1;
end
fclose(fid1);
pLoad={'lbls',{'person'},'ilbls',{'people'}};
figure(1)
for i = 1:size(testFiles,2)
    [gt,dt] = bbGt( 'myLoadAll', groundtruth,testFiles{i},pLoad);
    thr = 0.5;
    [gt,dt] = bbGt('evalRes',gt,dt,thr,0);
    [xs,ys] = bbGt('compRoc',gt,dt,1);
    ys = 1 - ys;
    hold on;
    plot(xs,ys,type{i},'LineWidth',3);
    set(gca,'XScale','log','YScale','log',...
        'XMinorGrid','on','XMinorTic','on',...
        'YMinorGrid','on','YMinorTic','on');
    title('ROC');
    xlim([0 10]);
    ylim([0 1]);
    xlabel('false positives per image','FontSize',14);
    ylabel('miss rate','FontSize',14);
    hold off
end
legend(testNames{1},testNames{2});
saveas(gcf,'test.jpg');