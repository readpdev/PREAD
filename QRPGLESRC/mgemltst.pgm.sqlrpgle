       ctl-opt main(main) bnddir('TSTBNDDIR');

      /include mgemlslth

       dcl-pr main extpgm('MGEMLTST');
       end-pr;

       dcl-proc main;

         dcl-s aRecipientList char(60);
         dcl-ds emailEntry likeds(mailEntry_t);
         dcl-s emailOpcode char(10) inz('*FIRST');

         showEmailList(aRecipientList);

         dow getEmailEntry(emailOpcode:emailEntry) = 0;
           emailOpcode = '*NEXT';
         enddo;

         return;

       end-proc;
