tic

%% starting session

% define the path of folders
folder_path = '/Volumes/wuccistaff/Mike/Mast_Lab/';
input_folder = 'raw_output_ometif';
output_folder = 'raw_test_output_crop_2';
input = dir(fullfile(folder_path, input_folder));
filenames = {input.name}';

%% remove hidden files
regexp_crit = '^[^.]+';
rxResult = regexp(filenames, regexp_crit);
nodot = (cellfun('isempty', rxResult)==0); % convert to logicals
filenames_nodot = filenames(nodot); 

%% initiate parfor 

% ver distcomp
% parpool('local',6)

%% image processing
for n = 60:size(filenames_nodot, 1)
    %% load img through bio-format
    % create file list for each file
    img_file = fullfile(folder_path, input_folder, filenames_nodot(n));
    img_file = char(img_file); 
    disp(img_file);    
    
    data = bfopen(img_file);
    
    img_1 = double(data{1, 1}{1, 1});
    img_2 = double(data{1, 1}{2, 1});
    img_3 = double(data{1, 1}{3, 1});   
    
    %% segementation
    
    A = (img_1+img_2+img_3)./3;
    A = uint16(A);
        
    BW = imbinarize(A, isodata(A)*0.3);
    BW = bwareafilt(BW, 1,'largest');   
    BW = imfill(BW,'holes');
    se = strel('disk',2, 0);
    BW = imdilate(BW, se);
    
    img_1_seg = img_1.*BW; 
    img_2_seg = img_2.*BW;
    img_3_seg = img_3.*BW;
    
    %% crop the image
    
    stats = regionprops(BW, 'BoundingBox');
    BW_crop = imcrop(BW, stats.BoundingBox);
    img_1_crop = imcrop(img_1_seg, stats.BoundingBox);
    img_2_crop = imcrop(img_2_seg, stats.BoundingBox);
    img_3_crop = imcrop(img_3_seg, stats.BoundingBox);
    
    img_1_crp = uint16(img_1_crop); 
    img_2_crp = uint16(img_2_crop); 
    img_3_crp = uint16(img_3_crop); 
    
    img_1_crp_rt = imrotate(img_1_crp, 90, 'loose');
    img_2_crp_rt = imrotate(img_2_crp, 90, 'loose');
    img_3_crp_rt = imrotate(img_3_crp, 90, 'loose');
    
    %% write tiff
    
    img_data_com_3 = cat(3, img_1_crp_rt, img_2_crp_rt, img_3_crp_rt);
    
    output_filename = strrep(filenames_nodot(n), '.ome.tiff', '.tif');
    output_filename = strrep(output_filename, 'OME TIFF', 'TIFF');
    img_file_output = fullfile(folder_path, output_folder, output_filename);
    img_file_output = char(img_file_output); 
    disp(img_file_output);
    
    clear options; 
    
    writeTIFF(img_data_com_3, img_file_output);
    
    
end

% delete(gcp('nocreate'));

toc 