C
*DECK VISPRWAR
      SUBROUTINE VISPRWAR(VISERRORNO,VISSUBNAME)
C     ******************************************************************
C     * THIS ROUTINE PRINTS WARNING MESSAGES. VISERRORNO CONTAINS THE  *
C     * NUMBER OF THE MESSAGE. VISSUBNAME CONTAINS THE NAME OF THE     *
C     * CALLING SUBROUTINE.                                            *
C     ******************************************************************
C
C#include "comerrn"
C#include "cominou"

	INCLUDE 'INCLUDE/comerrn'
	INCLUDE 'INCLUDE/cominou'

C
      CHARACTER*(*) VISSUBNAME
      INTEGER       VISERRORNO
C
      IF (VISERRORNO.EQ.VISWARCROP) WRITE(VISSTDERRO,1)  1,VISSUBNAME
      IF (VISERRORNO.EQ.VISWARNAME) WRITE(VISSTDERRO,9)  9,VISSUBNAME
      IF (VISERRORNO.EQ.VISWARFIRS) WRITE(VISSTDERRO,11)  11,VISSUBNAME
      IF (VISERRORNO.EQ.VISWARLAST) WRITE(VISSTDERRO,12)  12,VISSUBNAME
      IF (VISERRORNO.EQ.VISWARFORM) WRITE(VISSTDERRO,13)  13,VISSUBNAME
C
C     *FORMATS
    1 FORMAT(//I2,1X,'***',A,'*WARNING: CROPSIZ LESS THAN 1. NO',
     A                   ' ACTIONS PERFORMED.')
    9 FORMAT(//I2,1X,'***',A,'*WARNING: FILE NAME DOES NOT BEGIN WITH',
     A                   ' A LETTER. STANDARD NAME HAS BEEN TAKEN.')
   11 FORMAT(//I2,1X,'***',A,'*WARNING: FIRST MUST SATISFY FIRST>=1.')
   12 FORMAT(//I2,1X,'***',A,'*WARNING: LAST  MUST SATISFY LAST',
     A                   ' <=51')
   13 FORMAT(//I2,1X,'***',A,'*WARNING: WRONG FORMAT, ACSII ASSUMED.')
      END