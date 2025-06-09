     h dftactgrp(*no) bnddir('SPYBNDDIR':'QC2LE')

     fqsysprt   o    f  132        printer

      /copy qsysinc/qrpglesrc,qusrspla

     d getSplfAttr     pr                  extpgm('QUSRSPLA')
     d  rcvrVar                            likeds(qusa0200)
     d  varLen                       10i 0 const
     d  format                        8    const
     d  jobName                      26
     d  intJobID                     16    const
     d  intSplID                     16    const
     d  splfName                     10
     d  splfNbr                      10i 0

     d splfH           s             10i 0
     d sJobName        s             26
     d sSplfName       s             10
     d sSplfNbr        s             10i 0

     d                 ds
     d attrDescA                     80    dim(255) ctdata
     d  ad_Start                      4    overlay(attrDescA:29)
     d  ad_End                        4    overlay(attrDescA:36)
     d  ad_Type                       1    overlay(attrDescA:40)
     d  ad_Text                      28    overlay(attrDescA:53)

     d x               s             10i 0
     d value           s             80
     d                 ds
     d intVal                        10i 0
     d intValC                        4          overlay(intVal)
     d                 ds
     d packVal                        8p 5
     d packValC                       5          overlay(packVal)

     c     *entry        plist
     c                   parm                    sSplfName
     c                   parm                    sSplfNbr
     c                   parm                    sJobName
      /free
       getSplfAttr(qusa0200:%size(qusa0200):'SPLA0200':sJobName:
         '                ':'                ':sSplfName:sSplfNbr);
       for x = 1 to %elem(attrDescA);
         value = %subst(qusa0200:%int(ad_Start(x)):
           (%int(ad_End(x)) - %int(ad_Start(x)) + 1));
         if ad_Type(x) = 'P';
           packValC = %subst(value:4:5);
           value = %char(packVal);
         endif;
         if ad_Type(x) = 'B';
           intValC = value;
           value = %char(intVal);
         endif;
         except printit;
       endfor;
       *inlr = '1';
      /end-free

     oqsysprt   e            printit        1
     o                       ad_text(x)
     o                                              '  '
     o                       value
**ctdata attrDescA
     D*QUSBR08                 1      4B 0          Bytes Return
     D*QUSBA08                 5      8B 0          Bytes Avail
     D*QUSFN18                 9     16             Format Name
     D*QUSIJID09              17     32             Int Job ID
     D*QUSISID01              33     48             Int Splf ID
     D*QUSJN11                49     58             Job Name
     D*QUSUN13                59     68             Usr Name
     D*QUSJNBR10              69     74             Job Number
     D*QUSSN02                75     84             Splf Name
     D*QUSSNBR00              85     88B 0          Splf Number
     D*QUSFT03                89     98             Form Type
     D*QUSUD02                99    108             Usr Data
     D*QUSTATUS05            109    118             Status
     D*QUSFILA04             119    128             File Avail
     D*QUSHFIL00             129    138             Hold File
     D*QUSSFIL04             139    148             Save File
     D*QUSTP00               149    152B 0          Total Pages
     D*QUSCP01               153    156B 0          Curr Page
     D*QUSSP00               157    160B 0          Start Page
     D*QUSEP00               161    164B 0          End Page
     D*QUSLPP00              165    168B 0          Last Page Print
     D*QUSRP03               169    172B 0          Rest Page
     D QUSTC00               173    176B 0          Total Copies
     D QUSCR00               177    180B 0          Copies Rem
     D QUSLPI00              181    184B 0          Lines Per Inch
     D QUSCPI00              185    188B 0          Char Per Inch
     D QUSOP02               189    190             Output Priority
     D QUSON01               191    200             Outq Name
     D QUSOL01               201    210             Outq Lib
     D QUSDFILO00            211    217             Date File Open
     D QUSTFILO00            218    223             Time File Open
     D QUSDFILN03            224    233             Dev File Name
     D QUSDFILL03            234    243             Dev File Lib
     D QUSPN00               244    253             Pgm Name
     D QUSPL02               254    263             Pgm Lib
     D QUSCC02               264    278             Count Code
     D QUSPT01               279    308             Print Text
     D QUSRL06               309    312B 0          Record Length
     D QUSMR00               313    316B 0          Max Records
     D QUSDT01               317    326             Dev Type
     D QUSPDT00              327    336             Ptr Dev Type
     D QUSDN01               337    348             Doc Name
     D QUSFN19               349    412             Folder Name
     D QUSS36PN00            413    420             S36 Proc Name
     D QUSPF01               421    430             Print Fidel
     D QUSRU00               431    431             Repl Unprint
     D QUSRC01               432    432             Repl Char
     D QUSPL03               433    436B 0          Page Length
     D QUSPW00               437    440B 0          Page Width
     D QUSNBRS02             441    444B 0          Number Separate
     D QUSOLN00              445    448B 0          Overflow Line Nm
     D QUSDBCSD00            449    458             DBCS Data
     D QUSBCSEC00            459    468             DBCS Ext Chars
     D QUSSSOSI00            469    478             DBCS SOSI
     D QUSBCSCR00            479    488             DBCS Char Rotate
     D QUSDBCSC01            489    492B 0          DBCS Cpi
     D QUSGCS00              493    502             Grph Char Set
     D QUSCP02               503    512             Code Page
     D QUSFDN00              513    522             Form Def Name
     D QUSFDL00              523    532             Form Def Lib
     D QUSSD07               533    536B 0          Source Drawer
     D QUSPF02               537    546             Print Font
     D QUS36SID00            547    552             S36 Spl ID
     D QUSPR00               553    556B 0          Page Rotate
     D QUSATION00            557    560B 0          Justification
     D QUSUPLEX00            561    570             Duplex
     D QUSFOLD00             571    580             Fold
     D QUSCC03               581    590             Ctrl Char
     D QUSAF00               591    600             Align Forms
     D QUSPQ00               601    610             Print Quality
     D QUSFF00               611    620             Form Feed
     D QUSDV00               621    691             Disk Volume
     D QUSDL01               692    708             Disk Label
     D QUSET00               709    718             Exch Type
     D QUSCC04               719    728             Char Code
     D QUSNDR00              729    732B 0          Nmbr Disk Rcrds
     D QUSLTIUP00            733    736B 0          Multiup
     D QUSFON00              737    746             Frnt Ovrly Name
     D QUSFOLN00             747    756             Frnt Ovrly Lib Name
     D QUSFOOD00             757    764P 5          Frnt Ovrly Off Dn
     D QUSFOOA00             765    772P 5          Frnt Ovrly Off Across
     D QUSBON00              773    782             Bck Ovrly Name
     D QUSBOLN00             783    792             Bck Ovrly Lib Name
     D QUSBOOD00             793    800P 5          Bck Ovrly Off Dn
     D QUSBOOA00             801    808P 5          Bck Ovrly Off Across
     D QUSUM00               809    818             Unit Measure
     D QUSPD04               819    828             Page Definition
     D QUSPDL00              829    838             Page Definition Lib
     D QUSLS01               839    848             Line Spacing
     D QUSPS00               849    856P 5          Point Size
     D QUSMDRS               857    860B 0          Max Data Record Size
     D QUSFILBS              861    864B 0          File Buffer Size
     D QUSFILL00             865    870             File Level
     D QUSCFA                871    886             Coded Font Array
     D QUSCM                 887    896             Channel Mode
     D QUSCC1                897    900B 0          Channel Code1
     D QUSCC2                901    904B 0          Channel Code2
     D QUSCC3                905    908B 0          Channel Code3
     D QUSCC4                909    912B 0          Channel Code4
     D QUSCC5                913    916B 0          Channel Code5
     D QUSCC6                917    920B 0          Channel Code6
     D QUSCC7                921    924B 0          Channel Code7
     D QUSCC8                925    928B 0          Channel Code8
     D QUSCC9                929    932B 0          Channel Code9
     D QUSCC10               933    936B 0          Channel Code10
     D QUSCC11               937    940B 0          Channel Code11
     D QUSCC12               941    944B 0          Channel Code12
     D QUSGT                 945    952             Graphics Tokenl
     D QUSRF                 953    962             Record Format
     D QUSRSV103             963    964             Reserved1
     D QUSHD1                965    972P 5          Height Drawer1
     D QUSWD1                973    980P 5          Width Drawer1
     D QUSHD2                981    988P 5          Height Drawer2
     D QUSWD2                989    996P 5          Width Drawer2
     D QUSNBRB               997   1000B 0          Number Buffers
     D QUSMFW               1001   1004B 0          Max Form Width
     D QUSAFW               1005   1008B 0          Alternate Form Width
     D QUSAFL               1009   1012B 0          Alternate Form Length
     D QUSAL                1013   1016B 0          Alternate Lpi
     D QUSTF                1017   1018             Text Flags
     D QUSFFILO             1019   1019             Flg File Open
     D QUSFEPC              1020   1020             Flg Est Pge Cnt
     D QUSFPB               1021   1021             Flg Pge Boundary
     D QUSFT04              1022   1022             Flg Trc
     D QUSFDC               1023   1023             Flg Def Char
     D QUSFC                1024   1024             Flg Cpi
     D QUSFT05              1025   1025             Flg Transparency
     D QUSFDWC              1026   1026             Flg Dbl Wide Char
     D QUSFCR               1027   1027             Flg Char Rotate
     D QUSFCP               1028   1028             Flg Code Page
     D QUSFFE               1029   1029             Flg Fft Emphasis
     D QUSS3812             1030   1030             Flg Scs3812
     D QUSFS                1031   1031             Flg Sld
     D QUSFG                1032   1032             Flg Gea
     D QUSC5219             1033   1033             Flg Cmd5219
     D QUSC3812             1034   1034             Flg Cmd3812
     D QUSFFO               1035   1035             Flg Fld Outline
     D QUSFFFT              1036   1036             Flg Final Frm Txt
     D QUSFB                1037   1037             Flg Barcode
     D QUSFC00              1038   1038             Flg Color
     D QUSFDC00             1039   1039             Flg Drawer Chg
     D QUSFC01              1040   1040             Flg Charid
     D QUSFL                1041   1041             Flg Lpi
     D QUSFF01              1042   1042             Flg Font
     D QUSFH                1043   1043             Flg Highlight
     D QUSFPR               1044   1044             Flg Pge Rotate
     D QUSFS00              1045   1045             Flg Subscript
     D QUSFS01              1046   1046             Flg Superscript
     D QUSFD                1047   1047             Flg Dds
     D QUSFFF               1048   1048             Flg Form Feed
     D QUSFSD               1049   1049             Flg Scs Data
     D QUSFUGD              1050   1050             Flg User Gen Data
     D QUSFG00              1051   1051             Flg Graphics
     D QUSFUD               1052   1052             Flg Unrecogn Data
     D QUSSCIIT             1053   1053             Flg ASCII Trans
     D QUSFIT               1054   1054             Flg Ipds Trans
     D QUSFOV               1055   1055             Flg Office Vis
     D QUSFNL               1056   1056             Flg No Lpi
     D QUSC3353             1057   1057             Flg Cpa3353
     D QUSFSE               1058   1058             Flg Set Excp
     D QUSFCC               1059   1059             Flg Carriage Control
     D QUSFPP               1060   1060             Flg Pge Pos
     D QUSFIC               1061   1061             Flg Invalid Char
     D QUSFL00              1062   1062             Flg Lengths
     D QUSFP5               1063   1063             Flg Pres5a
     D QUSCFLD              1064   1064             Flg Resrvd
     D QUSNFE               1065   1068B 0          Nbr Font Entries
     D QUSNLE               1069   1072B 0          Nbr Lib Entries
     D QUSFE                1073   2225             Font Entries
     D QUSLE                2226   2856             Lib Entries
     D QUSAFPDS             2857   2857             Native AFPDS
     D QUSCHRID             2858   2858             JOBCCSID For CHRID
     D QUSS36CY             2859   2859             S36 Continue Yes
     D QUSDFU               2860   2869             Decimal Format Used
     D QUSDFLA              2870   2876             Date File Last Accessed
     D QUSPG04              2877   2877             Page Groups
     D QUSGLI               2878   2878             Group Level Index
     D QUSPLI               2879   2879             Page Level Index
     D QUSPDSPT             2880   2880             IPDS Pass Through
     D QUSOURL              2881   2884B 0          Off Usr Rsc Libl
     D QUSNURL              2885   2888B 0          Nbr Usr Rsc Libl
     D QUSLURLE             2889   2892B 0          Len Usr Rsc Libl Entry
     D QUSRSV8              2893   2894             Reserved8
     D QUSCS00              2895   2895             Corner Stapling
     D QUSESER              2896   2896             Edge Stitch Edge Ref
     D QUSOFER              2897   2904P 5          Offset From Edge Ref
     D QUSESNS              2905   2908B 0          Edge Stitch Nbr Staples
     D QUSOSP               2909   2912B 0          Offset Staple Positions
     D QUSNOSP              2913   2916B 0          Nbr of Staple Positions
     D QUSLSPE              2917   2920B 0          Len Staple Position Entry
     D QUSFR01              2921   2930             Font Resolution
     D QUSRFNP              2931   2931             Rcd Fmt Name Present
     D QUSSSER              2932   2932             Saddle Stitch Edge Ref
     D QUSSSNS              2933   2936B 0          Saddle Stitch Nbr Staples
     D QUSOSSO              2937   2940B 0          Off Saddle Staple Off
     D QUSNOSSO             2941   2944B 0          Nbr of Saddle Stpl Off
     D QUSLSSOE             2945   2948B 0          Len Saddle Staple Off Entry
     D QUSDSS01             2949   2956P 0          Data Stream Size
     D QUSOSL               2957   2960B 0          Off Splf Libl
     D QUSNOL               2961   2964B 0          Nbr of Libraries
     D QUSLSLE              2965   2968B 0          Len Splf Libl Entry
     D QUSOIPPA02           2969   2972B 0          Off IPP Attrs
     D QUSOSRA              2973   2976B 0          Off SR Attrs
     D QUSSIDOJ             2977   2980B 0          CCSID of Job
     D QUSRSV212            2981   3152             Reserved2
     D QUSFMOD00            3153   3160P 5          Frnt Margin Off Dn
     D QUSFMOA00            3161   3168P 5          Frnt Margin Off Acr
     D QUSBMOD00            3169   3176P 5          Back Margin Off Dn
     D QUSBMOA00            3177   3184P 5          Back Margin Off Acr
     D QUSLOP00             3185   3192P 5          Length Of Page
     D QUSWOP00             3193   3200P 5          Width Of Page
     D QUSMM00              3201   3210             Measure Method
     D QUSAR01              3211   3211             Afp Resource
     D QUSFCS00             3212   3221             Font Char Set
     D QUSFCSL00            3222   3231             Font Char Set Lib
     D QUSCPN00             3232   3241             Code Page Name
     D QUSCPL00             3242   3251             Code Page Lib
     D QUSCFN00             3252   3261             Coded Font Name
     D QUSCFL00             3262   3271             Coded Font Lib
     D QUSCSCFN00           3272   3281             DBCS Coded Font Name
     D QUSCSCFL00           3282   3291             DBCS Coded Font Lib
     D QUSUDFIL00           3292   3301             User Defined File
     D QUSRO00              3302   3311             Reduce Output
     D QUSCBO00             3312   3312             Constant Back Overlay
     D QUSOB00              3313   3316B 0          Output Bin
     D QUSCCSID09           3317   3320B 0          CCSID
     D QUSUT00              3321   3420             User Text
     D QUSOS04              3421   3428             Original System
     D QUSONID00            3429   3436             Original Net ID
     D QUSSC00              3437   3446             Splf Creator
     D QUSRSV503            3447   3448             Reserved5
     D QUSUDOO02            3449   3452B 0          Usr Def Options Offset
     D QUSUDON01            3453   3456B 0          Usr Def Options Number
     D QUSUDOEL00           3457   3460B 0          Usr Def Options Entry Length
     D QUSUDD00             3461   3715             Usr Defined Data
     D QUSUDON02            3716   3725             Usr Def Object Name
     D QUSUDOL00            3726   3735             Usr Def Object Lib
     D QUSUDOT04            3736   3745             Usr Def Object Type
     D QUSRSV601            3746   3748             Reserved6
     D QUSCSPS00            3749   3756P 5          Character Set Point Size
     D QUSCFPS00            3757   3764P 5          Coded Font Point Size
     D QUSSCFPS00           3765   3772P 5          DBCS Coded Font Point Size
     D QUSSFASP00           3773   3776B 0          Spooled File ASP
     D QUSSFILS00           3777   3780B 0          Spooled File Size
     D QUSSSM03             3781   3784B 0          Splf Size Multiplier
     D QUSIPPJI00           3785   3788B 0          IPP JobId
     D QUSSCSM00            3789   3789             Splf Crt Security Method
     D QUSSAM00             3790   3790             Splf Authentication Method
     D QUSWBPD00            3791   3797             Wtr Begin Process Date
     D QUSWBPT00            3798   3803             Wtr Begin Process Time
     D QUSWCPD00            3804   3810             Wtr Complete Proc Date
     D QUSWCPT00            3811   3816             Wtr Complete Proc Time
     D QUSJSN               3817   3824             Job System Name
     D QUSASPDN07           3825   3834
     D QUSSED00             3835   3841
