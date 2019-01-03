clear;

load SlipSystemsAllen.mat;

Stress=[-300.0 0 0;0 0 0;0 0 0];
TauC=115.0./sqrt(6);
Gdref=1e-3;
TauCut=300.0;

MyLoc=[0 1;0 1;0 1];
%%
Tau=zeros(18,1);

for n1=1:12
   Tau(n1)=FCCSlips(n1).n.'*(Stress*FCCSlips(n1).s) ;
end
for n1=1:6
   Tau(n1+12)=CubicSlips(n1).n.'*(Stress*CubicSlips(n1).s) ;
end

%%
Gdot=zeros(18,1);

for n1=1:18
   TauEff=abs(Tau(n1))-TauC;
   if TauEff>0.0
       Gdot(n1)=Gdref*sign(Tau(n1))*sinh(TauEff./TauCut);
   end
end

%% Now Start With Points

NatCoords=[...
    -1 1 1;...
    -1 -1 1;...
    -1 1 -1;...
    -1 -1 -1;...
    1 1 1;...
    1 -1 1;...
    1 1 -1;...
    1 -1 -1;...
    ];

GaussNatCoords=NatCoords./(sqrt(3));

FullPos=[
    MyLoc(1,1),MyLoc(2,1+1),MyLoc(3,1+1);...
    MyLoc(1,1),MyLoc(2,1),MyLoc(3,1+1);...
    MyLoc(1,1),MyLoc(2,1+1),MyLoc(3,1);...
    MyLoc(1,1),MyLoc(2,1),MyLoc(3,1);...
    MyLoc(1,1+1),MyLoc(2,1+1),MyLoc(3,1+1);...
    MyLoc(1,1+1),MyLoc(2,1),MyLoc(3,1+1);...
    MyLoc(1,1+1),MyLoc(2,1+1),MyLoc(3,1);...
    MyLoc(1,1+1),MyLoc(2,1),MyLoc(3,1);...
    ];

FullPosShape=zeros(8,3);

for n1=1:3
    for n2=1:8
        for n3=1:8
            FullPosShape(n2,n1)=FullPosShape(n2,n1)+...
                FullPos(n3,n1)*0.125*...
                (1+NatCoords(n2,1)*NatCoords(n3,1))*...
                (1+NatCoords(n2,2)*NatCoords(n3,2))*...
                (1+NatCoords(n2,3)*NatCoords(n3,3));
        end
    end
end

GaussPosShape=zeros(8,3);

for n1=1:3
    for n2=1:8
        for n3=1:8
            GaussPosShape(n2,n1)=GaussPosShape(n2,n1)+...
                FullPos(n3,n1)*0.125*...
                (1+GaussNatCoords(n2,1)*NatCoords(n3,1))*...
                (1+GaussNatCoords(n2,2)*NatCoords(n3,2))*...
                (1+GaussNatCoords(n2,3)*NatCoords(n3,3));
        end
    end
end


figure(1);
clf;
hold on;
plot3(FullPos(:,1),FullPos(:,2),FullPos(:,3),'rx');
plot3(GaussPosShape(:,1),GaussPosShape(:,2),GaussPosShape(:,3),'bs');

%%


for n1=1:12
   AllSlips(n1).n=FCCSlips(n1).n;
   AllSlips(n1).s=FCCSlips(n1).s;
   AllSlips(n1).t=FCCSlips(n1).t;
end
for n1=1:6
   AllSlips(n1+12).n=CubicSlips(n1).n;
   AllSlips(n1+12).s=CubicSlips(n1).s;
   AllSlips(n1+12).t=CubicSlips(n1).t;
end
%%
myseed=23;
rng(myseed);
%[CurlOut]=GetGaussianCurl(fc,xnat8,gauss,gausscoords);
Co=rand(3,8);

Co=zeros(3,8);
Co(:,1)=1;

%%
RhoS=zeros(8,18);
RhoEN=zeros(8,18);
RhoET=zeros(8,18);

RhoTS=zeros(8,18);
RhoTEN=zeros(8,18);
RhoTET=zeros(8,18);

%%
Abq(1).FpT=[1.0002443334375797,-1.4828348204075375E-019,1.2287834117486886E-020;
   9.4826603783529893E-021,0.99951149380193360,3.8501280810418422E-020;
   9.4849530115911393E-021,-5.2872012677502314E-020,1.0002443334375797];

Abq(2).FpT=[1.0002443334375797       -1.8961560136889899E-020   9.4849530115911393E-021;
   9.4826603783529893E-021  0.99951149380193360        9.9327136545937940E-021;
   9.4849530115911393E-021  -2.3138126329805331E-020   1.0002443334375797];

Abq(3).FpT=[1.0002443334375797       -1.5354691065991529E-019   1.0540471810788776E-020;
   9.0591484040281642E-021  0.99951149380193360        3.7760001537523061E-020;
   9.9085723249798318E-021  -5.7608959126734821E-020   1.0002443334375797  ];

Abq(4).FpT=[1.0002443334375797       -1.8114705772223472E-020   6.5196995369435259E-021;
   9.0591484040281642E-021  0.99951149380193360        1.5755553479974051E-020;
   6.5196995369435259E-021  -2.8746844958193389E-020   1.0002443334375797 ];

Abq(5).FpT=[1.0002443334375797       -1.5240925963540904E-019   1.0858186295830295E-020;
   9.0591484040281642E-021  0.99951149380193360        3.8104190447688957E-020;
   9.9085723249798318E-021  -5.7899987015106059E-020   1.0002443334375797 ];

Abq(6).FpT=[1.0002443334375797       -1.8114705772223472E-020   9.9085723249798318E-021;
   9.0591484040281642E-021  0.99951149380193360        1.5755553479974051E-020;
   9.9085723249798318E-021  -2.7052424801384953E-020   1.0002443334375797   ];

Abq(7).FpT=[1.0002443334375797       -1.5595611503172737E-019   1.2128976685541014E-020;
   9.9592289863413154E-021  0.99951149380193360        3.8262994051452316E-020;
   9.9615247208522742E-021  -5.3401157662422040E-020   1.0002443334375797  ];

Abq(8).FpT=[1.0002443334375797       -1.9914015845872200E-020   9.9615247208522742E-021;
   9.9592289863413154E-021  0.99951149380193360        1.0356329590000483E-020;
   9.9615247208522742E-021  -2.3878924881061667E-020   1.0002443334375797];

for n1=1:8
   Abq(n1).Fp=Abq(n1).FpT.'; 
end

%%

kDGA=[-2.0865114119927305E-005,0.0000000000000000,2.0865114119927285E-005,...
   0.0000000000000000        2.0865114119927285E-005  -2.0865114119927285E-005,...
  -2.0865114119927285E-005   2.0865114119927285E-005   0.0000000000000000,...     
  -2.0865114119927305E-005   0.0000000000000000        2.0865114119927285E-005,...
   0.0000000000000000        0.0000000000000000        0.0000000000000000,...     
   0.0000000000000000        0.0000000000000000        0.0000000000000000;...
   %
   -2.0865114119927227E-005   0.0000000000000000        2.0865114119927227E-005,...
   0.0000000000000000        2.0865114119927227E-005  -2.0865114119927227E-005,...
  -2.0865114119927227E-005   2.0865114119927227E-005   0.0000000000000000,...     
  -2.0865114119927227E-005   0.0000000000000000        2.0865114119927227E-005,...
   0.0000000000000000        0.0000000000000000        0.0000000000000000,...     
   0.0000000000000000        0.0000000000000000        0.0000000000000000;...
   %
   -2.0865114119927305E-005   0.0000000000000000        2.0865114119927285E-005,...
   0.0000000000000000        2.0865114119927285E-005  -2.0865114119927285E-005,...
  -2.0865114119927285E-005   2.0865114119927285E-005   0.0000000000000000,...     
  -2.0865114119927305E-005   0.0000000000000000        2.0865114119927285E-005,...
   0.0000000000000000        0.0000000000000000        0.0000000000000000,...     
   0.0000000000000000        0.0000000000000000        0.0000000000000000;... 
   %
   -2.0865114119927285E-005   0.0000000000000000        2.0865114119927285E-005,...
   0.0000000000000000        2.0865114119927285E-005  -2.0865114119927285E-005,...
  -2.0865114119927285E-005   2.0865114119927285E-005   0.0000000000000000,...     
  -2.0865114119927285E-005   0.0000000000000000        2.0865114119927285E-005,...
   0.0000000000000000        0.0000000000000000        0.0000000000000000,...     
   0.0000000000000000        0.0000000000000000        0.0000000000000000;...
   %
     -2.0865114119927305E-005   0.0000000000000000        2.0865114119927285E-005,...
   0.0000000000000000        2.0865114119927285E-005  -2.0865114119927285E-005,...
  -2.0865114119927285E-005   2.0865114119927285E-005   0.0000000000000000,...     
  -2.0865114119927305E-005   0.0000000000000000        2.0865114119927285E-005,...
   0.0000000000000000        0.0000000000000000        0.0000000000000000,...     
   0.0000000000000000        0.0000000000000000        0.0000000000000000;...
   %
   -2.0865114119927285E-005   0.0000000000000000        2.0865114119927285E-005,...
   0.0000000000000000        2.0865114119927285E-005  -2.0865114119927285E-005,...
  -2.0865114119927285E-005   2.0865114119927285E-005   0.0000000000000000,...     
  -2.0865114119927285E-005   0.0000000000000000        2.0865114119927285E-005,...
   0.0000000000000000        0.0000000000000000        0.0000000000000000,...     
   0.0000000000000000        0.0000000000000000        0.0000000000000000;...
   %
   -2.0865114119927305E-005   0.0000000000000000        2.0865114119927285E-005,...
   0.0000000000000000        2.0865114119927285E-005  -2.0865114119927285E-005,...
  -2.0865114119927285E-005   2.0865114119927285E-005   0.0000000000000000,...     
  -2.0865114119927305E-005   0.0000000000000000        2.0865114119927285E-005,...
   0.0000000000000000        0.0000000000000000        0.0000000000000000,...     
   0.0000000000000000        0.0000000000000000        0.0000000000000000;...
   %
   -2.0865114119927227E-005   0.0000000000000000        2.0865114119927227E-005,...
   0.0000000000000000        2.0865114119927227E-005  -2.0865114119927227E-005,...
  -2.0865114119927227E-005   2.0865114119927227E-005   0.0000000000000000,...     
  -2.0865114119927227E-005   0.0000000000000000        2.0865114119927227E-005,...
   0.0000000000000000        0.0000000000000000        0.0000000000000000,...     
   0.0000000000000000        0.0000000000000000        0.0000000000000000;...
];
%%
ib=1./(0.249e-3);
for nSl=1:18
    fc=zeros(3,8);
    fcT=zeros(3,8);
    for nG=1:8
        x=GaussPosShape(nG,1);
        y=GaussPosShape(nG,2);
        z=GaussPosShape(nG,3);

    [U,Fp,FpT,FpN,FpTN,dFpN,dFpTN]=...
        GetAnalVals(x,y,z,AllSlips(nSl).n,Co);
    
    ASol(nG,nSl).Fp=ib.*kDGA(nG,nSl).*Abq(nG).Fp;
    ASol(nG,nSl).FpT=ib.*kDGA(nG,nSl).*Abq(nG).FpT;
    ASol(nG,nSl).FpN=ib.*kDGA(nG,nSl).*Abq(nG).Fp*AllSlips(nSl).n;
    ASol(nG,nSl).FpTN=ib.*kDGA(nG,nSl).*Abq(nG).FpT*AllSlips(nSl).n;
    ASol(nG,nSl).dFpN=dFpN;
    ASol(nG,nSl).dFpTN=dFpTN;
    
    fc(:,nG)=ASol(nG,nSl).FpN;
    fcT(:,nG)=ASol(nG,nSl).FpTN;
    end
    [CurlOut]=GetGaussianCurl(fc,NatCoords,NatCoords,GaussPosShape.');
    [CurlOutT]=GetGaussianCurl(fcT,NatCoords,NatCoords,GaussPosShape.');
    Xsol(nSl).CurlOut=CurlOut;
    Xsol(nSl).CurlOutT=CurlOutT;
    
    for nG=1:8
    RhoS(nG,nSl)=fc(:,nG).'*AllSlips(nSl).s;
    RhoEN(nG,nSl)=fc(:,nG).'*AllSlips(nSl).n;
    RhoET(nG,nSl)=fc(:,nG).'*AllSlips(nSl).t;

    RhoTS(nG,nSl)=fcT(:,nG).'*AllSlips(nSl).s;
    RhoTEN(nG,nSl)=fcT(:,nG).'*AllSlips(nSl).n;
    RhoTET(nG,nSl)=fcT(:,nG).'*AllSlips(nSl).t;
    end
end


RhoXS=[RhoS;RhoTS];
RhoXEN=[RhoEN;RhoTEN];
RhoXET=[RhoET;RhoTET];

RS=zeros(8,1);
REN=zeros(8,1);
RET=zeros(8,1);

RTS=zeros(8,1);
RTEN=zeros(8,1);
RTET=zeros(8,1);

for nG=1:8
   for nS=1:18
       RS(nG)=RS(nG)+RhoS(nG,nS).^2;
       REN(nG)=REN(nG)+RhoEN(nG,nS).^2;
       RET(nG)=RET(nG)+RhoET(nG,nS).^2;
       
       RTS(nG)=RTS(nG)+RhoTS(nG,nS).^2;
       RTEN(nG)=RTEN(nG)+RhoTEN(nG,nS).^2;
       RTET(nG)=RTET(nG)+RhoTET(nG,nS).^2;
   end
end

RA=RS+REN+RET;
RTA=RTS+RTEN+RTET;