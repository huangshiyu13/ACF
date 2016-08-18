p = genpath('../toolbox');
addpath(p);
p = genpath('../../DATA/code3.2.1');
addpath(p);
clear all;
common = 'AcfCaltechPureOrigin';
imgDir = '/Users/shiyuhuang/Downloads/ATOCAR/DATA/Caltech/Caltech/test/images/';
saveName = ['/Users/shiyuhuang/Downloads/ATOCAR/DATA/Caltech/UsaTest/dt-' common '.mat'];
evasaveName = ['/Users/shiyuhuang/Downloads/ATOCAR/DATA/Caltech/UsaTest/ev-' common '.mat'];
stra=common; 
stre='';
images = dir(fullfile(imgDir,'*.jpg'));
len = size(images,1);

A = load(['models/' common 'Detector.mat']);
detector = A.detector;
pModify=struct('cascThr',-1,'cascCal',.025);
detector=acfModify(detector,pModify);
dt = cell(1,len);
aspectRatio = .41;
for i = 1:len
    if mod(i,10) == 0, disp([i len]); end
    fileName = images(i).name;
    in  = [imgDir '/' fileName];
    I = imread(in);
    bboxes = acfDetect(I,detector);
    bboxes=bbApply('resize',bboxes,0,0,aspectRatio); 
    dt{i}=bboxes;
end

save(saveName,'dt','-v6');

gt =  load('/Users/shiyuhuang/Downloads/ATOCAR/DATA/Caltech/UsaTest/gt-Reasonable.mat');
gt = gt.gt;
dt = load(saveName);
dt = dt.dt;

thr = 0.5;
[gt,dt] = bbGt('evalRes',gt,dt,thr,0);
[xs,ys] = bbGt('compRoc',gt,dt,1);
 ys = 1 - ys;
 plot(xs,ys,'LineWidth',3);
 set(gca,'XScale','log','YScale','log',...
        'XMinorGrid','on','XMinorTic','on',...
        'YMinorGrid','on','YMinorTic','on');
    title('ROC');
    xlim([0 10]);
    ylim([0 1]);
    xlabel('false positives per image','FontSize',14);
    ylabel('miss rate','FontSize',14);
    legend(stra);


R=struct('stra',stra,'stre',stre,'gtr',{gt},'dtr',{dt});
save(evasaveName,'R');
