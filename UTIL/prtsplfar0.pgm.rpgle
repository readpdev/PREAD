     h dftactgrp(*no) bnddir('SPYBNDDIR':'QC2LE')

     fqsysprt   o    f  132        printer

     d memcpy          pr                  extproc('memcpy')
     d  tgt                            *   value
     d  src                            *   const
     d  len                          10i 0 const

     d/copy @masplio

     d attrDS          ds                  based(attrDSp)
     d  aLen                          5u 0
     d  aID                           5u 0
     d  aVal                        128
     d*copy @masplioat

     d splfH           s             10i 0
     d sJobName        s             26
     d sSplfName       s             10
     d sSplfNbr        s             10i 0
     d sJobId          s             16    inz
     d sSplfId         s             16    inz

     d x               s             10i 0
     d attrRcdP        s               *
     d szAttrDS        s             10i 0 inz(%size(attrDS))
     d rtnVal          s            100
     d rtnLen          s             10i 0
     d desc            s             50    dim(122) ctdata

     c     *entry        plist
     c                   parm                    sJobName
     c                   parm                    sSplfName
     c                   parm                    sSplfNbr_c        5

     c                   move      sSplfNbr_c    sSplfNbr

     c                   eval      splfH = opnSplf(sJobName:sSplfName:sSplfNbr:
     c                                     sJobID:sSplfId)

     c                   alloc     8192          attrRcdP
     c                   callp     getSplARcd(splfH:attrRcdP)

     c                   eval      attrDSp = %alloc(%size(attrDS))
     c                   clear                   attrDS
     c                   do        122           x
     c                   eval      attrDSp = getSplAttr(x:attrRcdP)
     c                   eval      rtnval = '*NULL'
     c                   eval      rtnLen = 0
     c                   if        attrDSp <> *NULL
     c                   if        aLen > %size(aVal)
     c                   eval      aLen = %size(aVal)
     c                   endif
     c                   eval      rtnVal = %subst(aVal:1:aLen)
     c                   eval      rtnLen = aLen
     c                   endif
     c                   except    printit
     c                   enddo

     c                   eval      *inlr = '1'

     oqsysprt   e            printit        1
     o                                              'ID = '
     o                       x             z
     o                                              '  '
     o                       desc(x)
     o          e            printit        1
     o                                              'Length = '
     o                       rtnLen        z
     o          e            printit        2
     o                                              'Value = '
     o                       rtnVal
**ctdata desc
Range of pages to print this file
User's name for file
Spool database file record length
Special device requirements
Maximum printer file forms width
Output record length 1
Form type
Copies left to print
Number of file separators
Maximum number of records allowed
Output priority
Qualified print file name
OS/400 networked flags
Disposition
Job accounting code
Token for graphics file
Security classification text
Device type
Width of drawer 1
Height of drawer 1
Width of drawer 2
Height of drawer 2
Time of day file was opened
User supplied data
Document name
Folder name
Qualified program name
S/36 procedure name
Alternate forms width
Alternate forms length
Alternate LPI in 1440's of an inch
PSF defined
Primary record length
Forms length in lines
Forms width in chars
Lines per inch
Overflow line number
Form is to be aligned
Fold or truncate
Unprintable character substitution
Characters per inch
Font identifier
Print quality value
Form feed attachment
Drawer value
Text utility flags
File contains DBCS data
Use DBCS extension characters
DBCS characters per inch
DBCS shiftout/shiftin processing
Rotate DBCS characters
Character set and code page id
Page rotate
Justification
Duplex
Font equivalence table
Qualified form definition name
Restart
Spool file number
Device class
Total number of pages
Qualified job name
Qualified output queue name
Status
Total number of copies
Scheduling information
S/36 spool file id
Current page/record being written
Number of diskette records
File on device or user output queue
Diskette label
Diskette code
Diskette volume id
Diskette file exchange type
Job offset into WCBT to WCBTE
File offset into SCB to OFCB
Job TOD of the job that created the file
Pages per side (MULTIUP)
Unit of measure
Front side overlay
Back side overlay
Line spacing
Table reference characters (TRC)
Coded fonts (CHARS)
Qualified page definition name
OS/400 informational flags
Database file name
Database member name
Channel values
Process mode
Point size
Resource library array
Spooled file level
Number of buffers
Page size
Front margin
Back margin
Font character set
Coded font
DBCS coded font
Output bin
Reduce output
Original system
Originating user profile
User print CCSID and print information
Number of WCBT that contains job WCBTE
User defined options 1-4
User defined data
User defined object and type
Font Character set point size
Coded font point size
DBCS-Coded font point size
Spooled File ASP
TOD File was last used
Size of spooled file
IPDS pass through
User resource library list
Corner stapling
Edge Stitching
Font resolution
Number of data stream bytes
Saddle Stitching
