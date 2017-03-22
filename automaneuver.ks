CLEARSCREEN.
PRINT "=== Maneuver ===".

IF not HASNODE {
  PRINT " You don't have a node ".
}.

SET n TO NEXTNODE.
LOCK steering TO n.

SET acceleration TO ship:maxthrust / ship:mass.
SET duration TO n:deltav:mag / acceleration.

PRINT "- waiting for node to be at " + duration / 2.
WAIT UNTIL n:eta <= (duration / 2).

PRINT "- executing burn".

SET mythrottle TO 0.
LOCK throttle TO mythrottle.

UNTIL n:deltav:mag < 0.1 {
  SET mythrottle TO min(n:deltav:mag / acceleration, 1).
  WAIT 0.01.
}.

PRINT "- burn done. DeltaV:" + n:deltav:mag.

REMOVE n.
