%% Specify folder

filenames = dir('output_tif');
folder_path = '/Volumes/wuccistaff/Mike/Mast_Lab/';
folder = 'output_tif';

channel_counts = 3;
unit = round(1/3, 2);

%% Image processing

for n = 1:3 %% n = 1:size(filenames)
    n = n+2;
    
    img_file = fullfile(folder_path, folder, filenames(n).name);
    disp(img_file);%% print out file names
    
    img_channel_1 = imread(img_file,1); 
    colormap(gray);
    img_channel_2 = imread(img_file,2); 
    colormap(gray);
    img_channel_3 = imread(img_file,3);
    colormap(gray);
    
    pos1 = [0 unit*2 unit unit];
    subplot('Position',pos1)
    imshow(img_channel_1);    
    
    pos3 = [0 unit unit unit];
    subplot('Position',pos3)
    imshow(img_channel_2);

    pos5 = [0 0 unit unit];
    subplot('Position',pos5)
    imshow(img_channel_3);
    
    figure
    
end

impixelinfo;