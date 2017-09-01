%% use matlab display multi-channel tiff files

% load colormap
load('colormaps.mat', 'colormap_3c'); 
cmap_blue = colormap_3c{1};
cmap_green = colormap_3c{2};
cmap_red = colormap_3c{3};

% if (exist('img_data_com_2') == 0)
%     img_data_com_2 = {img_1_crp_rt, img_2_crp_rt};
% end

if (exist('img_data_com_3') == 0)
    img_data_com_3 = {img_1_crp_rt, img_2_crp_rt, img_3_crp_rt};
end

c1 = imshow(img_data_com_3{1}, cmap_blue);

hold on
c2 = imshow(img_data_com_3{2}, cmap_green);

c3 = imshow(img_data_com_3{3}, cmap_red);

% cmap = [cmap_blue; cmap_green; cmap_red];
% colormap(cmap); 
hold off
set(c2, 'AlphaData', img_data_com_3{2});
set(c3, 'AlphaData', img_data_com_3{3});

impixelinfo;