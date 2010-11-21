C     SUBROUTINE SINQI(N,WSAVE)                                                 
C                                                                               
C     SUBROUTINE SINQI INITIALIZES THE ARRAY WSAVE WHICH IS USED IN             
C     BOTH SINQF AND SINQB. THE PRIME FACTORIZATION OF N TOGETHER WITH          
C     A TABULATION OF THE TRIGONOMETRIC FUNCTIONS ARE COMPUTED AND              
C     STORED IN WSAVE.                                                          
C                                                                               
C     INPUT PARAMETER                                                           
C                                                                               
C     N       THE LENGTH OF THE SEQUENCE TO BE TRANSFORMED. THE METHOD          
C             IS MOST EFFICIENT WHEN N IS A PRODUCT OF SMALL PRIMES.            
C                                                                               
C     OUTPUT PARAMETER                                                          
C                                                                               
C     WSAVE   A WORK ARRAY WHICH MUST BE DIMENSIONED AT LEAST 3*N+15.           
C             THE SAME WORK ARRAY CAN BE USED FOR BOTH SINQF AND SINQB          
C             AS LONG AS N REMAINS UNCHANGED. DIFFERENT WSAVE ARRAYS            
C             ARE REQUIRED FOR DIFFERENT VALUES OF N. THE CONTENTS OF           
C             WSAVE MUST NOT BE CHANGED BETWEEN CALLS OF SINQF OR SINQB.        
C                                                                               
      SUBROUTINE SINQI (N,WSAVE)                                                
      DIMENSION       WSAVE(*)                                                  
C                                                                               
      CALL COSQI (N,WSAVE)                                                      
      RETURN                                                                    
      END                                                                       
