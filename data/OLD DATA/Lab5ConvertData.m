% EAS4810C Lab 5
% Convert all raw data to one single .mat file

clc; clear;

files = dir('*.txt');

for i=1:length(files)
    load(files(i).name, '-ascii');
end

clear i files;

save('Lab5Data.mat')