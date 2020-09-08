im_wm=im2double(imread('DCT protected image.bmp'));
std_cm=verify(im_wm,1024);
im_log=im2double(imread('logarithmic transformed image.bmp'));
log_cm=verify(im_log,1024);
im_un=im2double(imread('image with uniform noise.bmp'));
un_cm=verify(im_un,1024);
im_blk=im2double(imread('image with block.bmp'));
blk_cm=verify(im_blk,1024);
im_line=im2double(imread('image with line.bmp'));
line_cm=verify(im_line,1024);
im_histeq=im2double(imread('histogram equalized image.bmp'));
histeq_cm=verify(im_histeq,1024);

disp('Operation accomplished');
%% getbasis返回一个由n个基向量（行向量）组成的矩阵
function ret=getbasis(n)
ret(n,n)=zeros;
c(n,1)=zeros;
for i=1:n
   if i==1
       c(i,1)=sqrt(1/n);
   else
       c(i,1)=sqrt(2/n);
   end
end
for i=1:n
   for j=1:n
       ret(i,j)=c(i,1)*cos((2*(j-1)+1)*(i-1)*pi/2/n);
   end
end
end
%% 自定义DCT函数
function ret=dct_cus(matrix)
[n,~]=size(matrix);
%getbasis函数返回DCT变换所用基矩阵
basis=getbasis(n);
%基矩阵中的各个行向量与原始信号矩阵相乘，得到DCT变换后矩阵的各个元素
ret=basis*matrix*basis';
end
%% 自定义IDCT函数
function ret=idct_cus(matrix)
[n,~]=size(matrix);
basis=getbasis(n);
%将各个基向量与DCT处理后矩阵中的对应元素相乘后求和，得到重建信号
ret=basis'*matrix*basis;
end
%% 图像DCT函数
function ret=im_dct(im)
r=im(:,:,1);
g=im(:,:,2);
b=im(:,:,3);
r_dct=dct_cus(r);
g_dct=dct_cus(g);
b_dct=dct_cus(b);
ret=cat(3,r_dct,g_dct,b_dct);
end
%% 图像反DCT函数
function ret=im_idct(im)
r_dct=im(:,:,1);
g_dct=im(:,:,2);
b_dct=im(:,:,3);
r=idct_cus(r_dct);
g=idct_cus(g_dct);
b=idct_cus(b_dct);
ret=cat(3,r,g,b);
end
%% 期望计算函数，该函数返回一个二维矩阵的均值
function ret=exp(matrix)
[m,n]=size(matrix);
ret=0;
for i=1:m
   for j=1:n
      ret=ret+matrix(i,j);
   end
end
ret=ret/m/n;
end
%% 方差计算函数，该函数返回一个二维矩阵的方差
function ret=var(matrix)
exp_x=exp(matrix);
exp_x2=exp(matrix.*matrix);
ret=exp_x2-(exp_x)^2;
end
%% 协方差计算函数，该函数接受两个二维向量作为参数，返回两个矩阵的协方差。用户必须保证传入矩阵尺寸相同。
function ret=cov(m1,m2)
product=m1.*m2;
exp_xy=exp(product);
exp_x=exp(m1);
exp_y=exp(m2);
ret=exp_xy-exp_x*exp_y;
end
%% 相关系数计算函数，该函数接受两个二维向量作为参数，返回两个矩阵的相关系数。用户必须保证传入矩阵尺寸相同。
function ret=coef(m1,m2)
vcov=cov(m1,m2);
var_x=var(m1);
var_y=var(m2);
ret=vcov/sqrt(var_x)/sqrt(var_y);
end
%% 层校验函数，函数逐个计算标准噪声矩阵与图像一层各相关子阵的相关系数，将各相关系数依据相对位置关系赋给系数矩阵。
function coefm=layer_verify(matrix,seed)
[n,~,~]=size(matrix);
order=n/8;
matrix=dct_cus(matrix);
rng(seed,'twister');
std_wm=randn(order,order)/96;
coefm(6,6)=zeros;
for i=3:8
   for j=3:8
       coefm(i-2,j-2)=coef(matrix((i-1)*order+1:i*order,(j-1)*order+1:j*order),std_wm);
   end
end
end
%% 图像校验函数。函数对图像每一层做层校验，后对三个系数矩阵取平均
function coefm=verify(im,seed)
mr=layer_verify(im(:,:,1),seed);
mg=layer_verify(im(:,:,2),seed);
mb=layer_verify(im(:,:,3),seed);
coefm=(mr+mg+mb)/3;
end