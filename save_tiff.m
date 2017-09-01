%imshow(img_1_crp_rt); 
%colormap(mycolormap);

functoion writeTIFF(data, filename)
    t = Tiff(filename, 'w');
    % size
    t.setTag('ImageLength', size(data, 1)); 
    t.setTag('ImageWidth', size(data, 2)); 
    t.setTag('SamplesPerPixel', size(data, 3)); 
    
    % compression: None, LZW, JPEG
    % tagstruct.Compression = Tiff.Compression.LZW;
    t.setTag('Compression', Tiff.Compression.None);
    
    % SampleFormat: UInt, Int, IEEEEFP
    t.setTag('SampleFormat', Tiff.SampleFormat.UInt);
    
    % Photometric: MinIsWhite, MinIsBlack, RGB
    t.setTag('Photometric', Tiff.Photometric.MinIsBlack);
    
    % Bit depth
    t.setTag('BitsPerSample', 16);    
    
    
    
   
    