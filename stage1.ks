CLEARSCREEN.
PRINT "Stage 1 program.".

lock STEERING to HEADING(90, 90).

PRINT "1. Ignition".
LOCK THROTTLE TO 1.0. 
STAGE.
WAIT 1.
PRINT "2. Lift Off".
STAGE.
PRINT "3. Ascending".
RUN ascent(80000, 45).

SET message to "stage".
SET p TO PROCESSOR("stage2").
P:Connection:SENDMESSAGE(message).