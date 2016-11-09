p = genpath('../toolbox');
addpath(p);
clear all;
% cd = '../../DATA/syntheticData/new/testCropped/';
cd = '../../DATA/dangerousFinal/test/';
methodName = 'LdcfCaltech';
D = load( ['../toolbox/detector/models/' methodName 'Detector.mat']);
images = dir(fullfile(cd,'*.jpg'));
len = size(images,1);
outPath = ['result/' methodName '_danTest/imgResult/'];
if (exist(outPath,'dir')),
   rmdir(outPath,'s'); 
end
mkdir(outPath);

bboutDir = ['result/' methodName '_danTest/bbout/'];
if (exist(bboutDir,'dir')),
   rmdir(bboutDir,'s'); 
end
mkdir(bboutDir);
% opts=acfTrain(); opts.modelDs=[c]; opts.modelDsPad=[128 64];
% opts.nWeak=[32 c8];
% opts.pJitter=struct('cflip',1);
% opts.pBoost.pc
% 
% load ./models/AcfInriaDetector.mat;
% pModify=struct('cascThr',-1,'cascCal',.01);
% detector=acfModify(detector,pModify);
% [miss,~,gt,dt]=acfTest('name','./models/AcfInria','imgDir',cd,...
%   'gtDir','/home/intern/Desktop/ATOCAR/DATA/INRIAPerson/test/images','pLoad',opts.pLoad,...
%   'pModify',pModify,'reapply',0,'show',2);
% load ./models/SyntheticOriginDetector.mat;

detector = D.detector;
pModify=struct('cascThr',-1,'cascCal',.025);
detector=acfModify(detector,pModify);
for i = 1:len
    fileName = images(i).name;
    in  = [cd '/' fileName];
    disp(i);
    disp([methodName '   ' in])
    I = imread(in);
    bboxes = acfDetect(I,detector);
    [~,nameNow,~] = fileparts(fileName);
    saveBBX(bboxes,[bboutDir '/' nameNow '.txt']);
    
%     figure('visible','off'); 
%     im(I); 
%     bbApply('draw',bboxes);
%     out = [outPath '/' fileName];
%     saveas(gcf,out);
end


