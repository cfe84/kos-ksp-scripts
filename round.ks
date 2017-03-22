DECLARE PARAMETER targetAltitude.

run once autostageLiquid.

CLEARSCREEN.
PRINT "== ROUNDING ORBIT TO " + targetAltitude + "M ==".
LOCK steering TO HEADING(90, 0).

SET spaces to "                                       ".


set myThrottle to throttle.
LOCK throttle TO myThrottle.


SET altitudeSpan to 10000.
SET coeff TO 1.5 / altitudeSpan.
UNTIL APOAPSIS >= targetAltitude {
  WAIT 0.1.
  SET mythrottle TO MAX(0.01, MIN(1, (targetAltitude - APOAPSIS) * coeff)).
}.




SET kp TO 0.1.
SET ki TO 0.05.
SET kd TO 0.001.
SET minTime TO 10.
SET maxTime TO 60 - minTime.
SET altitudeSpan to 1000.
SET coeff to maxTime / altitudeSpan.

SET throttlePid TO PIDLOOP(kp, ki, kd, 0, 1).
SET throttlePid:setpoint TO 0.

LOCK timetoapo TO MAX(0, MIN(maxTime, (targetAltitude - APOAPSIS + 100) * coeff)) + minTime.
LOCK diff to ETA:APOAPSIS - timetoapo.

UNTIL PERIAPSIS >= targetAltitude OR ETA:PERIAPSIS < ETA:APOAPSIS {
  WAIT 0.1.
  SET mythrottle TO throttlePid:update(TIME:SECONDS, diff).

  print " Target ETA to apo: "  + timetoapo + spaces at (2,4).
  print "             Error: " + diff + spaces at (2,5).
  print "          Throttle: " + mythrottle + spaces at (2,6).
}.

CLEARSCREEN.
