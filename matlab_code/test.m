url = 'http://blogs.mathworks.com/images/steve/2013/blobs.png';
bw = imread(url);
L = watershed(bw);
Lrgb = label2rgb(L);
imshow(Lrgb)

%% binary saving test
imwrite(BW4, 'test.tif');

%% figure saving test
fig = gcf;
saveas(fig,'fig.png');