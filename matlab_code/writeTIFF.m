
function writeTIFF(data, filename)
    t = Tiff(filename, 'w');
    % Photometric: MinIsWhite, MinIsBlack, RGB
    t.setTag('Photometric', Tiff.Photometric.MinIsBlack);
    % compression: None, LZW, JPEG
    % tagstruct.Compression = Tiff.Compression.LZW;
    t.setTag('Compression', Tiff.Compression.None);
    % SampleFormat: UInt, Int, IEEEEFP
    t.setTag('SampleFormat', Tiff.SampleFormat.UInt);
    % Bit depth
    t.setTag('BitsPerSample', 16);
    t.setTag('SamplesPerPixel', 3); 
    % size
    t.setTag('ImageLength', size(data, 1)); 
    t.setTag('ImageWidth', size(data, 2)); 
    
    % Planar Configuration
    t.setTag('PlanarConfiguration', Tiff.PlanarConfiguration.Chunky);
    
    t.write(data);
    
    t.close(); 
    
    
    
    
    
    
   
    