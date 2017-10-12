pi_counts = 50
sample_size = 3000
x_degree = 4
y_degree = 6

x_factor = 0: (pi_counts/sample_size) : pi_counts;
x = x_factor .* pi;
size(x)
y = sin(x);
size(y)
y_factor = 0:sample_size;

plot(x.*x_factor.^x_degree*-1,(y.*y_factor.^y_degree))
%axis([-5, 50000, -10000000, 10000000])
box off