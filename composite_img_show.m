% by Mike Shih

%% use matlab display multi-channel tiff files
% dependent: grs2rgb(); im2uint8();

%% load image 

if (exist('img_data_com_3') == 0)
    img_data_com_3 = {img_1_crp_rt, img_2_crp_rt, img_3_crp_rt};
    end

%% load colormap
load('colormaps.mat', 'colormap_3c'); 
cmap_blue = colormap_3c{1};
cmap_green = colormap_3c{2};
cmap_red = colormap_3c{3};
cmap_yellow = colormap_3c{4};
cmap_cyan = colormap_3c{5};
cmap_magenta = colormap_3c{6};

%% convert image to 8-bit RGB images

C1 = img_data_com_3{1}; 
C1_uint8 = im2uint8(C1); 
C1_uint8_rgb = grs2rgb(C1_uint8, cmap_blue);

C2 = img_data_com_3{2}; 
C2_uint8 = im2uint8(C2); 
C2_uint8_rgb = grs2rgb(C2_uint8, cmap_green);

C3 = img_data_com_3{3}; 
C3_uint8 = im2uint8(C3); 
C3_uint8_rgb = grs2rgb(C3_uint8, cmap_red);

%% composite multi-color images

composite_R = cat(3, C1_uint8_rgb(:,:,1), C2_uint8_rgb(:,:,1), C3_uint8_rgb(:,:,1));
composite_R_max = max(composite_R, [], 3);

composite_G = cat(3, C1_uint8_rgb(:,:,2), C2_uint8_rgb(:,:,2), C3_uint8_rgb(:,:,2));
composite_G_max = max(composite_G, [], 3);

composite_B = cat(3, C1_uint8_rgb(:,:,3), C2_uint8_rgb(:,:,3), C3_uint8_rgb(:,:,3));
composite_B_max = max(composite_B, [], 3);

composite = cat(3, composite_R_max, composite_G_max, composite_B_max);
imshow(composite);

impixelinfo;