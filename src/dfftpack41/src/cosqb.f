C     SUBROUTINE COSQB(N,X,WSAVE)                                               
C                                                                               
C     SUBROUTINE COSQB COMPUTES THE FAST FOURIER TRANSFORM OF QUARTER           
C     WAVE DATA. THAT IS , COSQB COMPUTES A SEQUENCE FROM ITS                   
C     REPRESENTATION IN TERMS OF A COSINE SERIES WITH ODD WAVE NUMBERS.         
C     THE TRANSFORM IS DEFINED BELOW AT OUTPUT PARAMETER X.                     
C                                                                               
C     COSQB IS THE UNNORMALIZED INVERSE OF COSQF SINCE A CALL OF COSQB          
C     FOLLOWED BY A CALL OF COSQF WILL MULTIPLY THE INPUT SEQUENCE X            
C     BY 4*N.                                                                   
C                                                                               
C     THE ARRAY WSAVE WHICH IS USED BY SUBROUTINE COSQB MUST BE                 
C     INITIALIZED BY CALLING SUBROUTINE COSQI(N,WSAVE).                         
C                                                                               
C                                                                               
C     INPUT PARAMETERS                                                          
C                                                                               
C     N       THE LENGTH OF THE ARRAY X TO BE TRANSFORMED.  THE METHOD          
C             IS MOST EFFICIENT WHEN N IS A PRODUCT OF SMALL PRIMES.            
C                                                                               
C     X       AN ARRAY WHICH CONTAINS THE SEQUENCE TO BE TRANSFORMED            
C                                                                               
C     WSAVE   A WORK ARRAY THAT MUST BE DIMENSIONED AT LEAST 3*N+15             
C             IN THE PROGRAM THAT CALLS COSQB. THE WSAVE ARRAY MUST BE          
C             INITIALIZED BY CALLING SUBROUTINE COSQI(N,WSAVE) AND A            
C             DIFFERENT WSAVE ARRAY MUST BE USED FOR EACH DIFFERENT             
C             VALUE OF N. THIS INITIALIZATION DOES NOT HAVE TO BE               
C             REPEATED SO LONG AS N REMAINS UNCHANGED THUS SUBSEQUENT           
C             TRANSFORMS CAN BE OBTAINED FASTER THAN THE FIRST.                 
C                                                                               
C     OUTPUT PARAMETERS                                                         
C                                                                               
C     X       FOR I=1,...,N                                                     
C                                                                               
C                  X(I)= THE SUM FROM K=1 TO K=N OF                             
C                                                                               
C                    4*X(K)*COS((2*K-1)*(I-1)*PI/(2*N))                         
C                                                                               
C                  A CALL OF COSQB FOLLOWED BY A CALL OF                        
C                  COSQF WILL MULTIPLY THE SEQUENCE X BY 4*N.                   
C                  THEREFORE COSQF IS THE UNNORMALIZED INVERSE                  
C                  OF COSQB.                                                    
C                                                                               
C     WSAVE   CONTAINS INITIALIZATION CALCULATIONS WHICH MUST NOT               
C             BE DESTROYED BETWEEN CALLS OF COSQB OR COSQF.                     
C                                                                               
      SUBROUTINE COSQB (N,X,WSAVE)                                              
      DIMENSION       X(*)       ,WSAVE(*)                                      
      DATA TSQRT2 /2.82842712474619/                                            
C                                                                               
      IF (N-2) 101,102,103                                                      
  101 X(1) = 4.*X(1)                                                            
      RETURN                                                                    
  102 X1 = 4.*(X(1)+X(2))                                                       
      X(2) = TSQRT2*(X(1)-X(2))                                                 
      X(1) = X1                                                                 
      RETURN                                                                    
  103 CALL COSQB1 (N,X,WSAVE,WSAVE(N+1))                                        
      RETURN                                                                    
      END                                                                       
