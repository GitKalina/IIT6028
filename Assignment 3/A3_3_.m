im_source = im2double(imread('data/penguin-chick.jpeg'));
im_t = im2double(imread('result_3.png'));
im_s = imresize(im_source, 0.25, 'bilinear');
%im_t = imresize(im_target, 0.25, 'bilinear');

mask = getMask(im_s);
[im_s2, mask2] = alignSource(im_s, mask, im_t);
[height, width, c] = size(im_s2);
im2var = zeros(height, width);
im2var(1:height*width) = 1:height*width;

cnt=0;
A = sparse(height*width, height*width);
b = zeros(height*width, c);

for i=1:height
    for j=1:width
        cnt = cnt+1;
        if mask2(i,j)
            A(cnt,im2var(i,j)) = 4;
            A(cnt,im2var(i,j-1)) = -1;
            A(cnt,im2var(i,j+1)) = -1;
            A(cnt,im2var(i-1,j)) = -1;
            A(cnt,im2var(i+1,j)) = -1;
            
            grad_t = 4*im_t(i,j,:)-im_t(i,j-1,:)-im_t(i,j+1,:)-im_t(i-1,j,:)-im_t(i+1,j,:);
            grad_s = 4*im_s2(i,j,:)-im_s2(i,j-1,:)-im_s2(i,j+1,:)-im_s2(i-1,j,:)-im_s2(i+1,j,:);
            if abs(grad_t) > abs(grad_s)
                b(cnt,:) = grad_t;
            else
                b(cnt,:) = grad_s;
            end
        else
            A(cnt,im2var(i,j)) = 1;
            b(cnt,:) = im_t(i,j,:);
        end
    end
end

v = A\b;
result_4 = reshape(v, height, width, c);
imshow(result_4);
imwrite(result_4, 'result_4.png');
