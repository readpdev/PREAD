      /*%METADATA                                                     */
      /* %TEXT Retrieve Patch from Network                            */
      /*%EMETADATA                                                    */
/* CALLS RSTPATCHCL */
             CMD
             PARM       KWD(PATCHID) TYPE(*CHAR) LEN(10) MIN(1) +
                          CHOICE('1234, 5678, etc.') PROMPT('Patch ID')
             PARM       KWD(VERSION) TYPE(*CHAR) LEN(4) CHOICE('880, +
                          8811, 900, 901, etc.') PROMPT('Version')
             PARM       KWD(SAVF) TYPE(*CHAR) LEN(10) PROMPT('Target +
                          Save File Name')
             PARM       KWD(SAVFLIB) TYPE(*CHAR) LEN(10) +
                          PROMPT('Save File Library')
