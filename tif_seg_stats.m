tic

%% starting session
% import bio-format toolbox
addpath('/Applications/MATLAB_R2016a.app/toolbox/bfmatlab')

% define the path of folders
folder_path = '/Users/michaelshih/Documents/wucci_data/Mast Lab/';
input_folder = 'raw_test';
output_folder = 'raw_test_output';
filenames = dir(fullfile(folder_path, input_folder));
