im = imread('data/toy_problem.png');
[height, width] = size(im); % 119*110
im_ = im2double(im);
im2var = zeros(height,width);
im2var(1:height*width) = 1:height*width;

cnt=0;
A = sparse(((height*(width-1))+(height-1)*width)+1, height*width);

for i = 1:height
    for j = 1:width-1
        cnt = cnt+1;
        A(cnt,im2var(i,j+1)) = 1;
        A(cnt,im2var(i,j)) = -1;
        b(cnt) = im_(i,j+1) - im_(i,j);
    end
end
for i = 1:height-1
    for j = 1:width
        cnt = cnt+1;
        A(cnt,im2var(i+1,j)) = 1;
        A(cnt,im2var(i,j)) = -1;
        b(cnt) = im_(i+1,j) - im_(i,j);
    end
end
A(cnt+1, im2var(1,1)) = 1;
b(cnt+1) = im_(1,1);
v = A\b';

toy_problem = reshape(v, height, width);
imshow(toy_problem);
imwrite(toy_problem, 'toy_problem.png');

