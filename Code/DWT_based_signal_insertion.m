im=im2double(imread('Lena.bmp'));
[im_com,orow,ocol]=complete(im);
im_wm=add_vis(im_com);
imwrite(im_wm,'DWT protected image.bmp');

disp('Operation accomplished.');
%% ͼ��ȫ����������ͼ�����ݽ���ͼ���������Ϊż�����ٽ�������Ϊż��
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
%% ����Haar�任������������������������������Ϊ����������һ���봫��������ͬ�ߴ������
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
%% ����Haar���任������������������������������Ϊ����������һ���봫��������ͬ�ߴ������
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
%% ��άHaar�任�������Ծ���ÿһ����Haar�任���ٶ�ÿһ����Haar�任���û����뱣֤������������������Ϊż����
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
%% ��άHaar���任�������Ծ���ÿһ�������任���ٶ�ÿһ�������任���û����뱣֤������������������Ϊż����
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
%% ͼ��Haar�任����
function ret=im_haar(im)
r=im(:,:,1);
g=im(:,:,2);
b=im(:,:,3);
r_dwt=my_haar2(r);
g_dwt=my_haar2(g);
b_dwt=my_haar2(b);
ret=cat(3,r_dwt,g_dwt,b_dwt);
end
%% ͼ��Haar���任����
function ret=im_ihaar(im_dwt)
r_dwt=im_dwt(:,:,1);
g_dwt=im_dwt(:,:,2);
b_dwt=im_dwt(:,:,3);
r=my_ihaar2(r_dwt);
g=my_ihaar2(g_dwt);
b=my_ihaar2(b_dwt);
ret=cat(3,r,g,b);
end
%% ͼ�����ɺ������ú���Ϊ�����Ԫ�ظ�һ���̶�ֵ��
function ret=gene_vis(matrix)
[m,n]=size(matrix);
ret(m,n)=zeros;
for i=1:m
   for j=1:n
      ret(i,j)=0.1; 
   end
end
end
%% ���ӻ�������Ϣ��Ӻ������ú�����ͼ������׼Haar�任�����Խ���ϸ���滻Ϊ�ض�ͼ�����ٻָ�Ϊͼ��
%ע�⣺�û����뱣֤����ͼ�������������Ϊż����
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