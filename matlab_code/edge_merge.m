function bw_gray = edge_merge(I)
% option need to include matrix of method and fudgeFactor
bw_gray = zeros(size(I));

    for i = 1:20
        method = 'Canny';
        fudgeFactor = 0.05;    
        [~, threshold] = edge(I, method);
        edgeim = edge(I, method, threshold * fudgeFactor * i);   
        se = strel('disk',2,0);
        edgeim = imdilate(edgeim, se);
        bw_gray_temp = uint8(edgeim);
        bw_gray = bw_gray_temp + uint8(bw_gray);
    end

    for i = 1:20
        method = 'Roberts';
        fudgeFactor = 0.05;    
        [~, threshold] = edge(I, method);
        edgeim = edge(I, method, threshold * fudgeFactor * i);   
        se = strel('disk',2,0);
        edgeim = imdilate(edgeim, se);
        bw_gray_temp = uint8(edgeim);
        bw_gray = bw_gray_temp + uint8(bw_gray);
    end
    
    