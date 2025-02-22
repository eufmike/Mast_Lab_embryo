% By: Mike Shih
% This is a test code for extracting the brain region from images captured by
% Zeiss AxioScan. 
 
%tic

clear % remove variables
channel_counts = 3;
unit = round(1/3, 2);

% control the status of image representation
troubleshooting = 1;

%% Define the path of folders
folder_path = '/Volumes/wuccistaff/Mike/Mast_Lab_02/image/';
input_folder = 'raw_test_output_resized'; % specify the input folder
output_folder = 'raw_test_output'; % specify the output folder
raw_BW = 'raw_BW';
raw_BW_smooth = 'raw_BW_smooth';
bw1_output_folder = 'raw_test_output_resized_bw1';
bw2_output_folder = 'raw_test_output_resized_bw2';
stats_raw_folder = 'stats_raw';
stats_smooth_folder = 'stats_smooth';

input = dir(fullfile(folder_path, input_folder));
filenames = {input.name}; % get filenames

%% Remove hidden files (any filenames start with ".") 
regexp_crit = '^[^.]+'; % the pattern of general expression
rxResult = regexp(filenames, regexp_crit); % pick the string follow the rule
nodot = (cellfun('isempty', rxResult)==0); % convert to logicals
filenames_nodot = filenames(nodot); % use logicals select filenames

%% run through image() function
for n = 21:150
%for n = 1:size(filenames_nodot, 1)  
    close all
    clearvars -except n stats_raw_folder stats_smooth_folder raw_BW raw_BW_smooth channel_counts unit troubleshooting folder_path input_folder output_folder bw1_output_folder bw2_output_folder input input filenames regexp_crit rxResult nodot filenames_nodot
    
    display(n);
    %% load img through bio-format
    % create file list for each file
    img_name = filenames_nodot(n);
    img_file = fullfile(folder_path, input_folder, img_name);
    img_file = char(img_file); 
    disp(img_file);    
    data = bfopen(img_file);
    
    img_name = char(img_name);
    img_name_notif = strrep(img_name, '.tif', '');
    
    expandsize = [10, 10];
    img_1 = double(data{1, 1}{1, 1});
    img_1 = padarray(img_1, expandsize, 0, 'both'); % expend the canvas
    
    img_2 = double(data{1, 1}{2, 1});
    img_2 = padarray(img_2, expandsize, 0, 'both');
    
    img_3 = double(data{1, 1}{3, 1});  
    img_3 = padarray(img_3, expandsize, 0, 'both');
    
    %% generate a binary for the whole tissue
    % the bw will be used for identifying the midline
    
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
    
    stats_total = regionprops(BW, 'BoundingBox');
    mid_x = stats_total.BoundingBox(3)/2 + stats_total.BoundingBox(1); 
    mid_y = stats_total.BoundingBox(4)/2 + stats_total.BoundingBox(2);
  
    %% binary operation for brain area (DAPI)
    % use thresholding strategy for defining DAPI positive region
    figure
    imshow(img_1, []);
    BW_DAPI = imbinarize(img_total, isodata(img_total)*0.5); % this is wrong!!!!!
    figure
    imshow(BW_DAPI, []);
    
    %% binary operation for brain area (other channel)
    % use the "edge_merge" function for finding edge 
    % the function merge at least two different edge detection method
    
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
    
    %%
    edge_threshold = 0.1;
    stats_height = 0;
    while stats_height == 0
        
        blurredimg_edge_th = im2bw(blurredimg_edge, edge_threshold);

        if troubleshooting == 1, 
            figure; 
            imshow(blurredimg_edge_th, []);
            set(gca,'FontSize', 10);
            title('edge\_BW');
        end

        %% clean edge
        % refine edge and display
       
        se = strel('disk',4,0);
        edge_cleaned = imdilate(blurredimg_edge_th, se);    
        edge_cleaned = imcomplement(edge_cleaned);
        edge_cleaned = bwareaopen(edge_cleaned, 500);
        edge_cleaned = imclearborder(edge_cleaned); %remove background 

        if troubleshooting == 1 
            figure
            imshow(edge_cleaned, []);
            set(gca,'FontSize', 10);
            title('before\_statistics\_01');
        end
    
        %% merge BW from edge detection and BW from DAPI
        BW_primary = bitand(BW_DAPI, edge_cleaned);       
        % refine BW
        BW_primary = imfill(BW_primary, 'holes'); % fill holes

        % select by size
        stats_BW_primary = extendedproperty(BW_primary); % get stats
        cc = bwconncomp(BW_primary);
        idx_BW_primary = find([stats_BW_primary.Area] > 10000);
        L = labelmatrix(cc);
        BW_primary = ismember(L, idx_BW_primary);

        if troubleshooting == 1 
            figure
            imshow(BW_primary, []);
            set(gca,'FontSize', 10);
            title('before\_statistics\_02');
        end
        
        stats = extendedproperty(BW_primary);
        stats_height = size(stats, 1);
        edge_threshold = edge_threshold - 0.02;
        
    end
    
    %%
    BW_file_name = fullfile(folder_path, raw_BW, img_name_notif);
    BW_file_name = char(BW_file_name);     
    save(strcat(BW_file_name, '.mat'), 'BW_primary');
    
    %% convert BW multi-layer BW
    stats_BW_primary = extendedproperty(BW_primary); % get stats
    m = height(stats_BW_primary);
    stats_BW_primary.idx = (1:height(stats_BW_primary))'; 
    cc = bwconncomp(BW_primary); 
    L = labelmatrix(cc);

    img = [],
    for i = 1:m
        temp_img = ismember(L, i);
        img = cat(3, img, temp_img);
    end
    
    stats_raw = extendedproperty3D(img);
    stats_raw.idx = (1:height(stats_raw))';
    idx_size = find([stats_raw.Area] > 10000);
    
    roi_raw_file_name = fullfile(folder_path, stats_raw_folder, img_name_notif);
    roi_raw_file_name = char(roi_raw_file_name);     
    writetable(stats_raw, strcat(roi_raw_file_name, '.csv')); 
    
%     %% object convex
%     
%     imgconvex = [];
% 
%     for i = 1:m
%         temp_img = img(:, :, i);
%         temp_img_convex = bwconvhull(temp_img, 'objects');
%         imgconvex = cat(3, imgconvex, temp_img_convex);
% %         figure
% %         imshow(imgsmooth(:, :, i));
%     end 
%     
%     maxp = max(imgconvex, [], 3);    
%     
%     if troubleshooting == 1 
%         % implay(imgsmooth);
%         figure
%         imshow(maxp);
%         set(gca,'FontSize', 10);
%         title('before\_statistics\_02\_smooth');
%     end
%     
    %% smooth multi-layer BW
 
    imgsmooth = [];

    for i = 1:m
        temp_img = img(:, :, i);
        se = strel('disk',10);
        temp_img_edgeim = imclose(temp_img, se);
        temp_img_edgeim = imfill(temp_img_edgeim,'holes');
        
        se = strel('disk', 6,0);
        temp_img_edgeim = imdilate(temp_img_edgeim, se);  
        se = strel('disk', 3,0);
        temp_img_edgeim = imerode(temp_img_edgeim, se);
        
        method = 'Canny';   
        [~, threshold] = edge(temp_img_edgeim, method);
        temp_img_edgeim = edge(temp_img_edgeim, method, threshold, 10);
        temp_img_edgeim = imfill(temp_img_edgeim,'holes');
        se = strel('disk', 5,0);
        temp_img_edgeim = imdilate(temp_img_edgeim, se);    
        temp_img_edgeim = imfill(temp_img_edgeim,'holes'); 
        se = strel('disk', 2,0);
        temp_img_edgeim = imerode(temp_img_edgeim, se);
        imgsmooth = cat(3, imgsmooth, temp_img_edgeim);
%         figure
%         imshow(imgsmooth(:, :, i));
    end 
    
    maxp = max(imgsmooth, [], 3);    
    
    if troubleshooting == 1 
        % implay(imgsmooth);
        figure
        imshow(maxp);
        set(gca,'FontSize', 10);
        title('before\_statistics\_02\_smooth');
    end
    
    BW_file_name = fullfile(folder_path, raw_BW_smooth, img_name_notif);
    BW_file_name = char(BW_file_name);     
    save(strcat(BW_file_name, '.mat'), 'BW_primary');
    
    %% BW checkpoint by stats
    
    %% BW statistic & select BW by their size    
    stats = extendedproperty3D(imgsmooth);
    stats.distance_mid_x = abs(stats.Centroid(:, 1) - mid_x);
    stats.distance_mid_y = abs(stats.Centroid(:, 2) - mid_y);
    stats.relative_x_1 = stats.BoundingBox(:, 1) - mid_x;
    stats.relative_x_2 = stats.BoundingBox(:, 1) + stats.BoundingBox(3) - mid_x;
    stats.relative_y_1 = stats.BoundingBox(:, 2) - mid_y;
    stats.relative_y_2 = stats.BoundingBox(:, 2) + stats.BoundingBox(4) - mid_y;
    stats.idx = (1:height(stats))';
    
    BW_size = imgsmooth(:, :, idx_size);
    BW_size_maxp = max(BW_size, [], 3);
    
    %save ROI stats smooth
    roi_smooth_file_name = fullfile(folder_path, stats_smooth_folder, img_name_notif);
    roi_smooth_file_name = char(roi_smooth_file_name);     
    writetable(stats, strcat(roi_smooth_file_name, '.csv')); 
    
    %% Plot Centroid
    centroids = stats.Centroid(idx_size, :);
    
    if troubleshooting == 1 
        figure
        imshow(BW_size_maxp, []);
        set(gca,'FontSize', 10);
        title('BW\_size\_maxp');
        
        hold on
        for k= 1: size(idx_size, 1);
            t = text(centroids(k, 1), centroids(k, 2), num2str(idx_size(k)));
            t.Color = 'red';
            t.FontSize = 20;
        end
        hold off
    end
    
    %% Plot outline
    
    BW_primary_rgb = outlineoverlap3D(img_total, BW_size);
    
    figure; 
    imshow(BW_primary_rgb, []) 
    set(gca,'FontSize', 10);
    title('all\_BW\_number');

    hold on
    for k= 1: size(idx_size,1);
        t = text(centroids(k, 1), centroids(k, 2), num2str(idx_size(k)));
        t.Color = 'red';
        t.FontSize = 20;
    end
    hold off
    
    % save the BW for review
    bw_img_file = fullfile(folder_path, bw1_output_folder, img_name);
    bw_img_file = char(bw_img_file);
    saveas(gcf, bw_img_file); 
    
    %% select based on eccentricity
    
    stats_2 = sortrows(stats, 'Eccentricity'); % sort their stats accordingly
     
    if height(stats_2) < 10,
        m = height(stats_2);
    else 
        m = 10;
    end
    stats_2 = stats_2(1:m, :);
    
    idx_ecc = stats_2.idx;
    
    [tf,loc] = ismember(idx_ecc, idx_size);
    idx_ecc=idx_ecc(tf); 
    
    BW_eccentricity = imgsmooth(:, :, idx_ecc);% select objects by their eccentricity       
    centroids = stats_2.Centroid; % return the center
    
    BW_eccentricity_rgb = outlineoverlap3D(img_total, BW_eccentricity);
    BW_eccentricity_maxp = max(BW_eccentricity, [], 3);
    
    if troubleshooting == 1 
        figure; 
        imshow(BW_eccentricity_maxp, []) 
        set(gca,'FontSize', 10);
        title('BW_eccentricity_maxp');
        
        hold on
        for k= 1: size(idx_ecc,1);
            t = text(centroids(k, 1), centroids(k, 2), num2str(idx_ecc(k)));
            t.Color = 'red';
            t.FontSize = 20;
        end
        hold off
    end

    %% select based on circularity and Roundness
    Roundness_factor = 0.6;
    Circularity_factor = 0.05;
    idx_cir = find([stats.Circularity] > Circularity_factor & [stats.Roundness] > Roundness_factor);
    
    while size(idx_cir, 1) == 0
        Roundness_factor = Roundness_factor - 0.05;
        idx_cir = find([stats.Circularity] > Circularity_factor & [stats.Roundness] > Roundness_factor);
    end
   
    [tf,loc] = ismember(idx_ecc, idx_cir);
    idx_cir=idx_ecc(tf); 
    
    BW_CR = imgsmooth(:, :, idx_cir);       
    centroids = stats.Centroid(idx_cir, :);
    
    BW_CR_rgb = outlineoverlap3D(img_total, BW_CR);
    BW_CR_maxp = max(BW_CR, [], 3);

    
    if troubleshooting == 1 
        figure; 
        imshow(BW_CR_maxp, []) 
        set(gca,'FontSize', 10);
        title('BW\_CR\_maxp');
        
        hold on
        for k= 1: size(idx_cir, 1);
            t = text(centroids(k, 1), centroids(k, 2), num2str(idx_cir(k)));
            t.Color = 'red';
            t.FontSize = 20;
        end
        hold off
    end
    
    
    %% select the region based on their location
    % use the midline of the tissue BW
    % close all;
            
    stats_loc = sortrows(stats, 'distance_mid_x');
    idx_loc = stats_loc.idx;
    [tf,loc] = ismember(idx_loc, idx_cir);
    idx_loc = idx_loc(tf); 
    
    if size(idx_loc, 1) < 2
        idx_loc = idx_loc(1, :);       
    else
        idx_loc = idx_loc(1:2, :);
    end
    
    BW_loc = imgsmooth(:, :, idx_loc);        
    centroids = stats.Centroid(idx_loc, :);
    
    BW_loc_rgb = outlineoverlap3D(img_total, BW_loc);
    BW_loc_maxp = max(BW_loc, [], 3);
    
    if troubleshooting == 1 
        figure; 
        imshow(BW_loc_rgb, []) 
        set(gca,'FontSize', 10);
        title('BW\_loc\_rgb');
        
        hold on
        for k= 1: size(idx_loc, 1);
            t = text(centroids(k, 1), centroids(k, 2), num2str(idx_loc(k)));
            t.Color = 'red';
            t.FontSize = 20;
        end
        hold off
    end
        
    % save the BW for review
    rgb_img_file = fullfile(folder_path, bw2_output_folder, img_name);
    rgb_img_file = char(rgb_img_file);
    saveas(gcf, rgb_img_file);
    impixelinfo;
    
    
    % save ROI stats
    stats_fin = stats(idx_loc, :);
    stats_fin.imageIdx = (repelem(n, size(stats_fin, 1)))';
end

if troubleshooting == 0, close all; end

