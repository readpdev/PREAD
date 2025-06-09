      *%METADATA                                                       *
      * %TEXT Fix the folder pointers from actual folder               *
      *%EMETADATA                                                      *
      *
      *
     FFOLDER    IP   F  256        DISK
     FMRPTDIR1  UF   E           K DISK
     F                                     RENAME(RPTDIR:RPTDIR1)
     FQSYSPRT   O    F  132        PRINTER OFLIND(*INOF)
     D                 DS
     D  ZFILNU                 1      4B 0
      *
     D HEX1            C                   CONST(X'0000001F')
      *
     IFOLDER    NS
     I                                  1    1  RECTYP
     I                                  3   12  @FLDR
     I                                 13   22  @FLIB
     I                                 23   32  @FILNA
     I                                 33   42  @JOBNA
     I                                 43   52  @USRNA
     I                                 53   58  @JOBNU
     I                             B   59   62 0@FILNU
     I                                255  256  RECTY2
     I                             B  105  108 0PTRSFA
     I                             B  109  112 0PTRSFD
     I                             B  113  116 0PTRSFP
     I                                122  131  REPID
     I                             B  182  185 0PTRSFE
     I                             B  186  189 0PAKPTR
     I                             B  190  193 0RPTREC
     I                                205  205  PACKED
     I                                  2    5  PGTBL1
      *
      *****************************************************************
      * MAIN PROGRAM
      *****************************************************************
    OC   OF              EXCEPT    PRTHED
     C                   ADD       1             RR                9 0
      *
<--1 C     *IN55         IFEQ      '1'
<--2 C     RECTYP        IFEQ      '0'
|    C     RECTY2        ANDEQ     '  '
|   GC                   GOTO      START
--E2 C                   ELSE
|   GC                   GOTO      END
|__2 C                   ENDIF
|__1 C                   ENDIF
      *
      *>>>>>>>>>>START
     C     START         TAG
<--1 C     RECTYP        IFEQ      '0'
|    C     RECTY2        ANDEQ     '  '
|    C                   Z-ADD     0             RPTRR             9 0
|    C                   MOVE      'N'           DONE              1
|    C                   MOVE      'N'           DONE2             1
|     * SAVE 0 RECORD VALUES
|    C                   MOVE      PACKED        PAK               1
|    C                   Z-ADD     PTRSFA        FILSFA            9 0
|    C                   Z-ADD     PTRSFD        FILSFD            9 0
|    C                   Z-ADD     PTRSFP        FILSFP            9 0
|    C                   Z-ADD     PTRSFE        FILSFE            9 0
|    C                   Z-ADD     PAKPTR        FILSFC            9 0
|    C                   Z-ADD     RPTREC        FILSDD            9 0
|    C                   MOVE      @FLDR         ZFLDR            10
|    C                   MOVE      @FLIB         ZFLIBR           10
|    C                   MOVE      @JOBNA        ZJOBNA           10
|    C                   MOVE      @USRNA        ZUSRNA           10
|    C                   MOVE      @JOBNU        ZJOBNU            6
|    C                   MOVE      @FILNA        ZFILNA           10
|    C                   Z-ADD     @FILNU        ZFILNU
|    C                   MOVE      REPID         ZREPID           10
|__1 C                   ENDIF
      *
     C                   ADD       1             RPTRR             9 0
      *
<--1 C     RECTYP        IFEQ      '1'
|    C     RPTRR         ANDEQ     2
|    C                   Z-ADD     RR            ACTSFA            9 0
|     * GET MRPTDIR VALUES
|   IC     L1KEY         CHAIN     MRPTDIR1                           55
<--2 C     *IN55         IFEQ      *ON
|    C                   Z-ADD     0             LOCSFA
|    C                   Z-ADD     0             LOCSFD
|    C                   Z-ADD     0             LOCSFP
|    C                   Z-ADD     0             LOCSFC
|   GC                   GOTO      END
--E2 C                   ELSE
|    C                   MOVE      REPLOC        TSTLOC            1
<--3 C     TSTLOC        IFEQ      ' '
|    C                   MOVE      '0'           TSTLOC
|__3 C                   ENDIF
<--3 C     TSTLOC        IFNE      '0'
|    C                   Z-ADD     0             LOCSFA
|    C                   Z-ADD     0             LOCSFD
|    C                   Z-ADD     0             LOCSFP
|    C                   Z-ADD     0             LOCSFC
|   GC                   GOTO      END
|__3 C                   ENDIF
|__2 C                   ENDIF
|__1 C                   ENDIF
      *
<--1 C     RECTYP        IFEQ      '3'
|    C     RECTY2        ANDEQ     '  '
|    C     PGTBL1        ANDEQ     HEX1
|    C     DONE          ANDNE     'Y'
|    C                   Z-ADD     RR            ACTSFP            9 0
|    C                   MOVE      'Y'           DONE              1
<--2 C     PAK           IFNE      '1'
|    C     ACTSFA        ADD       13            ACTSFD            9 0
|    C                   Z-ADD     0             ACTSFC            9 0
|    C                   MOVE      *BLANKS       ERROR             3
<--3 C     LOCSFA        IFNE      ACTSFA
|    C     LOCSFD        ORNE      ACTSFD
|    C     LOCSFP        ORNE      ACTSFP
|    C     LOCSFC        ORNE      ACTSFC
|    C                   MOVE      '***'         ERROR
|    C                   ADD       1             COUNT             9 0
|   OC   22              EXCEPT    PRTKEY
|   OC   22              EXCEPT    PRTPTR
|__3 C                   ENDIF
|   OC  N22              EXCEPT    PRTKEY
|   OC  N22              EXCEPT    PRTPTR
|    C                   MOVE      'Y'           DONE2             1
<--3 C     ERROR         IFEQ      '***'
|    C     UPDATE        ANDEQ     'Y'
|    C                   Z-ADD     ACTSFA        LOCSFA
|    C                   Z-ADD     ACTSFD        LOCSFD
|    C                   Z-ADD     ACTSFP        LOCSFP
|    C                   Z-ADD     ACTSFC        LOCSFC
|    C                   UPDATE    RPTDIR1
|__3 C                   ENDIF
|__2 C                   ENDIF
|__1 C                   ENDIF
      *
      *
<--1 C     RECTYP        IFEQ      '4'
|    C     RECTY2        ANDEQ     '  '
|    C     PGTBL1        ANDEQ     HEX1
|    C     DONE2         ANDNE     'Y'
|    C     ACTSFA        ADD       13            ACTSFD            9 0
|    C                   Z-ADD     RR            ACTSFC            9 0
|    C                   MOVE      *BLANKS       ERROR             3
<--2 C     LOCSFA        IFNE      ACTSFA
|    C     LOCSFD        ORNE      ACTSFD
|    C     LOCSFP        ORNE      ACTSFP
|    C     LOCSFC        ORNE      ACTSFC
|    C                   MOVE      '***'         ERROR
|    C                   ADD       1             COUNT             9 0
|   OC   22              EXCEPT    PRTKEY
|   OC   22              EXCEPT    PRTPTR
|__2 C                   ENDIF
|   OC  N22              EXCEPT    PRTKEY
|   OC  N22              EXCEPT    PRTPTR
|    C                   MOVE      'Y'           DONE2             1
<--2 C     ERROR         IFEQ      '***'
|    C     UPDATE        ANDEQ     'Y'
|    C                   Z-ADD     ACTSFA        LOCSFA
|    C                   Z-ADD     ACTSFD        LOCSFD
|    C                   Z-ADD     ACTSFP        LOCSFP
|    C                   Z-ADD     ACTSFC        LOCSFC
|    C                   UPDATE    RPTDIR1
|__2 C                   ENDIF
|__1 C                   ENDIF
      *
      *>>>>>>>>>>END
     C     END           TAG
      *
      *****************************************************************
      * *INZR INITIAL SUBROUTINE
      *****************************************************************
      *@$$$$$$$$ *INZSR $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     *INZSR        BEGSR
     C     *ENTRY        PLIST
     C                   PARM                    EFLDR            10
     C                   PARM                    EFLDRL           10
     C                   PARM                    UPDATE            1
     C                   PARM                    ERONLY            1
<--1 C     ERONLY        IFEQ      'Y'
|    C                   MOVE      '1'           *IN22
|__1 C                   ENDIF
    OC                   EXCEPT    PRTHED
      *  Setup compounded key for Logical #1
     C     L1KEY         KLIST
     C                   KFLD                    eFLDR
     C                   KFLD                    efldrl
     C                   KFLD                    ZFILNA
     C                   KFLD                    ZJOBNA
     C                   KFLD                    ZUSRNA
     C                   KFLD                    ZJOBNU
     C                   KFLD                    ZFILNU
     C                   ENDSR
      *
     OQSYSPRT   E            PRTHED         2 01
     O                                           19 'REPORT POINTERS FOR'
     O                       EFLDR               30
     O                                           41 'IN LIBRARY'
     O                       EFLDRL              52
     O          E            PRTHED         1
     O                                           43 'JOB'
     O                                           53 'FILE'
     O                                           67 'ATTRIBUTE'
     O                                           78 'DATA'
     O                                           95 'PAGE TABLE'
     O                                          109 'COMPRESSED'
     O                                          124 'END OF REPT'
     O          E            PRTHED         0
     O                                           10 '__________'
     O                                           23 '__________'
     O                                           36 '__________'
     O                                           45 '______'
     O                                           54 '______'
     O                                           68 '___________'
     O                                           82 '___________'
     O                                           96 '___________'
     O                                          110 '___________'
     O                                          124 '___________'
     O          E            PRTHED         1
     O                                            9 'FILE NAME'
     O                                           22 'JOB NAME'
     O                                           35 'SPYNUMBER'
     O                                           45 'NUMBER'
     O                                           54 'NUMBER'
     O                                           66 'POINTER'
     O                                           80 'POINTER'
     O                                           94 'POINTER'
     O                                          108 'POINTER'
     O                                          122 'POINTER'
     O          E            PRTKEY      1  0
     O                       ZFILNA              10
     O                       ZJOBNA              23
     O                       ZREPID              36
     O                       ZJOBNU              45
     O                       ZFILNU        Z     54
     O          E            PRTPTR      0  1
     O                       ACTSFA        2     68
     O                       ACTSFD        2     82
     O                       ACTSFP        2     96
     O                       ACTSFC        2    110
     O          E            PRTPTR      0  1
     O                                           10 '0 - HEADER'
     O                       FILSFA        2     68
     O                       FILSFD        2     82
     O                       FILSFP        2     96
     O                       FILSFC        2    110
     O                       FILSFE        2    124
     O          E            PRTPTR         0
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O                                          124 '____'
     O          E            PRTPTR      0  0
     O                                            7 'MRPTDIR'
     O                       LOCSFA        2     68
     O                       LOCSFD        2     82
     O                       LOCSFP        2     96
     O                       LOCSFC        2    110
     O                       ERROR              124
