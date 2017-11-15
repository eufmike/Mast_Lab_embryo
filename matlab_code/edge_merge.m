function outI = edgeCannymerge(I, method, iteration, level, fudgeFactor)
% for Canny repeating steps
%
%
if ~exist('method');dilate_level = 10; end
if ~exist('iteration');level = 10; end
if ~exist('level'); level = 1; end

% option need to include matrix of method and fudgeFactor
bw_gray = zeros(size(I));
    for i = 1:iteration
        method = method;
        fudgeFactor = 0.1;    
        [~, threshold] = edge(I, method);
        edgeim = edge(I, method, threshold * fudgeFactor * i);   
        se = strel('disk',dilate_level,0);
        edgeim = imdilate(edgeim, se);
        bw_gray_temp = uint8(edgeim);
        bw_gray = bw_gray_temp + uint8(bw_gray);
    end

    