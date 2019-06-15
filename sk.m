
P=imread('image3P.tif');
Q=imread('image3M.tif');
W1=Q(:,:,1);
W2=Q(:,:,2);
W3=Q(:,:,3);
W4=Q(:,:,4);
imshow(P)

C = makecform('cmyk2srgb');
rgb = applycform(Q, C);
rescaled_rgb1 = mat2gray(rgb);
figure,imshow(rescaled_rgb1);


%   Wavelet Transform 


[a1,b1,c1,d1]=dwt2(P,'db2');
[a2,b2,c2,d2]=dwt2(W1,'db2');
[a3,b3,c3,d3]=dwt2(W2,'db2');
[a4,b4,c4,d4]=dwt2(W3,'db2');
[a5,b5,c5,d5]=dwt2(W4,'db2');
[k1,k2]=size(a1);



%% Fusion Rules%%
%%
% Average Rule

    
    for i=1:k1
        for j=1:k2
            A1(i,j)=(a1(i,j)+a2(i,j))/2;
        end
    end

% Max Rule


    for i=1:k1
        for j=1:k2
            B1(i,j)=max(b1(i,j),b2(i,j));
            C1(i,j)=max(c1(i,j),c2(i,j));
            D1(i,j)=max(d1(i,j),d2(i,j));
        end
    end
    
    
    for i=1:k1
        for j=1:k2
            A2(i,j)=(a1(i,j)+a3(i,j))/2;
        end
    end

% Max Rule


    for i=1:k1
        for j=1:k2
            B2(i,j)=max(b1(i,j),b3(i,j));
            C2(i,j)=max(c1(i,j),c3(i,j));
            D2(i,j)=max(d1(i,j),d3(i,j));
        end
    end
    
    for i=1:k1
        for j=1:k2
            A3(i,j)=(a1(i,j)+a4(i,j))/2;
        end
    end

% Max Rule


    for i=1:k1
        for j=1:k2
            B3(i,j)=max(b1(i,j),b4(i,j));
            C3(i,j)=max(c1(i,j),c4(i,j));
            D3(i,j)=max(d1(i,j),d4(i,j));
        end
    end
    
    % Average Rule

    
    for i=1:k1
        for j=1:k2
            A4(i,j)=(a1(i,j)+a5(i,j))/2;
        end
    end

% Max Rule


    for i=1:k1
        for j=1:k2
            B4(i,j)=max(b1(i,j),b5(i,j));
            C4(i,j)=max(c1(i,j),c5(i,j));
            D4(i,j)=max(d1(i,j),d5(i,j));
        end
    end
    
    
    


% Inverse Wavelet Transform 

F1=idwt2(A1,B1,C1,D1,'db2');
F2=idwt2(A2,B2,C2,D2,'db2');
F3=idwt2(A3,B3,C3,D3,'db2');
F4=idwt2(A4,B4,C4,D4,'db2');


% w1=F1(1:r,1:c,1);
% w2=F2(1:r,1:c,2);
% w3=F3(1:r,1:c,3);

% F1 = cat(3, w1, allBlack, allBlack);
% F2 = cat(3,allBlack,w2, allBlack);
% F3 = cat(3, allBlack, allBlack,w3);

ff4=cat(3, F1,F2,F3,F4);
FF=(uint8(ff4));
imwrite(FF,"Whatt.tif")

cmyk = imread('Whatt.tif');
C = makecform('cmyk2srgb');
rgb = applycform(cmyk, C);
rescaled_rgb = mat2gray(rgb);
figure,imshow(rescaled_rgb), title("final");



% figure,imshow(ff4,[])






% Performance Check


% CR1=corr2(P,rescaled_rgb);
% CR2=corr2(rescaled_rgb1,rescaled_rgb);
%  S1=snrr(double(P),double(rescaled_rgb));
%  S2=snrr(double(rescaled_rgb1),double(rescaled_rgb));
% 
% 
% fprintf('Correlation between first image and fused image =%f \n\n',CR1);
% fprintf('Correlation between second image and fused image =%f \n\n',CR2);
%  fprintf('SNR between first image and fused image =%4.2f db\n\n',S1);
%  fprintf('SNR between second image and fused image =%4.2f db \n\n',S2);





% F=cat(3,W1,W2,W3,W4);
% figure;imshow(W1)
% figure;imshow(W2)
% figure;imshow(W3)
% figure;imshow(W4)
% imwrite(F,"What.tif")
% figure;imshow(F)



