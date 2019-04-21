close all;
%Reading Image
[I,Rdir,~]=uigetfile({'*.jpg;*.png;*.bmp'},'Pick Hazy Image');
hazImg=strcat(Rdir,I);
hazImg=imread(hazImg);
pic=hazImg;
pic=double(pic);

%A parameter which is to be tuned depends upon the image output
%adjusting this parameter could give the required result - 50 is found
%anlytically for indoor hazy images
adjustKnob=50;
factor=1+adjustKnob/255;

%Histogram equalization is done because hazy image's histogram tends to
%shift on the brighter region
pic(:,:,1)=histeq(hazImg(:,:,1));
pic(:,:,2)=histeq(hazImg(:,:,2));
pic(:,:,3)=histeq(hazImg(:,:,3));

%Image adjusted further by handling the saturation and value parameters
k=rgb2hsv(pic);
k(:,:,2)=k(:,:,2)*(1/factor);
k(:,:,3)=k(:,:,3)*factor;
pic=hsv2rgb(k);

pic=uint8(pic);

%Further Gaussian filter is applied to smooth out the abrupt change effect
h=fspecial('gaussian');
pic(:,:,1)=filter2(h,pic(:,:,1));
pic(:,:,2)=filter2(h,pic(:,:,2));
pic(:,:,3)=filter2(h,pic(:,:,3));

figure;
subplot(1,2,1),imshow(hazImg);
subplot(1,2,2),imshow(pic);
