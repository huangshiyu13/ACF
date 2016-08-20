% Demo for aggregate channel features object detector on Caltech dataset.
%
% See also acfReadme.m
%
% Piotr's Computer Vision Matlab Toolbox      Version 3.40
% Copyright 2014 Piotr Dollar.  [pdollar-at-gmail.com]
% Licensed under the Simplified BSD License [see external/bsd.txt]

%% extract training and testing images and ground truth

p = genpath('../toolbox');
addpath(p);
p = genpath('../../DATA/code3.2.1');
addpath(p);
clear all;

fid1=fopen('configure/train.cfg');

dataDir=fgetl(fid1);%'../../DATA/dangerous/';
testDir = fgetl(fid1);%'../../DATA/Caltech/';
modelName=fgetl(fid1);
trainLoad = fgetl(fid1);%'configure/trainFileLoad.cfg'
fclose(fid1);
% for s=1:2
%   if(s==1), type='test'; skip=[]; else type='train'; skip=4; end
%   dbInfo(['Usa' type]); 
%   if(s==2), type=['train' int2str2(skip,2)]; end
%   if(exist([dataDir type '/annotations'],'dir')), continue; end
%   dbExtract([dataDir type],1,skip);
% end

%% set up opts for training detector (see acfTrain)
if(1),
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
opts.name=modelName;%'models/dangerous';
pLoad={'lbls',{'person'},'ilbls',{'people'},'squarify',{3,.41}};
opts.pLoad = [pLoad 'hRng',[50 inf], 'vRng',[1 1] ];
% opts=acfTrain(); 
% opts.modelDs=[100 100]; 
% opts.modelDsPad=[128 128];
% opts.posGtDir=[dataDir 'train' '/annotations']; 
% opts.nWeak=[32 128 512 2048];
% opts.posImgDir=[dataDir 'train' '/images']; 
% opts.pJitter=struct('flip',1);
% opts.nNeg=25000; 
% opts.nAccNeg=50000;
% opts.pBoost.pTree.fracFtrs=1/16;
% opts.pLoad={'squarify',{3,.41}};
% opts.name='models/SynthticTest';

%% train detector (see acfTrain)
detector = acfTrain( opts );

%% modify detector (see acfModify)

else
%        load models/AcfCaltechPureOriginDetector.mat;
%       load models/SynthticTestDetector.mat;  
%     load ../toolbox/detector/models/SynthticDetector.mat;
%     load models/AcfInriaDetector.mat
% load models/AcfCaltech+Detector.mat
load models/SyntheticSquareDetector.mat
end
%% run detector on a sample image (see acfDetect) 
%pModify=struct('cascThr',-1,'cascCal',.01);
pModify=struct('cascThr',-1,'cascCal',.025);
detector=acfModify(detector,pModify);

% imgNms=bbGt('getFiles',{[testDir 'test/images']});
% for i = 1:size(imgNms,2)
% I=imread(imgNms{i}); 
% tic, bbs=acfDetect(I,detector); toc
% figure(i); 
% im(I); 
% bbApply('draw',bbs); 
% pause(.1);
% end
