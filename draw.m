clear all
close all
p = genpath('../toolbox');
addpath(p);

fid1=fopen('configure/draw.cfg');
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
pLoad={'lbls',{'person'},'ilbls',{'people'},'squarify',{3,.41},'hRng',[50 inf]};
p = {};
figure(1)
yMin = 100;
xMax = 0;
grid on;
for i = 1:size(testFiles,2)
    [gt,dt] = bbGt( 'myLoadAll', groundtruth,testFiles{i},pLoad);
    thr = 0.5;
    [gt,dt] = bbGt('evalRes',gt,dt,thr,0);
    [xs,ys] = bbGt('compRoc',gt,dt,1);
    ys = 1 - ys;
    hold on;
    plot(xs,ys,type{i},'LineWidth',3);
    yMin=min(yMin,min(ys)); 
    xMax=max(xMax,max(xs));
    xlabel('false positives per image','FontSize',14);
    ylabel('miss rate','FontSize',14);
end
yt=[.05 .1:.1:.5 .64 .8]; ytStr=int2str2(yt*100,2);
for i=1:length(yt), ytStr{i}=['.' ytStr{i}]; end
set(gca,'XScale','log','YScale','log',...
        'YTick',[yt 1],'YTickLabel',[ytStr '1'],...
        'XMinorGrid','off','XMinorTic','off',...
        'YMinorGrid','off','YMinorTic','off');
title('ROC');
xlim([0 xMax]);
ylim([yMin, 1]);

legend(testNames,'Location','sw');
saveas(gcf,'images/testDangerous.jpg');