      *%METADATA                                                       *
      * %TEXT SQL Link Data Retrieval Module - Header                  *
      *%EMETADATA                                                      *
      *
J4772 * 07-23-15 PLR Prototypes for SQL link search module.
      *

     d lnkNdxSQL     e ds                  extname(rlnkndx) qualified template

     d sqlDBopen       pr            10i 0 extproc('SQLDBOPEN')
     d  sqlStmt                        *   const options(*string:*trim)

     d sqlDBread       pr            10i 0 extproc('SQLDBREAD')
     d  hitRtnStruct                   *
     d  operation                     5    const

     d sqlDBclose      pr                  extproc('SQLDBCLOSE')

