tic

%% starting session
% define the path of folders
folder_path = '/Users/michaelshih/Documents/wucci_data/Mast Lab/';
input_folder = 'raw_test_output';
output_folder = 'tiff_BW_stat';
input = dir(fullfile(folder_path, input_folder));
filenames = {input.name}';

%% remove hidden files
regexp_crit = '^[^.]+';
rxResult = regexp(filenames, regexp_crit);
nodot = (cellfun('isempty', rxResult)==0); % convert to logicals
filenames_nodot = filenames(nodot); 


%% image processing
for n = 1:size(filenames_nodot, 1)
    
    %% load img through bio-format
    % create file list for each file
    img_file = fullfile(folder_path, input_folder, filenames_nodot(n));
    img_file = char(img_file); 
    disp(img_file);
    
    data = bfopen(img_file); 
    
    img_1 = double(data{1, 1}{1, 1});
    img_2 = double(data{1, 1}{2, 1});
    img_3 = double(data{1, 1}{3, 1});  
    
    
    %% resize

    img_1_crp = uint16(imresize(img_1, 0.1));
    img_2_crp = uint16(imresize(img_2, 0.1));
    img_3_crp = uint16(imresize(img_3, 0.1));
    
    %% save file
    img_data_com_3 = cat(3, img_1_crp, img_2_crp, img_3_crp);
    
    output_filename = strrep(filenames_nodot(n), '.ome.tiff', '.tif');
    output_filename = char(output_filename);
    img_file_output = fullfile(folder_path, output_folder, output_filename);
    disp(img_file_output);
    saveastiff(img_data_com_3, img_file_output);
    
end

toc
