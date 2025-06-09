     fclockfm   cf   e             workstn

     d run             pr                  extpgm('QCMDEXC')
     d  cmd                         256    const
     d  cmdlen                       15  5 const

      /free
       dow 1 = 1;
         out_date = %date(*date);
         out_time = %time;
         write(e) window01;
         if %error;
           leave;
         endif;
         //run('dlyjob 1':8);
       enddo;
       eval *inlr = '1';
      /end-free
