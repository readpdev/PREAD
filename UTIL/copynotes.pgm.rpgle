      * Create a binding directory and add the service program MMCSNOTER.
      *
      * Replace the YOUR_DIR value with the binding directory containing the
      * reference to MMCSNOTER.
      *
      * This code sample illustrates how to copy a note from one document to another.
      *
     h dftactgrp(*no) actgrp(*caller) bnddir('YOUR_DIR')

     d CsNoteInit      pr
     d CsNoteQuit      pr

     d DoNotes         pr            10i 0
     d  Function                      5    value
     d  Batch#                       10    value
     d  Seq#                          9  0 value
     d  RevID                         9  0 value
     d  NoteStrPtr                     *
     d  DomainCode                    9  0 value
     d  DomainType                    9  0

      * Opcode constants for MMCSNOTER module.
     d Sn_Copy         c                   'CPYNT'

      * Copy structure that is passed to the notes application.
     D copy            DS           128    qualified
     D  batch                        10    inz                                  Copy to batch#
     D  sequence                      9  0 inz                                  Copy to seq number
     D  all                           1    inz('1')                             Copy all notes?
     D  revision                      9  0 inz                                  Copy to rev
     D copyP           s               *   inz(%addr(copy))

     D rc              s             10i 0
     D domainType      s              9  0 inz(0)

      /free
       CsNoteInit(); //Initialize the notes service program.
       //Set the copy 'to' values.
       reset copy;
       //Batch ID - LDXNAM field in the index file.
       copy.batch = 'B00000000S';
       //Starting RRN this is the LXSPG field in the index file.
       copy.sequence = 610;
       //Perform the copy operation.
       rc = DoNotes(Sn_Copy:'B00000000S':152:0:copyP:0:DomainType);
       CsNoteQuit(); //Shutdown the notes service program.
       *inlr = '1';
       return;
      /end-free
