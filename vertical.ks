clearscreen.
print "== ASCENT ==".

set ANGLE to 90.
lock STEERING to HEADING(90, ANGLE).

set SETPOINT to 100.

set KP to 0.003.
set KI to 0.004545455.
set KD to 0.000495.

lock ERROR to (SETPOINT - SHIP:VELOCITY:SURFACE:MAG).
set PREVIOUS_ERROR to ERROR.
set P to 0.
set I to 0.
set D to 0.
set THROTT to 1.
set T0 to TIME:SECONDS.
stage.

lock THROTTLE to THROTT.

set TIME_START to TIME:SECONDS.
set FILE to "log-" + random() + ".csv".
//log "time,altitude,speed,P,I,D,throttle" to FILE.
lock LOGLINE to (TIME:SECONDS - TIME_START) + "," + ALTITUDE + "," + SHIP:VELOCITY:SURFACE:MAG + "," + P + "," + I + "," + D + "," + THROTT.

until SHIP:LIQUIDFUEL < 0.1 {
  wait 0.01.
  print "Error: " + ERROR at (0, 5).
  set DT to TIME:SECONDS - T0.
  set P to KP * ERROR.
  set I to KI * (I + ERROR * DT).
  set D to KD * (ERROR - PREVIOUS_ERROR) / DT.
  set PREVIOUS_ERROR to ERROR.

  set THROTT to THROTT + P + I + D.
  print "Pre-throttle: " + THROTT at (0, 6).
  if THROTT > 1 {
    set THROTT to 1.
  }.
  if THROTT < 0 {
    set THROTT to 0.
  }.

  //log LOGLINE to FILE.

  set T0 to TIME:SECONDS.
  print "Throttle: " + THROTTLE at (0, 7).
  print "P: " + P at (0, 8).
  print "I: " + I at (0, 9).
  print "D: " + D at (0, 10).
}.
