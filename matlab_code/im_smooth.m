function blurredimg = im_smooth(I, iteration)
% the kernel is the same as ImageJ

if ~exist('iteration')
    iteration = 1;
end

m =[1, 1, 1; 1, 1, 1; 1, 1, 1];
blurredimg = I;
for i = 1:iteration    
    blurredimg = conv2(blurredimg, m, 'same');
end
    

