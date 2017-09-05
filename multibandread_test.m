% folder_path = '/Users/michaelshih/Documents/wucci_data/Mast Lab/';
% folder = 'raw_test';
% full_folder_path = fullfile(folder_path, folder); 
% filenames = dir(full_folder_path);
% 
% for n = 1:1
% 
%     img_file = fullfile(folder_path, folder, filenames(n).name);
%     disp(img_file);
%     
%     iminfo = imfinfo(img_file);
%     truecolor = multibandread(compositeimage, [1281, 620, 6], 'uint8=>uint8', ...
%                           8,  'bip', 'ieee-le', {'Band','Direct',[4 3 2]});
%     imshow(truecolor);
% 
% end

truecolor = multibandread(colormap_3c, [13481, 13546, 3])