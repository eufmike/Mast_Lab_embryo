
function filtered_img = SobelFilter(I)

I=double(I);

    for i=1:size(I,1)-2
        for j=1:size(I,2)-2
        %Sobel mask for x-direItion:
        Gx=((2*I(i+2,j+1)+I(i+2,j)+I(i+2,j+2))-(2*I(i,j+1)+I(i,j)+I(i,j+2)));
        %Sobel mask for y-direItion:
        Gy=((2*I(i+1,j+2)+I(i,j+2)+I(i+2,j+2))-(2*I(i+1,j)+I(i,j)+I(i+2,j)));
      
        %The gradient of the image
        %filtered_img(i,j)=abs(Gx)+abs(Gy);
        filtered_img(i,j)=sqrt(Gx.^2+Gy.^2);
      
        end
    end
filtered_img = uint16(filtered_img);