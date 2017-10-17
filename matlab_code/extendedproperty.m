function stats = extendedproperty(I)
stats = regionprops('table', I, 'all');
stats.Circularity = (4*pi*stats.Area)./((stats.Perimeter).^2);
stats.Aspectratio = stats.MajorAxisLength./stats.MinorAxisLength; 
stats.Roundness = (4*stats.Area)./(pi*(stats.MajorAxisLength).^2); 
