function sharpenedimg = im_sharpen(I, iteration)
% the kernel is the same as ImageJ

if ~exist('iteration')
    iteration = 1;
end

m = [-1, -1, -1; -1, 12, -1; -1, -1, -1];
sharpenedimg = I;
for i = 1:iteration    
    sharpenedimg = conv2(sharpenedimg, m, 'same');
end