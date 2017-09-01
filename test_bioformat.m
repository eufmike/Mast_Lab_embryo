%% starting session
% import bio-format toolbox
addpath('/Applications/MATLAB_R2016a.app/toolbox/bfmatlab')

% define folder path
folder_path = '/Users/michaelshih/Documents/wucci_data/Mast Lab/';
folder = 'raw_test';
full_folder_path = fullfile(folder_path, folder); 
filenames = dir(full_folder_path);

%% load img by bio-format

for n = 1:1
    n = n + 2;
    n
    
    % create directory for each file
    img_file = fullfile(folder_path, folder, filenames(n).name);
    disp(img_file);
   
    
    if (exist('data') == 0) 
        
        data = bfopen(img_file); 
    end    
    
    img_1 = double(data{1, 1}{1, 1});
    img_2 = double(data{1, 1}{2, 1});
    img_3 = double(data{1, 1}{3, 1});   
    
    A = (img_1+img_2+img_3)./3;
    A = uint16(A);
    %imshow(A); 
    
    %% segementation
    
    if (exist('BW') == 0) 
        
        BW = imbinarize(A, isodata(A)*0.3);
        BW = bwareafilt(BW, 1,'largest');   
        BW = imfill(BW,'holes');
        se = strel('disk',2, 0);
        BW = imdilate(BW, se);
        %figure
        %imshow(BW);
    end  
    
    
    
    %% crop the image
    
    stats = regionprops(BW, 'BoundingBox');
    BW_crop = imcrop(BW, stats.BoundingBox);
    img_1_crop = imcrop(img_1, stats.BoundingBox);
    img_2_crop = imcrop(img_2, stats.BoundingBox);
    img_3_crop = imcrop(img_3, stats.BoundingBox);
    
    img_1_crp = uint16(img_1_crop); 
    img_2_crp = uint16(img_2_crop); 
    img_3_crp = uint16(img_3_crop); 
    
    img_1_crp_rt = imrotate(img_1_crp, 90, 'loose');
    img_2_crp_rt = imrotate(img_2_crp, 90, 'loose');
    img_3_crp_rt = imrotate(img_3_crp, 90, 'loose');
    
    figure
    imshow(img_1_crp_rt);colormap(blue); 
    figure
    imshow(img_2_crp_rt);
    figure
    imshow(img_3_crp_rt);
%     figure
%     imshow(img_1_crop); colormap(blue); 
%     
%     hold on
%     imshow(img_2_crop); colormap(green);
%     imshow(img_3_crop); colormap(red);
%     hold off
    
%     imwrite(img_1_crop, img_2_crop, img_3_crop, 'file.tiff', 'writemode', 'append');
end

impixelinfo;