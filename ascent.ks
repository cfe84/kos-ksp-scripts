//run launch.
DECLARE PARAMETER target_Altitude.
DECLARE PARAMETER end_angle.

LOCK THROTTLE TO 1.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.

PRINT "== Ascent to " + target_Altitude + "m ==".

set ANGLE to 90.
lock STEERING to HEADING(90, ANGLE).

set COEFF to end_angle / TARGET_ALTITUDE.

WAIT until verticalspeed > 100.

UNTIL APOAPSIS > target_Altitude {
  set ANGLE to 90 - APOAPSIS * COEFF.
  PRINT "Pitching to " + ANGLE + " degrees" AT(2,7).
  WAIT 0.1.
}.

WAIT UNTIL apoapsis >= target_Altitude.
