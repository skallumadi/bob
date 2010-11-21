C     SUBROUTINE RFFTI(N,WSAVE)                                                 
C                                                                               
C     SUBROUTINE RFFTI INITIALIZES THE ARRAY WSAVE WHICH IS USED IN             
C     BOTH RFFTF AND RFFTB. THE PRIME FACTORIZATION OF N TOGETHER WITH          
C     A TABULATION OF THE TRIGONOMETRIC FUNCTIONS ARE COMPUTED AND              
C     STORED IN WSAVE.                                                          
C                                                                               
C     INPUT PARAMETER                                                           
C                                                                               
C     N       THE LENGTH OF THE SEQUENCE TO BE TRANSFORMED.                     
C                                                                               
C     OUTPUT PARAMETER                                                          
C                                                                               
C     WSAVE   A WORK ARRAY WHICH MUST BE DIMENSIONED AT LEAST 2*N+15.           
C             THE SAME WORK ARRAY CAN BE USED FOR BOTH RFFTF AND RFFTB          
C             AS LONG AS N REMAINS UNCHANGED. DIFFERENT WSAVE ARRAYS            
C             ARE REQUIRED FOR DIFFERENT VALUES OF N. THE CONTENTS OF           
C             WSAVE MUST NOT BE CHANGED BETWEEN CALLS OF RFFTF OR RFFTB.        
C                                                                               
      SUBROUTINE RFFTI (N,WSAVE)                                                
      DIMENSION       WSAVE(*)                                                  
C                                                                               
      IF (N .EQ. 1) RETURN                                                      
      CALL RFFTI1 (N,WSAVE(N+1),WSAVE(2*N+1))                                   
      RETURN                                                                    
      END                                                                       
