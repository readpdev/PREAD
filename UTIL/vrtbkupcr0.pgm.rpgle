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
     d imgsizA         s              4    dim(2) perrcd(2) ctdata
     d segment         s              1    dim(8) perrcd(8) ctdata
     d command         s             80    dim(5) ctdata
     d vrtFile         s              6
     d cmd             s            256

     d main            pr                         extpgm('VRTBKUPCRT')

     p main            b
      /free
       for i = 1 to 4;
         callp(e) run(command(i):%len(%trim(command(i))));
       endfor;
       for i = 1 to %elem(segment);
         if i > 5;
           segCnt = 0;
         endif;
         segCnt = segCnt + 1;
         if i > 5 and dwElem < 2; // Change from DAY to WEK prefix
           dwElem = dwElem + 1;
         endif;
         for j = 1 to 6;
           vrtFile = dayOrWeek(dwElem) + segment(segCnt) +
             %subst(%editc(j:'X'):9:2);
           cmd = 'addimgclge imgclg(backup) fromfile(*new) tofile(' + vrtFile +
             ') volnam(' + vrtFile + ') imgsiz(' + imgsizA(dwElem) + ')';
           run(cmd:%len(%trim(cmd)));
         endfor;
       endfor;
       run(command(5):%len(%trim(command(5))));
      /end-free
     p                 e
**ctdata segment
ABCDEABC
**ctdata dayOrWeek
DAYWEK
**ctdata imgsizA
30004500
**ctdata command
crtdevtap devd(tapvrt01) rsrcname(*vrt)
vrycfg cfgobj(tapvrt01) cfgtype(*dev) status(*on)
crtlib backup
crtimgclg imgclg(backup) dir('/backup') type(*tap) crtdir(*yes)
lodimgclg imgclg(backup) dev(tapvrt01) wrtptc(*none)
