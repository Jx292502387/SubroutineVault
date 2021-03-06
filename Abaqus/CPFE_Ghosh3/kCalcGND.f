      SUBROUTINE kcalcGND(FCC_S, FCC_N, FCC_T, 
     + CUBIC_S, CUBIC_N, CUBIC_T,
     + RhoS,RhoET,RhoEN, CFP,
     + BURGVAL)
      INCLUDE 'ABA_PARAM.INC'
	  
      REAL*8,parameter  :: zero=1.0e-8
      INTEGER, PARAMETER :: NDOF = 3
      INTEGER, PARAMETER :: NFCC = 12
      INTEGER, PARAMETER :: NCUB = 6
      
      REAL*8, INTENT(IN) :: FCC_S(NDOF,NFCC), FCC_N(NDOF,NFCC)
      REAL*8, INTENT(IN) :: CUBIC_S(NDOF,NCUB), CUBIC_N(NDOF,NCUB)
      REAL*8, INTENT(IN) :: FCC_T(NDOF,NFCC), CUBIC_T(NDOF,NCUB)
      REAL*8,intent(in) :: BURGVAL, CFP(9)
      Real*8,intent(out) :: RhoS(18),RhoET(18),RhoEN(18)	 

      REAL*8 :: tempDIR(3), tempNorm(3)
      
      INTEGER, parameter:: MZ=9, NZ=54
      INTEGER :: ISTART, IFIN, NCOL, MX, NX , I
      REAL*8 :: burgX(3), sslip(3),nnorm(3),tnorm(3),
     1 screw(3,3),edgeN(3,3),edgeT(3,3),
     1 scol(9),encol(9),etcol(9),
     1 rhoOutput(54),gv(9)
      DOUBLE PRECISION,dimension(:),allocatable :: S
      DOUBLE PRECISION,dimension(:,:),allocatable :: A,U,V,
     + Sinv,Ainv,tempA, UT, AM   
	 

      ALLOCATE(A(mz,nz),AM(mz,nz),V(nz,nz),U(mz,mz),Sinv(nz,mz),
     1  Ainv(nz,mz),tempA(nz,mz),UT(mz,mz),
     1  S(mz), STAT=ialloc)     
      A=0.;AM=0.;V=0.;S=0.;U=0.;Sinv=0.;Ainv=0.;tempA=0.;UT=0. 
	 
c -----------------------
      IF(MAXVAL(ABS(CFP)) <= 1.0e-9) THEN 
        DO i = 1, 18     
        rhos(I) = 0.0
        rhoen(I) = 0.0
        rhoet(I) = 0.0	
        END DO
      ELSE
         gv = CFP
c        gv = reshape(CFP,(/9/))  
        DO I=1,18 ! 1-12 for fcc type   

            IF (I.LE.12) THEN
            burgX = FCC_S(:,I) !slip direction
            burgX = burgX*BURGVAL       
            sslip = FCC_S(:,I)
            nnorm = FCC_N(:,I) !Slip plane normal
c            CALL CrossProd(sslip,nnorm,tnorm)  
            tnorm = FCC_T(:,I)
            ELSE
            burgX = CUBIC_S(:,I-12) !slip direction
            burgX = burgX*BURGVAL       
            sslip = CUBIC_S(:,I-12)
            nnorm = CUBIC_N(:,I-12) !Slip plane normal
c            CALL CrossProd(sslip,nnorm,tnorm)  
            tnorm = CUBIC_T(:,I-12)           
            ENDIF
            
            CALL DyadicProd(sslip,burgX,screw)
            CALL DyadicProd(nnorm,burgX,edgeN)
            CALL DyadicProd(tnorm,burgX,edgeT)    
            CALL Convert2Col(screw,scol)
            CALL Convert2Col(edgeN,encol)
            CALL Convert2Col(edgeT,etcol)     
            DO J=1,9
                A(J,I)    = scol(J)
                A(J,I+18) = encol(J)
                A(J,I+36) = etcol(J)
            END DO                
        END DO   ! Generate current A-matrix loop
  ! ***********************************************************************    
      ! Matrix inversion by singular value decomposition: A+ = [V][S+][U*]
  ! ***********************************************************************   
        CALL SVD(A,U,S,V,MZ,NZ)       
        DO i = 1, ubound(S,1)
            IF (S(i) > 1e-6) THEN
                Sinv(i,i)= 1.0 / S(i)
            END IF
        END DO   

c       INTEGER, parameter:: M=3,N=3,L0=24,L1=24,L2=12,KM=6,KN=6
c               MZ=9;NZ=54           
        UT=transpose(U)     
        NCOL=NZ;MX=NZ;NX=MZ 
        CALL KMLTM (V,Sinv,tempA,NCOL,MX,NX)     
        NCOL=MZ;MX=NZ;NX=MZ 
        CALL KMLTM (tempA,UT,Ainv,NCOL,MX,NX) 
        CALL KMLT54991(Ainv,gv,rhoOutput)
        rhos = rhoOutput(1:18)
        rhoen = rhoOutput(19:36)
        rhoet = rhoOutput(37:54)
       END IF

      RETURN
      END
      
c --------------------------------------      
      SUBROUTINE KMLT54991(DMIN,DVIN,DVOUT)
      INCLUDE 'aba_param.inc'
      PARAMETER (M=54,N=9)
      DIMENSION DMIN(M,N),DVIN(N),DVOUT(M)

      DO i=1,54
        x = 0.
        DO j=1,9
         x = x + DMIN(i,j)*DVIN(j)
        END DO
        
        DVOUT(i) = x
      END DO

      RETURN
      END