      *%METADATA                                                       *
      * %TEXT Activate Service Program Header                          *
      *%EMETADATA                                                      *
      *
J2287 * 11-04-11 PLR Created. Scraped from the web. Allows the dynamic loading
      *              of service programs and calling of their procedures.
      *
      *
      // Activate Service Program, return Activation Mark
     DActSrvPgm        PR            10I 0
     D SrvPgm                        10A   value
     D Lib                           10A   value
     D

      // Return procptr to ProcName
     DRtvSrvPgmProc@   PR              *   procptr opdesc
     D ActMark                       10I 0 value
     D ProcName                   32767A   const options(*VARSIZE)

      // Retrieve operational descriptor
     D  CEEDOD         PR
     D   ParmNum                     10I 0  const
     D   DescType                    10I 0
     D   DataType                    10I 0
     D   DescInfo1                   10I 0
     D   DescInfo2                   10I 0
     D   Length                      10I 0
     D   UnknownParm                 12A    options(*OMIT)

      // Resolve System Pointer
     DRslvSP           PR              *   extproc('rslvsp') procptr
     D HexType                        2A   value
     D Object                          *   value options(*STRING)
     D Lib                             *   value options(*STRING)
     D Auth                           2A   value

      // Get Object Type Hex Value
     DQLICVTTP         PR                  extpgm('QLICVTTP')
     D CvtType                       10A   const
     D ObjType                       10A   const
     D HexType                        2A
     D ErrorDS                    32767A   options(*VARSIZE:*OMIT) noopt

      // Activate Bound Program
     DQleActBndPgm     PR            10I 0 extproc('QleActBndPgm')
     D SrvPgmPtr                       *   procptr const
     D ActMark                       10I 0 const options(*OMIT)
     D ActInfo                       64A   const options(*OMIT)
     D ActInfoLen                    10I 0 const options(*OMIT)
     D ErrorDS                    32767A   options(*VARSIZE:*OMIT) noopt

      // Get export pointer
     DQleGetExp        PR              *   extproc('QleGetExp') procptr
     D ActMark                       10I 0 const options(*OMIT)
     D ExpNo                         10I 0 const options(*OMIT)
     D ExpNameLen                    10I 0 const options(*OMIT)
     D ExpName                    32767A   const options(*VARSIZE:*OMIT)
     D Exp@                            *   options(*OMIT) procptr
     D ExpType                       10I 0 options(*OMIT)
     D ErrorDS                    32767A   options(*VARSIZE:*OMIT) noopt
