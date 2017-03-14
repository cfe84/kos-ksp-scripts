run launch.

run stage.

PRINT "== Ascent ==".

set ANGLE to 90.
lock STEERING to HEADING(90, ANGLE).

set TARGET_ALTITUDE to 30000.
set COEFF to 90 / TARGET_ALTITUDE.

WHEN SHIP:VELOCITY:SURFACE:MAG > 100 THEN {
  set ANGLE to 90 - altitude * COEFF.
  PRINT "Pitching to " + ANGLE + " degrees" AT(0,15).
  IF ANGLE > 0 AND APOAPSIS < 80000{
    preserve.
  }
  ELSE {
    set ANGLE to 0.
  }.
  WAIT 0.5.
}.

WHEN APOAPSIS > 80000 then {
  CLEARSCREEN.
  PRINT "== Rounding orbit ==".

  LOCK THROTTLE to 0.

  WHEN (ETA:APOAPSIS <= 60 AND PERIAPSIS < -400000) OR (ETA:APOAPSIS <= 20) THEN {
    PRINT "Burning" at (0, 5).
    LOCK THROTTLE to 1.
    IF PERIAPSIS < 80000 {
      WAIT 0.1.
      PRESERVE.
    }.
  }.

  WHEN ETA:APOAPSIS > 30 AND (ETA:APOAPSIS > 60 OR PERIAPSIS > -400000) THEN {
    PRINT "Waiting" at (0, 5).
    lock THROTTLE to 0.
    IF PERIAPSIS < 80000 {
      WAIT 0.1.
      PRESERVE.
    }.
  }.
}.

WAIT UNTIL PERIAPSIS > 80000.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.