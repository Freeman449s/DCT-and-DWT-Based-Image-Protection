im=im2double(imread('protected image.bmp'));
[row,col,~]=size(im);
im_log=log(im+1);
imwrite(im_log,'logarithmic transformed image.bmp');
noise=rand(row,col,3)/16;
im_un=im+noise;
imwrite(im_un,'image with uniform noise.bmp');
im_histeq=cat(3,histeq(im(:,:,1)),histeq(im(:,:,2)),histeq(im(:,:,3)));
imwrite(im_histeq,'histogram equalized image.bmp');

disp('Operation accomplished');