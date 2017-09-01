%% colormap generator

bit = 16
colormap_blue = [repelem(0, 65535) ; repelem(0, 65535) ;linspace(0, 1, 65535)]';
colormap_green = [repelem(0, 65535) ; linspace(0, 1, 65535); repelem(0, 65535)]';
colormap_red = [linspace(0, 1, 65535);  repelem(0, 65535); repelem(0, 65535)]';

colormap_3c = {colormap_blue, colormap_green, colormap_red};

save('colormaps', 'colormap_3c');