      *%METADATA                                                       *
      * %TEXT Create virtual backup configuration                      *
      *%EMETADATA                                                      *
     h main(main)
     d run             pr                  extpgm('QCMDEXC')
     d  cmd                         256    const
     d  len                          15  5 const

     d i               s             10i 0
     d j               s             10i 0
     d dwElem          s             10i 0 inz(1)
     d segCnt          s             10i 0 inz(0)
     d dayOrWeek       s              3    dim(2) perrcd(2) ctdata
     d dayOrWeekInt    s             10i 0 inz(0)
     d vrtFileNbr      s             10i 0 inz(0)
     d imgsizA         s              4    dim(2) perrcd(2) ctdata
     d segment         s              1    dim(8) perrcd(8) ctdata
     d command         s             80    dim(5) ctdata
     d vrtFile         s              6
     d cmd             s            256
     d MAXVRTFIL       c                   6
     d segLmtLow       s             10i 0
     d segLmtHi        s             10i 0

     d main            pr                         extpgm('VRTBKUPCRT')

     p main            b
      /free

       for i = 1 to 3;
         callp(e) run(command(i):%len(%trim(command(i))));
       endfor;

       for dayOrWeekInt = 1 to %elem(dayOrWeek);
         if dayOrWeekInt = 1;
           segLmtLow = 1;
           segLmtHi = 5;
         else;
           segLmtLow = 6;
           segLmtHi = 8;
         endif;
         for segcnt = segLmtLow to segLmtHi;
           for vrtFileNbr = 1 to MAXVRTFIL;
             vrtFile = dayOrWeek(dayOrWeekInt) + segment(segCnt) +
               %subst(%editc(vrtFileNbr:'X'):9:2);
             cmd = 'addimgclge imgclg(backup) fromfile(*new) tofile(' +
               vrtFile + ') volnam(' + vrtFile + ') imgsiz(' +
               imgsizA(dayOrWeekInt) + ')';
             run(cmd:%len(%trim(cmd)));
           endfor;
         endfor;
       endfor;

       run(command(4):%len(%trim(command(4))));

       return;

      /end-free
     p                 e
**ctdata segment
ABCDEABC
**ctdata dayOrWeek
DAYWEK
**ctdata imgsizA
50009999
**ctdata command
crtdevtap devd(tapvrt01) rsrcname(*vrt)
vrycfg cfgobj(tapvrt01) cfgtype(*dev) status(*on)
crtimgclg imgclg(backup) dir('/backup') type(*tap) crtdir(*yes)
lodimgclg imgclg(backup) dev(tapvrt01) wrtptc(*none)
