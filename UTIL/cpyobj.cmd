      /*%METADATA                                                     */
      /* %TEXT Copy Object - Replace in Target Lib if Exists          */
      /*%EMETADATA                                                    */
             CMD
             PARM       KWD(OBJNAM) TYPE(OBJNAME) MIN(1) +
                          PROMPT('From Object')
             PARM       KWD(OBJTYP) TYPE(*CHAR) LEN(10) +
                          PROMPT('Object Type') MIN(1)
             PARM       KWD(TOLIB) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('To Library')

 OBJNAME:    QUAL       TYPE(*NAME) LEN(10) MIN(1) EXPR(*YES)
             QUAL       TYPE(*NAME) LEN(10)
