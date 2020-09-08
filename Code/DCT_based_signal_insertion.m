im=im2double(imread('Lena.bmp'));
im_com=complete(im);
im_wm=im_add_wm(im_com,1024);
imwrite(im_wm,'DCT protected image.bmp');

disp('Operation accomplished');
%% ͼ��ȫ������ʹ��ͼ�������������Ϊ8�ı���
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
%% �㱣����Ϣ��Ӻ������ú�����ͼ���һ�����ݽ���DCT�任�������½�3*n/4�������Ϊ36������ÿ�����򸳻�׼��̬����
%�ú�������һ��������������˹������
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
%% ͼ�񱣻���Ϣ��Ӻ���������Ĭ��ͼ���Ƿ���
function ret=im_add_wm(im,seed)
r=im(:,:,1);
g=im(:,:,2);
b=im(:,:,3);
r_wm=layer_add_wm(r,seed);
g_wm=layer_add_wm(g,seed);
b_wm=layer_add_wm(b,seed);
ret=cat(3,r_wm,g_wm,b_wm);
end