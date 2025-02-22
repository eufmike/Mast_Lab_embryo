

bw_gray = zeros(size(img_2));
for i = 1:20
    method = 'Canny';
    fudgeFactor = 0.05;    
    [~, threshold] = edge(img_2, method);
    edgeim_sobel_2 = edge(img_2, method, threshold * fudgeFactor * i);   
    
    se = strel('disk',2,0);
    edgeim_sobel_2 = imdilate(edgeim_sobel_2, se);
    
    bw_gray_temp = uint8(edgeim_sobel_2);
    
    bw_gray = bw_gray_temp + uint8(bw_gray);

end

% for i = 1:20
%     method = 'log';
%     fudgeFactor = 0.05;    
%     [~, threshold] = edge(img_2, method);
%     edgeim_sobel_2 = edge(img_2, method, threshold * fudgeFactor * i);   
%     
%     se = strel('disk',2,0);
%     edgeim_sobel_2 = imdilate(edgeim_sobel_2, se);
%     
%     bw_gray_temp = uint8(edgeim_sobel_2);
%     
%     bw_gray = bw_gray_temp + uint8(bw_gray);
% 
% end

for i = 1:20
    method = 'Roberts';
    fudgeFactor = 0.05;    
    [~, threshold] = edge(img_2, method);
    edgeim_sobel_2 = edge(img_2, method, threshold * fudgeFactor * i);   
    
    se = strel('disk',2,0);
    edgeim_sobel_2 = imdilate(edgeim_sobel_2, se);
    
    bw_gray_temp = uint8(edgeim_sobel_2);
    
    bw_gray = bw_gray_temp + uint8(bw_gray);

end


figure
imshow(bw_gray, []);
impixelinfo;

bw_gray_th = im2bw(bw_gray, 0.1);
figure
imshow(bw_gray_th, []);

impixelinfo;