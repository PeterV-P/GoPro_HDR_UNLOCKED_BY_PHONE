!**** GoPro 4 HDR timelapse program *****
! Instructions at Peter Veng-Pedersen YouTube channel
CONSOLE.TITLE "T R U E  H D R  T I M E L A P S E  for GoPro 4  v2.0 PV-P"
delay = 1500
PAUSE 2000
WIFI.INFO  SSID$
WIFILOCK 3
 PRINT "WIFI connection to GoPro: "  SSID$
 ! *** dimension some arrays ******
 error_message$ = "The calculated shooting interval is too short. It needs to be at least 10 seconds. Press  *** G O  B A C K ***  to change to new settings"
 Try_again$ = "*** G O  B A C K ***"
 ErrorTitle$ = "I N P U T  E R R O R"
 ARRAY.LOAD Error_HDR$[], error_message$,Try_again$
 want_to_continue$ =  "Want to continue?"
 yes$ = "YES"
 no$ = "NO"
 yes_no_title$ = "M O R E  R E C O R D I N G S ?"
 ARRAY.LOAD more$[] , want_to_continue$, yes$, no$ 
test_shot$ = "A test shot may now be taken"
  OK$ = "START"
  Ignore$ = "IGNORE"
  TestTitle$ = "T E S T I N G"
  ARRAY.LOAD testingHDR$[], test_shot$, OK$, Ignore$
part1$ = "A single bracketed test shot has been done"
part2$ = "You now have the option to switch to the GoPro App to check for proper exposures in the HDR sequence"
part3$ = "You can then continue here when you press  *NEXT*"
part4$ = "*NEXT*"
check$ = "H D R   C H E C K"
 ARRAY.LOAD check_HDR$[], part1$, part2$, part3$, part4$
gp_setting$ = "http://10.5.5.9/gp/gpControl/setting/"
  ev_neg_2$ =  gp_setting$ + "26/8"
  ev_0$ =      gp_setting$ + "26/4"
  ev_plus_2$ = gp_setting$ + "26/0"
  shutter$ =  "http://10.5.5.9/gp/gpControl/command/shutter?p=1"
! *****************************************
  HTML.OPEN
  PAUSE delay
 new_start:
  HTML.CLOSE
 INPUT "How many minutes do you want to record?"  ,minutes_recorded
 INPUT "How many seconds do you want"~    
 +  " the playback to be?"~      
 ,playback_seconds
 playback_fps = 30. %% assuming 30 frames per second video
 n_intervals = playback_seconds*playback_fps
 interval = minutes_recorded*60./n_intervals %% seconds
 PRINT USING$(,"minutes to be recorded =%4.0f" , minutes_recorded)
 PRINT USING$(, "intended playback (seconds) =%5.0f " , playback_seconds)
 PRINT USING$(, "speed increase factor =% 3.0f ",~       
 minutes_recorded*60./playback_seconds)
 PRINT USING$(, "number of bracketing sequences = % 5.0f", ~ 
 n_intervals)
 PRINT USING$(, "number of pictures to be taken = %5.0f",3.* n_intervals)
 PRINT  USING$(, "storage needed for pictures (MB) = % 5.0f", 0.)
 PRINT USING$(, "shooting interval (seconds) =% 3.1f", interval)
 PAUSE 6000
 IF (6.*delay/1000.) > interval    %% error
  ! ****completing one bracketing shot takes more than 6*delay seconds *****
  SELECT dummy, Error_HDR$[], ErrorTitle$,""
  GOTO new_start
 ENDIF
  SELECT dummy, testingHDR$[], TestTitle$,""
  if dummy = 3.
      goto skip_testing
  endif
  ! ************* test shot *************
  HTML.OPEN
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
  HTML.CLOSE
  ! **********************************
  SELECT dummy, check_HDR$[], check$,""

  skip_testing:
  POPUP "Recording in progress while beeping......",0.,0.,4.
 PAUSE delay 
  HTML.OPEN
  dt = interval*1000.0 % seconds
  val1 = CLOCK ()
  val = CLOCK() + dt
  for j = 1 to n_intervals
!  FOR j = 1 TO 5
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
   DO 
    IF CLOCK()  > val      
     D_U.BREAK  
    ENDIF
   UNTIL finished
   val = val + dt
  NEXT
 
  finished:
  HTML.CLOSE
  PRINT "HDR recording completed"
  TONE 2000., 1000.
  PAUSE 6000
  SELECT dummy, more$[], yes_no_title$,""
  IF dummy = 1. | dummy = 2.
   GOTO new_start
  ELSE 
    PAUSE delay
    HTML.OPEN
    PAUSE delay
    HTML.LOAD.URL  ev_0$
    PAUSE delay
    HTML.CLOSE
    EXIT
  ENDIF
