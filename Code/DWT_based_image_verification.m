std=im2double(imread('DWT protected image.bmp'));
std_dwt=im_haar(std);
figure('name','std protected image');
imshow(std_dwt);
imwrite(blk_dwt,'STD Result.png');
blk=im2double(imread('image with block.bmp'));
blk_dwt=im_haar(blk);
figure('name','image with block');
imshow(blk_dwt);
imwrite(blk_dwt,'BLK Result.png');
line=im2double(imread('image with line.bmp'));
line_dwt=im_haar(line);
figure('name','image with line');
imshow(line_dwt);
imwrite(line_dwt,'LINE Result.png');
un=im2double(imread('image with uniform noise.bmp'));
un_dwt=im_haar(un);
figure('name','image with uniform noise');
imshow(un_dwt);
imwrite(un_dwt,'UN Result.png');
log=im2double(imread('logarithmic transformed image.bmp'));
log_dwt=im_haar(log);
figure('name','logarithmic transformed image');
imshow(log_dwt);
imwrite(log_dwt,'LOG Result.png');
histeq=im2double(imread('histogram equalized image.bmp'));
histeq_dwt=im_haar(histeq);
figure('name','histogram equalized image');
imshow(histeq_dwt);
imwrite(histeq_dwt,'HISTEQ Result.png');

disp('Operation accomplished.');
%% 向量Haar变换函数，函数接受行向量或列向量作为参数，返回一个与传入向量相同尺寸的向量
function ret=vec_haar(vector)
[m,n]=size(vector);
if m>n
    n=m;
    ret(n,1)=zeros;
else
    ret(1,n)=zeros;
end
for i=1:n/2
    ret(i)=(vector(2*i-1)+vector(2*i))/2;
    ret(n/2+i)=(vector(2*i-1)-vector(2*i))/2;
end
end
%% 向量Haar反变换函数，函数接受行向量或列向量作为参数，返回一个与传入向量相同尺寸的向量
function ret=vec_ihaar(vector)
[m,n]=size(vector);
if m>n
    n=m;
    ret(n,1)=zeros;
else
    ret(1,n)=zeros;
end
for i=1:n/2
   ret(2*i-1)=vector(i)+vector(i+n/2);
   ret(2*i)=vector(i)-vector(i+n/2);
end
end
%% 二维Haar变换函数，对矩阵每一行做Haar变换，再对每一列做Haar变换。用户必须保证传入矩阵的行数和列数为偶数。
function ret=my_haar2(matrix)
[row,col]=size(matrix);
ret(row,col)=zeros;
for i=1:row
    ret(i,:)=vec_haar(matrix(i,:));
end
for i=1:col
    ret(:,i)=vec_haar(ret(:,i));
end
end
%% 二维Haar反变换函数，对矩阵每一列做反变换，再对每一行做反变换。用户必须保证传入矩阵的行数和列数为偶数。
function ret=my_ihaar2(matrix)
[row,col]=size(matrix);
ret(row,col)=zeros;
for i=1:col
   ret(:,i)=vec_ihaar(matrix(:,i));
end
for i=1:row
   ret(i,:)=vec_ihaar(ret(i,:));
end
end
%% 图像Haar变换函数
function ret=im_haar(im)
r=im(:,:,1);
g=im(:,:,2);
b=im(:,:,3);
r_dwt=my_haar2(r);
g_dwt=my_haar2(g);
b_dwt=my_haar2(b);
ret=cat(3,r_dwt,g_dwt,b_dwt);
end
%% 图像Haar反变换函数
function ret=im_ihaar(im_dwt)
r_dwt=im_dwt(:,:,1);
g_dwt=im_dwt(:,:,2);
b_dwt=im_dwt(:,:,3);
r=my_ihaar2(r_dwt);
g=my_ihaar2(g_dwt);
b=my_ihaar2(b_dwt);
ret=cat(3,r,g,b);
end