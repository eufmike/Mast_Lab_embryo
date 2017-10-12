% by Mike Shih

%% colormap generator

bit = 8;
unsign_max_value = 2^bit-1;
value_yes = linspace(0, 1, unsign_max_value);
value_no = repelem(0, unsign_max_value);
colormap_blue = [value_no; value_no; value_yes]';
colormap_green = [value_no; value_yes; value_no]';
colormap_red = [value_yes; value_no; value_no]';
colormap_yellow = [value_yes; value_yes; value_no]';
colormap_cyan = [value_no; value_yes; value_yes]';
colormap_magenta = [value_yes; value_no; value_yes]';

colormap_3c = {colormap_blue, colormap_green, colormap_red, colormap_yellow, colormap_cyan, colormap_magenta};

save('colormaps', 'colormap_3c');