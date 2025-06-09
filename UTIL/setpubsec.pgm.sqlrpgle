      *%METADATA                                                       *
      * %TEXT Set Report *PUBLIC Security in RSECUR                    *
      *%EMETADATA                                                      *
     d stmt            s            512
     d rsecur        e ds                  extname(RSECUR) qualified
     d rmaint        e ds                  extname(RMAINT) qualified
     d sq              c                   ''''
      /free
       exec sql select * into :rsecur from rsecur where suser = '*PUBLIC';
       stmt = 'select * from rmaint where rtypid like ' + sq + 'RPT%' +
        sq;
       exec sql prepare stmt from :stmt;
       exec sql declare c1 cursor for stmt;
       exec sql open c1;
       exec sql fetch next from c1 into :rmaint;
       dow sqlcod = 0;
         rsecur.srnam = rmaint.rrnam;
         rsecur.sjnam = rmaint.rjnam;
         rsecur.spnam = rmaint.rpnam;
         rsecur.sunam = rmaint.runam;
         rsecur.sudat = rmaint.rudat;
         exec sql insert into rsecur values(:rsecur);
         exec sql fetch next from c1 into :rmaint;
       enddo;
       exec sql close c1;
       *inlr = '1';
      /end-free
