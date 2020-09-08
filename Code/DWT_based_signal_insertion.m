im=im2double(imread('Lena.bmp'));
[im_com,orow,ocol]=complete(im);
im_wm=add_vis(im_com);
imwrite(im_wm,'DWT protected image.bmp');

disp('Operation accomplished.');
%% 图像补全函数，利用图像数据将先图像的列数补为偶数，再将行数补为偶数
function [ret,orow,ocol]=complete(im)
[orow,ocol,~]=size(im);
if rem(orow,2)~=0
    nrow=orow+1;
else
    nrow=orow;
end
if rem(ocol,2)~=0
    ncol=ocol+1;
else
    ncol=ocol;
end
ret(nrow,ncol,3)=zeros;
ret(1:orow,1:ocol,:)=im;
ret(:,ncol,:)=ret(:,ocol,:);
ret(nrow,:,:)=ret(orow,:,:);
end
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
%% 图案生成函数。该函数为矩阵各元素赋一个固定值。
function ret=gene_vis(matrix)
[m,n]=size(matrix);
ret(m,n)=zeros;
for i=1:m
   for j=1:n
      ret(i,j)=0.1; 
   end
end
end
%% 可视化保护信息添加函数。该函数对图像做标准Haar变换，将对角线细节替换为特定图案，再恢复为图像。
%注意：用户必须保证传入图像的行数和列数为偶数。
function ret=add_vis(im)
[row,col,~]=size(im);
im_dwt=im_haar(im);
r_dwt=im_dwt(:,:,1);
g_dwt=im_dwt(:,:,2);
b_dwt=im_dwt(:,:,3);
r_dwt_wm=r_dwt;
g_dwt_wm=g_dwt;
b_dwt_wm=b_dwt;
r_dwt_wm(row/2+1:row,col/2+1:col)=gene_vis(r_dwt_wm(row/2+1:row,col/2+1:col));
g_dwt_wm(row/2+1:row,col/2+1:col)=gene_vis(g_dwt_wm(row/2+1:row,col/2+1:col));
b_dwt_wm(row/2+1:row,col/2+1:col)=gene_vis(b_dwt_wm(row/2+1:row,col/2+1:col));
im_dwt_wm=cat(3,r_dwt_wm,g_dwt_wm,b_dwt_wm);
ret=im_ihaar(im_dwt_wm);
end