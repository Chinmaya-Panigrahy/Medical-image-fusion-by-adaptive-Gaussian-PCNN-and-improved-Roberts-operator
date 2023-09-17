function [F]=FUSION_NSST_ABS_AGPCNN_IRO(A,B)
addpath(genpath('shearlet'));

%%  NSST Decomposition
pfilt = 'maxflat';
shear_parameters.dcomp =[3,3,4,4];
shear_parameters.dsize =[8,8,16,16];
[y1,shear_f1]=nsst_dec2(A,shear_parameters,pfilt);
[y2,shear_f2]=nsst_dec2(B,shear_parameters,pfilt);

Fused=y1;
ALow1= y1{1};
BLow1 =y2{1};

%%  Fusion of Low-pass Subbands
%disp('Processing Low-pass Subbands...')
Rx=[0 0 0;1 0 -1;0 0 0];
Ry=[0 1 0;0 0 0;0 -1 0];
R45=[0 0 1;0 0 0;-1 0 0];
R135=[1 0 0;0 0 0;0 0 -1];
RO1=conv2(ALow1,Rx,'same')+conv2(ALow1,Ry,'same')+conv2(ALow1,R45,'same')+conv2(ALow1,R135,'same');
RO2=conv2(BLow1,Rx,'same')+conv2(BLow1,Ry,'same')+conv2(BLow1,R45,'same')+conv2(BLow1,R135,'same');
map=(RO1>=RO2);
Fused{1}=map.*ALow1+~map.*BLow1;  

%%  Fusion of High-pass Subbands
%disp('Processing High-pass Subbands...')
for m=2:length(shear_parameters.dcomp)+1
    temp=size((y1{m}));temp=temp(3);
    for n=1:temp
        Ahigh=y1{m}(:,:,n);
        Bhigh=y2{m}(:,:,n);
        AH=abs(Ahigh);
        BH=abs(Bhigh);
        AGPCNN_firing_times1=AGPCNN(AH);
        AGPCNN_firing_times2=AGPCNN(BH);
        map=(AGPCNN_firing_times1>=AGPCNN_firing_times2);
        Fused{m}(:,:,n)=map.*Ahigh+~map.*Bhigh;
    end
end

%%  NSST Reconstruction
F=nsst_rec2(Fused,shear_f1,pfilt);
end

    
    
        
        
       
                
                
                
                 
               
                
           
        
  

        










