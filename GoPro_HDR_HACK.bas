!**** GoPro 4 HDR bracketed exposure *****
! Instructions at Peter Veng-Pedersen YouTube channel
CONSOLE.TITLE "H D R  B R A C K E T E D  E X P O S U R E  for GoPro 4  (v2.0 PV-P)"
delay = 1500
PAUSE 2000
WIFI.INFO  SSID$
 PRINT "WIFI connection to GoPro: "  SSID$
 PAUSE 3000
 ! *** dimension some arrays ******
 shot_done$ = "Shots done"
 want_to_continue$ = "Continue?"
 yes$ = "YES"
 no$ = "NO"
 yes_no_title$ = "M O R E  S H O T S ?"
 ARRAY.LOAD more_shots$[], shot_done$,  want_to_continue$, yes$, no$
 ! *************************************
 WIFILOCK 3
  gp_setting$ = "http://10.5.5.9/gp/gpControl/setting/"
  ev_neg_2$ =  gp_setting$ + "26/8"
  ev_0$ =      gp_setting$ + "26/4"
  ev_plus_2$ = gp_setting$ + "26/0"
  shutter$ =  "http://10.5.5.9/gp/gpControl/command/shutter?p=1"
  test_shot$ = "A bracketed shot will now be taken"
  OK$ = "Press OK to start"
  TestTitle$ = "H D R  B R A C K E T I N G  S H O T"
  ARRAY.LOAD testingHDR$[], test_shot$, OK$
  SELECT dummy, testingHDR$[], TestTitle$,""
  new_start:
  POPUP "Recording in progress while beeping......",0.,0.,4.
  HTML.OPEN
  ! ************* bracketing shots *************
  PAUSE delay
  HTML.LOAD.URL  ev_neg_2$
  PAUSE delay 
  HTML.LOAD.URL  shutter$ 
  PAUSE delay
  HTML.LOAD.URL  ev_0$
  PAUSE delay
  HTML.LOAD.URL shutter$
  PAUSE delay
  HTML.LOAD.URL  ev_plus_2$
  PAUSE delay
  HTML.LOAD.URL  shutter$
  PAUSE delay
  ! ***********************************
  HTML.CLOSE
  PRINT "HDR shot completed"
  TONE 2000., 1000.
  PAUSE 4000
  SELECT dummy, more_shots$[], yes_no_title$,""
  IF dummy < 4.
   CLS
   GOTO new_start
  ELSE
   HTML.OPEN
   PAUSE delay
   HTML.LOAD.URL  ev_0$
   PAUSE delay
   HTML.CLOSE
   EXIT
  ENDIF
