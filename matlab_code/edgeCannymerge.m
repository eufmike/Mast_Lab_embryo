function outI = edgeCannymerge(I, iteration, level, fudgeFactor)
% for Canny repeating steps
%
%
    if ~exist('iteration');iteration = 10; end
    if ~exist('level'); level = 1; end
    if ~exist('fudgeFactor'); level = 0.1; end
    method = 'Canny';

% option need to include matrix of method and fudgeFactor
    outI = [];    
    for i = 1:iteration   
        [~, threshold] = edge(I, method);
        edgeim = edge(I, method, threshold * fudgeFactor * i);   
        se = strel('disk', dilate_level, 0);
        edgeim = imdilate(edgeim, se);
        outI(:, :, i) = edgeim
    end
end


    