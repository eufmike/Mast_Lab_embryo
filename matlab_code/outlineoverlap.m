function img_ol_rgb = outlineoverlap(I, BW)

    BWoutline = bwperim(BW);
    SegoutR = im2uint8(I);
    SegoutG = im2uint8(I);
    SegoutB = im2uint8(I);
    SegoutR(BWoutline) = 255; 
    SegoutG(BWoutline) = 255;
    SegoutB(BWoutline) = 0;
    img_ol_rgb = cat(3, SegoutR, SegoutG, SegoutB);
    