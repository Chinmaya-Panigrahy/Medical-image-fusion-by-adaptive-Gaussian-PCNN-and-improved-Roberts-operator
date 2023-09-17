function R=AGPCNN(S)

iteration_times=110;
a_E=20;
d_E=0.6;

% Calculation of beta
window_size=3;
spread=(window_size-1)/2;
S=double(S);
[row,column]=size(S);
temp=S.*0;
S_pad=padarray(S,[spread spread],'symmetric');   
%  'circular'    Pads with circular repetition of elements.
%  'replicate'   Repeats border elements of A.  
%  'symmetric'   Pads array with mirror reflections of itself. 
for i=2:row+1
    for j=2:column+1
        temp(i-1,j-1)=((S_pad(i+1,j+1)-S_pad(i+1,j))^2+(S_pad(i+1,j+1)-S_pad(i,j+1))^2);
    end
end
temp=padarray(temp,[spread spread],'symmetric');
for i=2:row+1
     for j=2:column+1
         mask=temp(i-spread:i+spread,j-spread:j+spread);
         SF(i-1,j-1)=sqrt(sum(mask(:))./(window_size.^2));
     end
end
SFN=SF-min(SF(:));
SFN=SFN./max(SFN(:));
beta=SFN;  % Normalized SF 
                  
% Initialize the AGPCNN model
%[row,column]=size(I); previously defined
F=abs(S);

U=zeros(row,column);
Y=zeros(row,column);
T=zeros(row,column);
E=ones(row,column);

% Gaussian Filter.
G=fspecial('Gaussian',[3 3],0.6);

for n=1:iteration_times
    L = conv2(Y,G,'same');
    U = F .* (1 + beta .* L);
    Y = im2double( U > E );
    E = d_E * E + a_E * Y;
    T = T + Y;
end
R = T;
end