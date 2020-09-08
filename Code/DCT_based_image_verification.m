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
%% getbasis����һ����n��������������������ɵľ���
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
%% �Զ���DCT����
function ret=dct_cus(matrix)
[n,~]=size(matrix);
%getbasis��������DCT�任���û�����
basis=getbasis(n);
%�������еĸ�����������ԭʼ�źž�����ˣ��õ�DCT�任�����ĸ���Ԫ��
ret=basis*matrix*basis';
end
%% �Զ���IDCT����
function ret=idct_cus(matrix)
[n,~]=size(matrix);
basis=getbasis(n);
%��������������DCT���������еĶ�ӦԪ����˺���ͣ��õ��ؽ��ź�
ret=basis'*matrix*basis;
end
%% ͼ��DCT����
function ret=im_dct(im)
r=im(:,:,1);
g=im(:,:,2);
b=im(:,:,3);
r_dct=dct_cus(r);
g_dct=dct_cus(g);
b_dct=dct_cus(b);
ret=cat(3,r_dct,g_dct,b_dct);
end
%% ͼ��DCT����
function ret=im_idct(im)
r_dct=im(:,:,1);
g_dct=im(:,:,2);
b_dct=im(:,:,3);
r=idct_cus(r_dct);
g=idct_cus(g_dct);
b=idct_cus(b_dct);
ret=cat(3,r,g,b);
end
%% �������㺯�����ú�������һ����ά����ľ�ֵ
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
%% ������㺯�����ú�������һ����ά����ķ���
function ret=var(matrix)
exp_x=exp(matrix);
exp_x2=exp(matrix.*matrix);
ret=exp_x2-(exp_x)^2;
end
%% Э������㺯�����ú�������������ά������Ϊ�������������������Э����û����뱣֤�������ߴ���ͬ��
function ret=cov(m1,m2)
product=m1.*m2;
exp_xy=exp(product);
exp_x=exp(m1);
exp_y=exp(m2);
ret=exp_xy-exp_x*exp_y;
end
%% ���ϵ�����㺯�����ú�������������ά������Ϊ����������������������ϵ�����û����뱣֤�������ߴ���ͬ��
function ret=coef(m1,m2)
vcov=cov(m1,m2);
var_x=var(m1);
var_y=var(m2);
ret=vcov/sqrt(var_x)/sqrt(var_y);
end
%% ��У�麯����������������׼����������ͼ��һ��������������ϵ�����������ϵ���������λ�ù�ϵ����ϵ������
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
%% ͼ��У�麯����������ͼ��ÿһ������У�飬�������ϵ������ȡƽ��
function coefm=verify(im,seed)
mr=layer_verify(im(:,:,1),seed);
mg=layer_verify(im(:,:,2),seed);
mb=layer_verify(im(:,:,3),seed);
coefm=(mr+mg+mb)/3;
end