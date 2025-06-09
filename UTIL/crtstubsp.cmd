      /*%METADATA                                                     */
      /* %TEXT Create Stubbed (dummy) service program                 */
      /*%EMETADATA                                                    */
 /*                                                                           */
 /* Command to create a stubbed/dummy version of a service program for the    */
 /* purpose of ignoring service program signatures for third party products   */
 /* that frequently change the signature of the service programs but not      */
 /* necessarily the functions used. This would preclude having to recompile   */
 /* any referencing objects to such service programs.                         */
 /* Conceptually, a little risky if the function/procedure interfaces are     */
 /* change from release to release. However, this is not usually the case.    */
 /*                                                                           */
             CMD
             PARM       KWD(SRCSP) TYPE(*CHAR) LEN(10) PROMPT('Source +
                          service program name')
             PARM       KWD(SRCSPLIB) TYPE(*CHAR) LEN(10) PROMPT('Source +
                          service program library')
             PARM       KWD(MODSRCFIL) TYPE(*CHAR) LEN(10) PROMPT('Target +
                          module source file')
             PARM       KWD(MODSRCLIB) TYPE(*CHAR) LEN(10) PROMPT('Target +
                          module source library')
             PARM       KWD(MODSRCMBR) TYPE(*CHAR) LEN(10)         +
                          PROMPT('Target module source member')
             PARM       KWD(MODNAM) TYPE(*CHAR) LEN(10) PROMPT('Module +
                          name')
             PARM       KWD(MODLIB) TYPE(*CHAR) LEN(10)         +
                          PROMPT('Module library')
             PARM       KWD(SPSRCFIL) TYPE(*CHAR) LEN(10) PROMPT('Target +
                          service pgm src file')
             PARM       KWD(SPSRCLIB) TYPE(*CHAR) LEN(10) PROMPT('Target +
                          service pgm src lib')
             PARM       KWD(SPSRCMBR) TYPE(*CHAR) LEN(10)         +
                          PROMPT('Target service pgm member')
             PARM       KWD(SPNAM) TYPE(*CHAR) LEN(10) PROMPT('Target +
                          service program name')
             PARM       KWD(SPLIB) TYPE(*CHAR) LEN(10) PROMPT('Target +
                          service program library')

