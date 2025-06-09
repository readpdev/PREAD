
       dcl-s startTime time;
       dcl-s aMsg char(40);

       dcl-pr bpmigcfg extpgm('BPMIGCFG');
         pgmOption char(10) const;
       end-pr;

       startTime = %time;

       bpmigcfg('CONFIGURE');

       aMsg = 'Total Seconds: ' + %char(%diff(%time:startTime:*seconds));

       dsply aMsg;

       return;

