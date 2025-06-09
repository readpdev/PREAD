      *
J65   * 05-13-09 PLR Add support for Tivoli Storage Manager (TSM/DR550).
      *
      * Constants and prototypes.
      *

     d TSM_LAST_ERR_SET...
     d                 c                   1
     d TSM_LAST_ERR_GET...
     d                 c                   2

     d tsmError        s            100    based(tsmErrorP)

     d tsmConnect      pr             5i 0 extproc('tsmConnect')
     d  connectionHdl                  *   value
     d  deviceName                     *   value options(*string)

     d tsmTerminate    pr                  extproc('tsmTerminate')
     d  connectionHdl                10u 0 value

     d tsmGetLastErr   pr              *   extproc('tsmGetLastError')

     d tsmFree         pr            10i 0 extproc('tsmFree')
     d  deviceName                     *   value options(*string)
     d  volume                         *   value options(*string)
     d  freespace                      *   value
