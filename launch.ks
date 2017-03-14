CLEARSCREEN.

lock STEERING to HEADING(90, 90).

PRINT "==== LAUNCH SEQUENCE INITIATED ====".
FROM {local countdown is 3.} UNTIL countdown = 0 STEP {SET countdown to countdown - 1.} DO {
    PRINT "..." + countdown.
    IF countdown = 2 {
      PRINT "Ignition".
      STAGE.
    }
    WAIT 1. // pauses the script here for 1 second.
}. 


SET N1 to NOTE("A4", 0.8, 1).
SET V0 TO GetVoice(0).
V0:PLAY(N1).

PRINT "Liftoff".
LOCK THROTTLE TO 1.0. 
STAGE.