close all;
clear all;
clc;
img=imread('brain21.jpg');

%image thresholding
bw=im2bw(img,0.7);

%Labelling
label=bwlabel(bw);

%to select the areas in the image
%Solidity: Sol of tumour >>> Sol of brain
stats=regionprops(label,'Solidity','Area');

density=[stats.Solidity];
area=[stats.Area];

%Area that has 50 percent solidity than the brain
high_dense_area=density>0.5;

%Calculate the max area
max_area=max(area(high_dense_area));

%Find the area when area == max area
tumor_label=find(area==max_area);

%We want tumor to be the member of the label and the tumour label
tumor=ismember(label,tumor_label);

%Dilation -> Tumour is all filled with the same value
%Sometimes you can see the small pixels within the tumour
se=strel('square',5);
tumor=imdilate(tumor,se);

figure(2);
subplot(1,3,1);
imshow(img,[]);
title('Brain');

subplot(1,3,2);
imshow(tumor,[]);
title('Tumor Alone');

%Boundaries around the tumour
[B,L]=bwboundaries(tumor,'noholes');
subplot(1,3,3);
imshow(img,[]);
hold on
%Boiler plate
for i=1:length(B)
    plot(B{i}(:,2),B{i}(:,1), 'y' ,'linewidth',1.45);    
end
title('Detected Tumor');
hold off;
    