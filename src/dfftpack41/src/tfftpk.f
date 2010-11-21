      SUBROUTINE TFFTPK (IERROR)
C
C
C PURPOSE                TO DEMONSTRATE THE USE OF FFTPACK, AND TO
C                        TEST THE PERFORMANCE OF FFTPACK ON ONE
C                        WELL-CONDITIONED PROBLEM. 
C
C USAGE                  CALL TFFTPK (IERROR)
C
C ARGUMENTS              
C 
C ON OUTPUT              IERROR
C                          INTEGER VARIABLE SET TO ZERO IF FFTPACK
C                          CORRECTLY SOLVED THE TEST PROBLEM, AND 
C                          ONE IF FFTPACK FAILED.
C
C I/O                    IF THE TEST SUCCEEDS(FAILS), THE MESSAGE
C
C                           FFTPACK TEST SUCCESSFUL (UNSUCCESSFUL)
C
C                        IS WRITTEN ON UNIT 6. IN THE CASE OF FAILURE,
C                        ADDITIONAL MESSAGES ARE WRITTEN IDENTIFYING THE
C                        FAILURE MORE EXPLICITLY.
C 
C PRECISION              SINGLE
C
C REQUIRED LIBRARY       NONE
C FILES
C
C LANGUAGE               FORTRAN
C
C HISTORY                WRITTEN BY MEMBERS OF THE SCIENTIFIC 
C                        COMPUTING DIVISION OF NCAR,
C                        BOULDER COLORADO.
C
C ALGORITHM              FOR EACH OF THE ROUTINES, RFFTF, RFFTB, EZFFTF,
C                        AND EZFFTB IN THE FFTPACK PACKAGE A SIMILAR 
C                        TEST IS RUN. AN APPROPIATE VECTOR, FOR WHICH
C                        THE EXACT TRANSFORM IS KNOWN IS USED AS THE
C                        INPUT VECTOR. THE ROUTINE IS CALLED TO PERFORM
C                        THE TRANSFORM. THE CALCULATED TRANSFORM VECTOR
C                        IS COMPARED WITH THE EXACT TRANSFORM TO SEE
C                        WHETHER THE PERFORMANCE CRITERION IS MET WITHIN
C                        THE SPECIFED TOLERANCE.
C
C                        FOR RFFTF AND EZFFTF, A REAL VECTOR, THE ELEMENTS
C                        WHICH ARE EQUAL TO ONE, IS USED AS INPUT. THE
C                        TRANSFORMED VECTOR HAS THE FIRST ELEMENT EQUAL
C                        TO THE LENGTH OF THE INPUT VECTOR. ALL OTHER
C                        ELEMENTS ARE EQUAL TO ZERO.
C
C                        FOR RFFTB AND EZFFTB, THE INPUT VECTOR HAS FIRST
C                        ELEMENT EQUAL TO ONE AND ALL THE OTHER ELEMENTS
C                        EQUAL TO ZERO. THE TRANSFORMED VECTOR HAS ALL
C                        COMPONENTS EQUAL TO ONE.
C
C PORTABILITY            ANSI STANDARD
C
C
      PARAMETER( N=36 )
      INTEGER DIM1, DIM2
      PARAMETER( DIM1=2*N+15, DIM2=3*N+15, ND2=N/2 )
      REAL RLDAT(N), WRFFT(DIM1), WEZFFT(DIM2), A(ND2), B(ND2)
      DATA TOL/0.01/
C
C STATEMENT FUNCTION SMALL(EX) IS FOR TESTING WHETHER X IS CLOSE TO ZERO,
C INDEPENDENTLY OF MACHINE WORD SIZE. SMALL(EX) IS EXACTLY ZERO ONLY IF
C ABS(X) .LT. EPS/TOL, WHERE EPS IS THE MACHINE PRECESION AND TOL IS A
C TOLERANCE FACTOR USED TO CONTROL THE STRICTNESS OF THE TEST.
C
      SMALL(EX) = TRUNC(1.0+TOL*ABS(EX))-1.0
C
C CALL INITIALIZATION ROUTINE FOR RFFTF AND RFFTB.
C
      CALL RFFTI( N, WRFFT )
C  
C TEST OF RFFTF.
C
      DO 10 I = 1,N
 10   RLDAT(I) = 1.0
C
      CALL RFFTF( N, RLDAT, WRFFT )
C
C TEST RESULTS OF RFFTF
C
      ERROR = ABS( FLOAT(N) - RLDAT(1) )
      DO 15 I = 2,N
 15   ERROR = AMAX1( ERROR, ABS(RLDAT(I)) )
      IF( SMALL(ERROR) .EQ. 0 ) THEN
          IER1 = 0
      ELSE
          IER1 = 1
          WRITE(6,1001)
      END IF
C
C TEST OF RFFTB.
C
      RLDAT(1) = 1.0
      DO 20 I = 2,N
 20   RLDAT(I) = 0.0
C
      CALL RFFTB( N, RLDAT, WRFFT )
C
C TEST RESULTS OF RFFTB
C
      ERROR = 0.0
      DO 25 I = 1,N
 25   ERROR = AMAX1( ERROR, ABS(1.0 - RLDAT(I)) )
      IF( SMALL(ERROR) .EQ. 0 ) THEN
          IER2 = 0
      ELSE
          IER2 = 1
          WRITE(6,1002)
      END IF
C
C CALL INITIALIZATION ROUTINE EZFFTI FOR EZFFTF AND EZFFTB
C
      CALL EZFFTI( N, WEZFFT )
C
C TEST OF EZFFTF.
C
      DO 30 I = 1,N
 30   RLDAT(I) = 1.0
C
      CALL EZFFTF( N, RLDAT, AZERO, A, B, WEZFFT )
C
C TEST RESULTS OF EZFFTF
C
      ERROR = ABS( AZERO - 1.0 )
      DO 35 I = 1,ND2
 35   ERROR = AMAX1( ABS(A(I))+ABS(B(I)), ERROR )
      IF( SMALL(ERROR) .EQ. 0 ) THEN
          IER3 = 0
      ELSE
          IER3 = 1
          WRITE(6,1003)
      END IF 
C     
C TEST OF EZFFTB.
C
      AZERO = 1.0
      DO 40 I = 1,ND2
      A(I) = 0.0
 40   B(I) = 0.0
C
      CALL EZFFTB( N, RLDAT, AZERO, A, B, WEZFFT )
C
C TEST RESULTS OF EZFFTB
C
      ERROR = 0.0
      DO 45 I = 1,N
 45   ERROR = AMAX1( ABS(1.0 - RLDAT(I)), ERROR)
      IF( SMALL(ERROR) .EQ. 0 ) THEN
          IER4 = 0
      ELSE
          IER4 = 1
          WRITE(6,1004)
      END IF
C
C
      IERROR = IER1 + IER2 + IER3 + IER4
      IF(IERROR .EQ. 0 ) THEN
         WRITE(6,998)
      ELSE
         IERROR = 1
         WRITE(6,999)
      END IF
  998 FORMAT(' FFTPACK TEST SUCCESSFUL')
  999 FORMAT(' FFTPACK TEST UNSUCCESSFUL')
 1001 FORMAT(' IN FFTPACK, ENTRY RFFTF RESULTS IN ERROR')
 1002 FORMAT(' IN FFTPACK, ENTRY RFFTB RESULTS IN ERROR')
 1003 FORMAT(' IN FFTPACK, ENTRY EZFFTF RESULTS IN ERROR')
 1004 FORMAT(' IN FFTPACK, ENTRY EZFFTB RESULTS IN ERROR')
      RETURN
      END
      FUNCTION TRUNC(X)
C
C TRUNC IS A PORTABLE FORTRAN FUNCTION WHICH TRUNCATES A VALUE TO THE
C MACHINE SINGLE PRECISION WORD SIZE, REGARDLESS OF WHETHER LONGER
C PRECISION INTERNAL REGISTERS ARE USED FOR FLOATING POINT ARITHMETIC IN
C COMPUTING THE VALUE INPUT TO TRUNC.  THE METHOD USED IS TO FORCE A
C STORE INTO MEMORY BY USING A COMMON BLOCK IN ANOTHER SUBROUTINE.
C
      COMMON /VALUE/ V
      CALL STORES(X)
      TRUNC=V
      RETURN
      END
      SUBROUTINE STORES(X)
C
C FORCES THE ARGUMENT VALUE X TO BE STORED IN MEMORY LOCATION V.
C
      COMMON /VALUE/ V
      V=X
      RETURN
      END
