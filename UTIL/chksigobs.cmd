      /*%METADATA                                                     */
      /* %TEXT Check Signatures and Observability                     */
      /*%EMETADATA                                                    */
             CMD
             PARM       KWD(LIBRARY) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Installed Program Library') /* +
                          Needs to be an installed library so that +
                          all service programs and dependent +
                          programs are in the same location. */
