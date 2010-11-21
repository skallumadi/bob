C     SUBROUTINE COSTI(N,WSAVE)                                                 
C                                                                               
C     SUBROUTINE COSTI INITIALIZES THE ARRAY WSAVE WHICH IS USED IN             
C     SUBROUTINE COST. THE PRIME FACTORIZATION OF N TOGETHER WITH               
C     A TABULATION OF THE TRIGONOMETRIC FUNCTIONS ARE COMPUTED AND              
C     STORED IN WSAVE.                                                          
C                                                                               
C     INPUT PARAMETER                                                           
C                                                                               
C     N       THE LENGTH OF THE SEQUENCE TO BE TRANSFORMED.  THE METHOD         
C             IS MOST EFFICIENT WHEN N-1 IS A PRODUCT OF SMALL PRIMES.          
C                                                                               
C     OUTPUT PARAMETER                                                          
C                                                                               
C     WSAVE   A WORK ARRAY WHICH MUST BE DIMENSIONED AT LEAST 3*N+15.           
C             DIFFERENT WSAVE ARRAYS ARE REQUIRED FOR DIFFERENT VALUES          
C             OF N. THE CONTENTS OF WSAVE MUST NOT BE CHANGED BETWEEN           
C             CALLS OF COST.                                                    
C                                                                               
      SUBROUTINE COSTI (N,WSAVE)                                                
      DIMENSION       WSAVE(*)                                                  
C                                                                               
      PI = PIMACH(DUM)                                                          
      IF (N .LE. 3) RETURN                                                      
      NM1 = N-1                                                                 
      NP1 = N+1                                                                 
      NS2 = N/2                                                                 
      DT = PI/FLOAT(NM1)                                                        
      FK = 0.                                                                   
      DO 101 K=2,NS2                                                            
         KC = NP1-K                                                             
         FK = FK+1.                                                             
         WSAVE(K) = 2.*SIN(FK*DT)                                               
         WSAVE(KC) = 2.*COS(FK*DT)                                              
  101 CONTINUE                                                                  
      CALL RFFTI (NM1,WSAVE(N+1))                                               
      RETURN                                                                    
      END                                                                       
