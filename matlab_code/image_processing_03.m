% By: Mike Shih
% This is a test code for extracting the brain region from images captured by
% Zeiss AxioScan. 

 
%tic

clear
channel_counts = 3;
unit = round(1/3, 2);
troubleshooting = 1;

%% Define the path of folders
folder_path = '/Users/michaelshih/Dropbox/WUCCI_dropbox/Mast_lab';
input_folder = 'raw_test_resized'; % specify the input folder
output_folder = 'raw_test_output'; % specify the output folder
bw_output_folder = 'raw_test_output_bw';
rgb_output_folder = 'raw_test_output_rgb';

input = dir(fullfile(folder_path, input_folder));
filenames = {input.name}'; % get filenames

%% Remove hidden files (any filenames start with ".").  
regexp_crit = '^[^.]+'; % the pattern of general expression
rxResult = regexp(filenames, regexp_crit); % pick the string follow the rule
nodot = (cellfun('isempty', rxResult)==0); % convert to logicals
filenames_nodot = filenames(nodot); % use logicals select filenames

%% run through image() function
for n = 6:6
%for n = 1:size(filenames_nodot, 1)  
    
    close all
    
    %% load img through bio-format
    % create file list for each file
    img_file = fullfile(folder_path, input_folder, filenames_nodot(n));
    img_file = char(img_file); 
    disp(img_file);    
    
    data = bfopen(img_file);
    
    expandsize = [10, 10];
    img_1 = double(data{1, 1}{1, 1});
    img_1 = padarray(img_1, expandsize, 0, 'both'); % expend the canvas
    
    img_2 = double(data{1, 1}{2, 1});
    img_2 = padarray(img_2, expandsize, 0, 'both');
    
    img_3 = double(data{1, 1}{3, 1});  
    img_3 = padarray(img_3, expandsize, 0, 'both');
    
    %% generate a binary for the whole tissue
    img_total = (img_1+img_2+img_3)./3;
    img_total = uint16(img_total);
    if troubleshooting == 1
        figure; 
        imshow(img_total, []); 
        set(gca,'FontSize', 10);
        title('raw\_3colo\_mix');
    end
    
    BW = imbinarize(img_total, isodata(img_total)*0.3);
    BW = bwareafilt(BW, 1,'largest');   
    BW = imfill(BW,'holes');
    se = strel('disk',2, 0);
    BW = imdilate(BW, se);
    
    %imshow(BW);
    stats_total = regionprops(BW, 'BoundingBox');
    mid_x = stats_total.BoundingBox(3)/2 + stats_total.BoundingBox(1); 
    mid_y = stats_total.BoundingBox(4)/2 + stats_total.BoundingBox(2);
    
    %% plot image

    %pos1 = [0 unit*2 unit unit];
    %subplot('Position',pos1)
    %imshow(img_1, []);

    %pos3 = [0 unit unit unit];
    %subplot('Position',pos3)
    %imshow(img_2, []);

    %pos5 = [0 0 unit unit];
    %subplot('Position',pos5)
    %imshow(img_3, []);

    %% findedge in all three channel

    %edgeim_1 = edge(img_1, 'canny', [0.07, 0.1], 2);
    %pos2 = [unit unit*2 unit unit];
    %subplot('Position',pos2);
    %imshow(edgeim_1, [])

    %edgeim_2 = edge(img_2, 'canny', [0.07, 0.1], 2);
    %pos4 = [unit unit unit unit];
    %subplot('Position',pos4);
    %imshow(edgeim_2, [])

    %edgeim_3 = edge(img_3, 'canny', [0.03, 0.1], 2);
    %pos4 = [unit 0 unit unit];
    %subplot('Position',pos4);
    %imshow(edgeim_3, [])

    
    %% binary operation for brain area (potential better strategy)
    bw_gray_2 = edge_merge(img_2);
    bw_gray_th_2 = im2bw(bw_gray_2, 0.1);
    
    bw_gray_3 = edge_merge(img_3);
    bw_gray_th_3 = im2bw(bw_gray_3, 0.1);

    bw_edgemerge = bitand(bw_gray_th_2, bw_gray_th_3);
    
    if troubleshooting == 1, 
        figure; 
        imshow(bw_edgemerge, []);
        set(gca,'FontSize', 10);
        title('edge\_BW');
    end

    %% clean edge
    edge_cleaned = bwareaopen(bw_edgemerge, 500);
    se = strel('disk',1,0);
    edge_cleaned = imdilate(edge_cleaned, se);    
    edge_cleaned = imcomplement(edge_cleaned);
    
    if troubleshooting == 1 
        figure
        imshow(edge_cleaned, []);
        set(gca,'FontSize', 10);
        title('edge\_cleaned');
    end
    
    %% keep biggest 20 area
    big_area = bwareafilt(edge_cleaned, 21,'largest');
    big_area = bwareafilt(big_area, 20,'smallest');
    
    big_area = imfill(big_area, 'holes');
    big_area = bwmorph(big_area,'hbreak');
    
    se = strel('disk',1,0);
    big_area = imerode(big_area, se);
    se = strel('disk',1,0);
    big_area = imdilate(big_area, se);
    
    big_area = bwareafilt(big_area, 20,'largest');
    
    if troubleshooting == 1 
        figure
        imshow(big_area, []);
        set(gca,'FontSize', 10);
        title('before\_statistics');
    end
    
    
    %% BW statistic 
    % use a customized function "extendedproperty" for Circularity,
    % roundness and other factors for evaluation
    stats = extendedproperty(big_area);
    centroids = stats.Centroid;
    bigarea_rgb = outlineoverlap(img_total, big_area);
    
    figure; 
    imshow(bigarea_rgb, []) 
    set(gca,'FontSize', 10);
    title('all\_BW\_number');

    hold on
    for k= 1: height(stats);
        t = text(centroids(k, 1), centroids(k, 2), num2str(k));
        t.Color = 'red';
        t.FontSize = 20;
    end
    hold off
    
    bw_img_file = fullfile(folder_path, bw_output_folder, filenames_nodot(n));
    bw_img_file = char(bw_img_file);
    fig_BW = gcf;
    saveas(fig_BW, bw_img_file); 
    
    %% select based on eccentricity
    BW2 = bwpropfilt(big_area, 'Eccentricity', 5, 'smallest'); % select objects by their eccentricity
    stats = sortrows(stats, 'Eccentricity'); % sort their stats accordingly
    stats_2 = stats(1:5, :);
    centroids = stats_2.Centroid; % return the center
    
    % plot the BW and marker the objects according to their eccentricity
    se = strel('disk',2,0);
    BW2 = imdilate(BW2, se);
    
    BW2_rgb = outlineoverlap(img_total, BW2);
    
    if troubleshooting == 1 
        figure; 
        imshow(BW2_rgb, []) 
        set(gca,'FontSize', 10);
        title('BW2\_after\_Eccentricity');
        
        hold on
        for k= 1: height(stats_2);
            t = text(centroids(k, 1), centroids(k, 2), num2str(k));
            t.Color = 'red';
            t.FontSize = 20;
        end
        hold off
    end

    %% select based on circularity
    stats_3 = extendedproperty(BW2);
    % select the object by their circularity
    cc = bwconncomp(BW2); 
    %L = bwlabel(BW2);
    idx = find([stats_3.Circularity] > 0.05 & [stats_3.Roundness] > 0.6);
    L = labelmatrix(cc);
    BW3 = ismember(L, idx);
    
    stats_3 = extendedproperty(BW3);
    stats_3.idx = (1:height(stats_3))';
    stats_3 = sortrows(stats_3, 'Circularity', 'descend');
    centroids = stats_3.Centroid;
    
    BW3_rgb = outlineoverlap(img_total, BW3);
    
    if troubleshooting == 1 
        figure; 
        imshow(BW3_rgb, []) 
        set(gca,'FontSize', 10);
        title('BW3\_after\_Circularity\_&\_Roundness');
        
        hold on
        for k= 1: height(stats_3);
            t = text(centroids(k, 1), centroids(k, 2), num2str(k));
            t.Color = 'red';
            t.FontSize = 20;
        end
        hold off
    end
    
    
    %% select the region based on the midline
    stats_3.distance_mid_x = abs(stats_3.Centroid(:, 1) - mid_x);
    stats_3.distance_mid_y = abs(stats_3.Centroid(:, 2) - mid_y);
    stats_3.relative_x_1 = stats_3.BoundingBox(:, 1) - mid_x;
    stats_3.relative_x_2 = stats_3.BoundingBox(:, 1) + stats_3.BoundingBox(3) - mid_x;
    stats_3.relative_y_1 = stats_3.BoundingBox(:, 2) - mid_y;
    stats_3.relative_y_2 = stats_3.BoundingBox(:, 2) + stats_3.BoundingBox(4) - mid_y;
         
    stats_3 = sortrows(stats_3, 'distance_mid_x');
    stats_4 = stats_3(1:2, :);
    
    idx = stats_4.idx;
    cc = bwconncomp(BW3);
    L = labelmatrix(cc);
    BW4 = ismember(L, idx);
    
    BW4 = imfill(BW4, 'holes');
    
    method = 'Canny';   
    [~, threshold] = edge(BW4, method);
    BW4_edgeim = edge(BW4, method, threshold, 20);  
    se = strel('disk', 11,0);
    BW4_edgeim = imdilate(BW4_edgeim, se);
    BW4_edgeim = imfill(BW4_edgeim,'holes'); 
    
    se = strel('disk', 6, 0);
    BW4_edgeim = imerode(BW4_edgeim, se);
    
    stats_5 = extendedproperty(BW4_edgeim);
    centroids = stats_5.Centroid;
    
    BW4_rgb = outlineoverlap(img_total, BW4_edgeim);
    
   
    figure; 
    imshow(BW4_rgb, []) 
    set(gca,'FontSize', 10);
    title('BW4\_after\_xylocation');

    hold on
    for k= 1: height(stats_4);
        t = text(centroids(k, 1), centroids(k, 2), num2str(k));
        t.Color = 'red';
        t.FontSize = 20;
    end
    hold off
    
    rgb_img_file = fullfile(folder_path, rgb_output_folder, filenames_nodot(n));
    rgb_img_file = char(rgb_img_file);
    fig_BW4 = gcf;
    saveas(fig_BW4, rgb_img_file);
    
    impixelinfo;
    

end

if troubleshooting == 0, close all; end

