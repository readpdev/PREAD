      *%METADATA                                                       *
      * %TEXT Name/Value pair buffer handling header                   *
      *%EMETADATA                                                      *

T5862 * 11-07-06 PLR Change to correct SAR #. Was 5557.
      *
      *
T5862 * 08-10-06 PLR Created. Name/value pair buffer handling procedures.
      *              /copy member for module source MGNVPHDL-RPGLE.
      *

      * Return code constants.
     d NVP_RTN_ERR     c                   -1
     d NVP_RTN_OK      c                   0
     d NVP_RTN_EOD     c                   1

      * Operation code constants.
     d NVP_GET         c                   1
     d NVP_PUT         c                   2
     d NVP_CLR         c                   3

      * Name/value pair buffer handler procedure prototype.
     d nvpHandler      pr            10i 0
     d  operation                    10i 0 const
     d  pairName                       *   value options(*string:*nopass)
     d  pairValue                      *   value options(*string:*nopass)
     d nvpHandlerP     s               *   procptr inz(%paddr('NVPHANDLER'))
