clear all
close all
p = genpath('../toolbox');
addpath(p);

fid1=fopen('draw.cfg');
groundtruth = '';
testFiles={};
testNames={};
i = 0;
while ~feof(fid1)
    aline=fgetl(fid1);
    if i == 0,
        groundtruth = aline;
    else
       strs = regexp(aline, ' ', 'split');
       testFiles{i} = strs{1}; 
       testNames{i} = strs{2};
    end
    i=i+1;
end
fclose(fid1);
pLoad={'lbls',{'person'},'ilbls',{'people'}};
[gt,dt] = bbGt( 'myLoadAll', groundtruth,testFiles{1},pLoad);

thr = 0.5;
[gt,dt] = bbGt('evalRes',gt,dt,thr,0);

[fp,tp] = bbGt('compRoc',gt,dt,1);

figure(1); plotRoc([fp tp]);
title('roc');
