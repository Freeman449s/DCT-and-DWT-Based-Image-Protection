im=im2double(imread('Lena.bmp'));
im_com=complete(im);
im_wm=im_add_wm(im_com,1024);
imwrite(im_wm,'DCT protected image.bmp');

disp('Operation accomplished');
%% 图像补全函数，使得图像的行数与列数为8的倍数
function ret=complete(im)
[orow,ocol,~]=size(im);
if rem(orow,8)~=0
    nrow=8*ceil(orow/8);
else
    nrow=orow;
end
if rem(ocol,8)~=0
    ncol=8*ceil(ocol/8);
else
    ncol=ocol;
end
ret(nrow,ncol,3)=zeros;
ret(1:orow,1:ocol,:)=im;
if ocol~=ncol
    ret(:,ocol+1:ncol,:)=ret(:,ocol,:);
end
if orow~=nrow
    ret(orow+1:nrow,:,:)=ret(orow,:,:);
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
%% 层保护信息添加函数。该函数对图像的一层数据进行DCT变换，将右下角3*n/4阶子阵分为36个区域，每个区域赋基准正态矩阵。
%该函数接受一个种子来产生高斯噪声。
function ret=layer_add_wm(matrix,seed)
[n,~]=size(matrix);
dct=dct_cus(matrix);
ret=dct;
order=n/8;
rng(seed,'twister');
wm=randn(order,order)/96;
for i=3:8
   for j=3:8
      ret((i-1)*order+1:i*order,(j-1)*order+1:j*order)=wm; 
   end
end
ret=idct_cus(ret);
end
%% 图像保护信息添加函数。函数默认图像是方阵。
function ret=im_add_wm(im,seed)
r=im(:,:,1);
g=im(:,:,2);
b=im(:,:,3);
r_wm=layer_add_wm(r,seed);
g_wm=layer_add_wm(g,seed);
b_wm=layer_add_wm(b,seed);
ret=cat(3,r_wm,g_wm,b_wm);
end