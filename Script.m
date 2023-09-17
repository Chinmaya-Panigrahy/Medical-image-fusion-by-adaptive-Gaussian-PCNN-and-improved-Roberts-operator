% Code for the paper: "Medical image fusion by adaptive Gaussian PCNN and
% improved Roberts operator" published in "Signal, Image and Video Processing"
clear all
img1=imread('MRIPET.png');  % A MxN matrix
img2=imread('PET.png');  % A MxNx3 matrix
if size(img2,3)==3 
    tic
    img1 = double(img1)/255;
    img2 = double(img2)/255;   
    img2_YUV=ConvertRGBtoYUV(img2);
    img2_Y=img2_YUV(:,:,1);
    [hei, wid] = size(img1);
    imgf_Y=FUSION_NSST_ABS_AGPCNN_IRO(img1,img2_Y);
    imgf_YUV=zeros(hei,wid,3);
    imgf_YUV(:,:,1)=imgf_Y;
    imgf_YUV(:,:,2)=img2_YUV(:,:,2);
    imgf_YUV(:,:,3)=img2_YUV(:,:,3);
    imgf=ConvertYUVtoRGB(imgf_YUV);
    F=uint8(imgf*255);
    toc
    figure, imshow(F)
else
    tic
    img1= double(img1)/255;
    img2= double(img2)/255;  
    Fc=FUSION_NSST_ABS_AGPCNN_IRO(img1,img2);
    F=uint8(Fc*255);
    toc
    figure, imshow(F) 
end
        
        
        
        
        
        
        
        
        
        
       
        
        
        
       
        
        
        
        


             

         

