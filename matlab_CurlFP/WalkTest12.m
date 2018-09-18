clear;

X=1.*[0 0 0 0 1 1 1 1].';
Y=1.*[1 0 1 0 1 0 1 0].';
Z=1.*[1 1 0 0 1 1 0 0].';

[FEVals]=GetFEVals(X,Y,Z);
GaussPX=zeros(8,1);
for n1=1:8
GaussPX(n1)=FEVals.Abq(n1).xn.'*X;

end

%%

 kFP(1).FP = [ ...
   1.00861654705529      -1.901345662417588E-018 -4.191279236569061E-020;...
 -2.496618062897725E-019  0.982985799267382      -5.480004270867380E-020;...
  3.481274285668173E-020  7.741373829328158E-020   1.00861654705529]; 
    
 kFP(2).FP = [ ...
   1.00861654705529       4.951124144971129E-019  3.481274285668173E-020;...
 -2.496618062897725E-019  0.982985799267382       1.269935769366560E-020;...
  3.481274285668173E-020 -1.151104239574829E-020   1.00861654705529];      
    
 kFP(3).FP = [ ...
   1.00861654705529      -3.559363865761708E-018  6.743527190489150E-020;...
 -5.342698483175889E-020  0.982985799267383      -6.473687431004629E-020;...
  8.330155392307268E-021  1.496936674103193E-019   1.00861654705529];      
    
 kFP(4).FP = [ ...
   1.00861654705529       1.014746730286267E-019  8.330155392307268E-021;...
 -5.342698483175889E-020  0.982985799267383      -2.876990634994724E-020;...
  8.330155392307268E-021  1.480163841807627E-019   1.00861654705529];      
    
 kFP(5).FP = [ ...
   1.00861654705529      -1.693221763185130E-018 -1.153811548383686E-019;...
 -3.335409259803948E-019  0.982985799267382      -4.658079666647695E-021;...
 -1.326265367570948E-019  2.028763405154965E-019   1.00861654705529];      
    
 kFP(6).FP = [ ...
   1.00861654705529       5.665651941010490E-019 -3.182090820605530E-020;...
 -2.847873567510752E-019  0.982985799267382      -2.909326667676070E-020;...
 -3.182090820605530E-020  3.619692541374855E-020   1.00861654705529];      
    
 kFP(7).FP = [ ...
   1.00861654705529      -3.701065491387973E-018  4.009798279009452E-020;...
 -6.891945502288160E-020  0.982985799267382       3.556594312193190E-020;...
  5.873223017214767E-020  1.871728018820822E-019   1.00861654705529];      
    
 kFP(8).FP = [ ...
   1.00855612439176       1.176153264168912E-019  6.385408626874273E-020;...
 -6.391929880099079E-020  0.983103594869020      -2.238439065702651E-020;...
  6.385408626874273E-020  5.673699527702107E-020   1.00855612439176];   

figure(200);
clf;
hold on;
plot(kFP(1).FP(:),'rx-');
plot(kFP(2).FP(:),'gs-');
plot(kFP(3).FP(:),'bo-');
plot(kFP(4).FP(:),'k>-');
plot(kFP(5).FP(:),'rp-');
plot(kFP(6).FP(:),'g<-');
plot(kFP(7).FP(:),'k^-');
plot(kFP(8).FP(:),'kx-');


%%
% for n1=1:8
%    kFP(n1).FP= kFP(n1).FP;
% end
%%
[FEIn,curlFP]=GetCurlFP(kFP,FEVals);

CFP=zeros(8,9);

for n1=1:8
   for ny=1:3
       for nx=1:3
            nn=ny+(nx-1).*3;
            CFP(n1,nn)=curlFP(n1).cFP(ny,nx);
       end
   end
end

FP=zeros(8,9);

for n1=1:8
   for ny=1:3
       for nx=1:3
            nn=ny+(nx-1).*3;
            FP(n1,nn)=kFP(n1).FP(ny,nx);
       end
   end
end

figure(201);
clf;
hold on;
plot(curlFP(1).cFP(:),'rx-');
plot(curlFP(2).cFP(:),'gs-');
plot(curlFP(3).cFP(:),'bo-');
plot(curlFP(4).cFP(:),'k>-');
plot(curlFP(5).cFP(:),'rp-');
plot(curlFP(6).cFP(:),'g<-');
plot(curlFP(7).cFP(:),'k^-');
plot(curlFP(8).cFP(:),'kx-');