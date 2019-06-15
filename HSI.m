function HSI()
% [file, pathname] = uigetfile('*.bmp','*.jpg','Load Image 1 ');cd(pathname);
% a=imread(file);
% [file, pathname] = uigetfile('*.bmp','*.jpg','Load Image 2 ');cd(pathname);
% b=imread(file);
II=imread("image2P.tif");
figure, imshow(II);
% II(1:20,1:4)
originalMinValue = double(min(min(II)));
originalMaxValue = double(max(max(II)));
originalRange = originalMaxValue - originalMinValue;

desiredMin = 0;
desiredMax = 1;
desiredRange = desiredMax - desiredMin;
FI = desiredRange * (double(II) - originalMinValue) /originalRange + desiredMin;


F=imread("image2p.tif");
figure, imshow(F);
F=im2double(F);
% cmyk = F;
% C = makecform('cmyk2srgb');
% rgb = applycform(cmyk, C);
% rescaled_rgb = mat2gray(rgb);
% F=rescaled_rgb;
r=F(:,:,1);
g=F(:,:,2);
b=F(:,:,3);
th=acos((0.5*((r-g)+(r-b)))./((sqrt((r-g).^2+(r-b).*(g-b)))+eps));
H=th;
H(b>g)=2*pi-H(b>g);
H=H/(2*pi);
S=1-3.*(min(min(r,g),b))./(r+g+b+eps);
I=(r+g+b)/3;
% FI=histeq(I);
%  FI(1:20,1:4)
FI=imhistmatch(FI,I);

% FI(1:20,1:4)
hsi=cat(3,H,S,FI);
figure, imshow(H),title('H Image');
figure, imshow(S),title('S Image');
figure, imshow(FI),title('I Image');
figure, imshow(hsi),title('HSI Image');
rgb=hsitorgb(hsi);
figure,imshow(rgb),title('fused RGB Image');
imwrite(rgb,"test.tif");
% % figure,imshow(F),title('RGB Image');
% 
% 
% 
% S1=snrr(double(F),double(rgb));
% S2=snrr(double(II),double(rgb));
% 
% 
% 
% fprintf('SNR between first image and fused image =%4.2f db\n\n',S1);
% fprintf('SNR between second image and fused image =%4.2f db \n\n',S2);
end

function C=hsitorgb(hsi)
HV=hsi(:,:,1)*2*pi;
SV=hsi(:,:,2);
IV=hsi(:,:,3);
%  IV(1:20,1:4)
R=zeros(size(HV));
G=zeros(size(HV));
B=zeros(size(HV));
%RG Sector
id=find((0<=HV)& (HV<2*pi/3));
B(id)=IV(id).*(1-SV(id));
R(id)=IV(id).*(1+SV(id).*cos(HV(id))./cos(pi/3-HV(id)));
G(id)=3*IV(id)-(R(id)+B(id));
%BG Sector
id=find((2*pi/3<=HV)& (HV<4*pi/3));
R(id)=IV(id).*(1-SV(id));
G(id)=IV(id).*(1+SV(id).*cos(HV(id)-2*pi/3)./cos(pi-HV(id)));
B(id)=3*IV(id)-(R(id)+G(id));
%BR Sector
id=find((4*pi/3<=HV)& (HV<2*pi));
G(id)=IV(id).*(1-SV(id));
B(id)=IV(id).*(1+SV(id).*cos(HV(id)-4*pi/3)./cos(5*pi/3-HV(id)));
R(id)=3*IV(id)-(G(id)+B(id));
C=cat(3,R,G,B);
C=max(min(C,1),0);
end



