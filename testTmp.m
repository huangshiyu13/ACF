p = genpath('../toolbox');
addpath(p);
clear all;

cd = '../../DATA/dangerous/resized/';
methodName = 'Caltech2500';
D = load( ['models/' methodName 'Detector.mat']);
methodName = [methodName 'Test'];
images = dir(fullfile(cd,'*.jpg'));
len = size(images,1);
outPath = ['result/' methodName '/imgResult/'];
if (exist(outPath,'dir')),
   rmdir(outPath,'s'); 
end
mkdir(outPath);


detector = D.detector;
pModify=struct('cascThr',-1,'cascCal',.01);
detector=acfModify(detector,pModify);
for i = 1:len
    fileName = images(i).name;
    fileName
    in  = [cd '/' fileName];
    out = [outPath '/' fileName];
    I = imread(in);
    
    bboxes = acfDetect(I,detector);
    
    figure('visible','off'); 
    im(I); 
    bbApply('draw',bboxes);
    saveas(gcf,out);
end