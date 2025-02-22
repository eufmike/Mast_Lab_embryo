%{
WUCCI Mike Shih
This is a test code for basic image processing. The purpose de

%}
%tic
clear

channel_counts = 3;
unit = round(1/3, 2);

%% run through image() function

img_channel_1 = imread('/Volumes/wuccistaff/Mike/Mast_Lab/output_tif/1979a-0002.czi #01.tif',1); 
colormap(gray);

img_channel_2 = imread('/Volumes/wuccistaff/Mike/Mast_Lab/output_tif/1979a-0002.czi #01.tif',2); 
colormap(gray);

img_channel_3 = imread('/Volumes/wuccistaff/Mike/Mast_Lab/output_tif/1979a-0002.czi #01.tif',3);


pos1 = [0 unit*2 unit unit];
subplot('Position',pos1)
imshow(img_channel_1);

pos3 = [0 unit unit unit];
subplot('Position',pos3)
imshow(img_channel_2);

pos5 = [0 0 unit unit];
subplot('Position',pos5)
imshow(img_channel_3);


%% run the Sobel Edge filter
% B=sobel_edge(A);
% pos2 = [0.5 0.5 0.5 0.5];
% subplot('Position',pos2)
% imshow(B);
% 
% 
% %% use isodata() as thresholding strategy 
% BW = imbinarize(B, isodata(B)*1.6);
% pos3 = [0 0 0.5 0.5];
% subplot('Position',pos3)
% imshow(BW);
% 
% 
% 
% %% manipulate binary
% se = strel('disk',2,0);
% BW_dilated = imdilate(BW, se);
% 
% se = strel('disk',1,0);
% 
% BW_eroded = imerode(BW_dilated, se);
% toc

%%
% 
% B = 1 - BW_dilated; 
% pos4 = [0.5 0 0.5 0.5];
% subplot('Position',pos4)
% imshow(B);
% impixelinfo;

%% findedge

edgeim_1 = edge(img_channel_1, 'canny', [0.07, 0.1], 2);
pos2 = [unit unit*2 unit unit];
subplot('Position',pos2);
imshow(edgeim_1)

edgeim_2 = edge(img_channel_2, 'canny', [0.07, 0.1], 2);
pos4 = [unit unit unit unit];
subplot('Position',pos4);
imshow(edgeim_2)

edgeim_3 = edge(img_channel_3, 'canny', [0.03, 0.1], 2);
pos4 = [unit 0 unit unit];
subplot('Position',pos4);
imshow(edgeim_3)



%% binary operation
se = strel('disk',4,0);
dilated_2 = imdilate(edgeim_2, se);
dilated_3 = imdilate(edgeim_3, se);

edge_merge = bitand(dilated_2, dilated_3);
edge_merge = imerode(edge_merge, strel('disk', 1, 0));
figure 
imshow(edge_merge);

% dilatedImage = imdilate(C, strel('disk',2 ));

edge_cleaned = bwareaopen(edge_merge, 2000);
% thinedImage = bwmorph(C,'thin',inf);

edge_cleaned = imcomplement(edge_cleaned);
figure 
imshow(edge_cleaned);
impixelinfo;


%% keep big area

big_area = bwareafilt(edge_cleaned, 21,'largest');
big_area = bwareafilt(big_area, 20,'smallest');
figure 
imshow(big_area);


%% edgelink.m
% 
% [edgelist, labelededgeim] = edgelink(C, 10);
% 
% 
% drawedgelist(edgelist, size(A), 1, 'rand', 2); axis off  

%% BW statistic s
stats = regionprops('table', big_area, 'Centroid', 'Eccentricity');
C = sortrows(stats, 'Eccentricity');
C
centroids = stats.Centroid; 
centroids

figure 
imshow(big_area);
hold on
scatter(centroids(:, 1), centroids(:, 2)) ;
hold off

BW2 = bwpropfilt(big_area,'Eccentricity',5, 'smallest');
figure 
imshow(BW2);

impixelinfo;