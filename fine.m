p = genpath('../toolbox');
addpath(p);
p = genpath('../../DATA/code3.2.1');
addpath(p);
clear all;

% load models/ImpAndRealDetector.mat
load models/synAllDetector.mat

fid1=fopen('configure/train.cfg');
dataDir=fgetl(fid1);

modelName=fgetl(fid1);
trainLoad = fgetl(fid1);
fclose(fid1);

opts=acfTrain(); 
opts.modelDs=[50 20.5]; 
opts.modelDsPad=[64 32];
opts.pPyramid.pChns.pColor.smooth=0; 
opts.nWeak=[64 256 1024 4096];
opts.pBoost.pTree.maxDepth=5; 
opts.pBoost.discrete=0;
opts.pBoost.pTree.fracFtrs=1/16; 
opts.nNeg=25000; 
opts.nAccNeg=50000;
opts.pPyramid.pChns.pGradHist.softBin=1; 
opts.pJitter=struct('flip',1);
opts.posGtDir=[dataDir 'train' '/annotations'];
opts.posImgDir=trainLoad;
opts.pPyramid.pChns.shrink=2; 
opts.name=modelName;
pLoad={'lbls',{'person'},'ilbls',{'people'},'squarify',{3,.41}};
opts.pLoad = [pLoad 'hRng',[50 inf], 'vRng',[1 1] ];

detector = acfFine( opts , detector );

pModify=struct('cascThr',-1,'cascCal',.025);
detector=acfModify(detector,pModify);