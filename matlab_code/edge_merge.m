function bw_gray = edge_merge(I, dilate_level)

if ~exist('dilate_level')
    dilate_level = 1;
end

% option need to include matrix of method and fudgeFactor
bw_gray = zeros(size(I));

    for i = 1:10
        method = 'Canny';
        fudgeFactor = 0.1;    
        [~, threshold] = edge(I, method);
        edgeim = edge(I, method, threshold * fudgeFactor * i);   
        se = strel('disk',dilate_level,0);
        edgeim = imdilate(edgeim, se);
        bw_gray_temp = uint8(edgeim);
        bw_gray = bw_gray_temp + uint8(bw_gray);
    end

    for i = 1:10
        method = 'Roberts';
        fudgeFactor = 0.1;    
        [~, threshold] = edge(I, method);
        edgeim = edge(I, method, threshold * fudgeFactor * i);   
        se = strel('disk',dilate_level,0);
        edgeim = imdilate(edgeim, se);
        bw_gray_temp = uint8(edgeim);
        bw_gray = bw_gray_temp + uint8(bw_gray);
    end
    
    