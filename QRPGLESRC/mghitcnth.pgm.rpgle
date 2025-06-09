      //
J6381 // 02-17-17 PLR Created. Returns the number of hits based on search
      //              criteria passed from EXPOBJSPY.
      //

      dcl-pr getHitCount uns(10) extname('MGHITCNT');
        criteria char(900) const;
      end-pr;
