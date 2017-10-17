url = 'http://blogs.mathworks.com/images/steve/2013/blobs.png';
bw = imread(url);
L = watershed(bw);
Lrgb = label2rgb(L);
imshow(Lrgb)