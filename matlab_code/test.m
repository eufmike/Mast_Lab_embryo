url = 'http://blogs.mathworks.com/images/steve/2013/blobs.png';
bw = imread(url);
L = watershed(bw);
Lrgb = label2rgb(L);
imshow(Lrgb)

%% binary saving test
imwrite(BW4, 'test.tif');

%% figure saving test
fig = gcf;
saveas(fig,'fig.png');

%% convolution test
close all;
%smooth
blurredimg_2 = im_smooth(img_2);
figure
imshow(blurredimg_2, []);

blurredimg_3 = im_smooth(img_3);
figure
imshow(blurredimg_3, []);

blurredimg_2_edge = edge_merge(blurredimg_2, 1);
blurredimg_3_edge = edge_merge(blurredimg_3, 1);

blurredimg_edge = blurredimg_2_edge + blurredimg_3_edge;
figure
imshow(blurredimg_edge, []);

blurredimg_edge_th = im2bw(blurredimg_edge, 0.2);
figure
imshow(blurredimg_edge_th, []);

%%
se = strel('disk',2,0);
edge_cleaned = imdilate(blurredimg_edge_th, se);    
edge_cleaned = imcomplement(edge_cleaned);
edge_cleaned = bwareaopen(edge_cleaned, 500);
figure
imshow(edge_cleaned, []);
impixelinfo; 

big_area = bwareafilt(edge_cleaned, 21,'largest');
    big_area = bwareafilt(big_area, 20,'smallest');
    
    if troubleshooting == 1 
        figure
        imshow(big_area, []);
        set(gca,'FontSize', 10);
        title('before\_statistics\_01');
    end
    
    % refine BW
    big_area = imfill(big_area, 'holes');
    
    if troubleshooting == 1 
        figure
        imshow(big_area, []);
        set(gca,'FontSize', 10);
        title('before\_statistics\_02');
    end

    
% bw_gray_th_2 = im2bw(bw_gray_2, 0.13);
% figure
% imshow(bw_gray_th_2, []);   
% 
% bw_gray_th_3 = im2bw(bw_gray_3, 0.13);
% figure
% imshow(bw_gray_th_3, []);
% 
% bw_edgemerge = bitand(bw_gray_th_2, bw_gray_th_3);

%% BW

stats_big_area = extendedproperty(big_area);
n = height(stats_big_area);
stats_big_area.idx = (1:height(stats_big_area))';

cc = bwconncomp(big_area); 
L = labelmatrix(cc);

img = [],
for i = 1:n
    close all;
    temp_img = ismember(L, i);
    img = cat(3, img, temp_img);
end

imgsmooth = [];

for i = 1:n
    close all;
    temp_img = img(:, :, i);
    
    method = 'Canny';   
    [~, threshold] = edge(temp_img, method);
    temp_img_edgeim = edge(temp_img, method, threshold, 30);  
    se = strel('disk', 5,0);
    temp_img_edgeim = imdilate(temp_img_edgeim, se);    
    temp_img_edgeim = imfill(temp_img_edgeim,'holes'); 
    se = strel('disk', 3,0);
    temp_img_edgeim = imerode(temp_img_edgeim, se);
    imgsmooth = cat(3, imgsmooth, temp_img_edgeim);
    figure
    imshow(imgsmooth(:, :, i));
end 

%% test on table
n = size(imgsmooth, 3);
stat_total = {}; 
img = imgsmooth(:, :, 1);

stats = regionprops('table', imgsmooth, 'all');
stats.Circularity = (4*pi*stats.Area)./((stats.Perimeter).^2);
stats.Aspectratio = stats.MajorAxisLength./stats.MinorAxisLength; 
stats.Roundness = (4*stats.Area)./(pi*(stats.MajorAxisLength).^2);
table_name = get(stats, 'columnname');

for i = 1:n
    img = imgsmooth(:, :, i);
    stats = regionprops('table', imgsmooth, 'all');
    stats.Circularity = (4*pi*stats.Area)./((stats.Perimeter).^2);
    stats.Aspectratio = stats.MajorAxisLength./stats.MinorAxisLength; 
    stats.Roundness = (4*stats.Area)./(pi*(stats.MajorAxisLength).^2);
    
    stats_1 = cat(stats_1, stats);
end

%%

%find(filenames, '1979a-0008-.tif-Export-07_s2')

regexp_crit = '1979a-0007-.tif-Export-06_s1'; % the pattern of general expression
rxResult = regexp(filenames_nodot, regexp_crit); % pick the string follow the rule
nodot = (cellfun('isempty', rxResult)==0); % convert to logicals
index = find(nodot);
index

