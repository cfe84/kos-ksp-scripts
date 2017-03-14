clearscreen.
print "== ASCENT ==".

set LOGGING to false.

set ANGLE to 90.
lock STEERING to HEADING(90, ANGLE).

lock THROTTLE to THROTT.
set THROTT to 0.33.
stage.

set KP to 0.1.
set KI to 0.01.
set KD to 0.001.
set DESIREDSPEED to 0.

set TIME_START to TIME:SECONDS.
set FILE to "log-" + random() + ".csv".
if LOGGING {
  log "time,altitude,apoapsis,speed,desiredspeed,throttle" to FILE.
}.
lock LOGLINE to (TIME:SECONDS - TIME_START) + "," + ALTITUDE + "," + APOAPSIS + "," + VERTICALSPEED + "," + DESIREDSPEED + "," + THROTT.

// You feed it speed, it spits you throttle
set throttPID to PIDLOOP(0.03, 0.04545455, 0.00495, 0, 1).

// You feed it altitude, it spits you speed
set speedPID to PIDLOOP(KP, KI, KD, -200, 200).
set speedPID:SETPOINT to 500.


until SHIP:LIQUIDFUEL < 0.1 {
  wait 0.01.    

  set DESIREDSPEED to speedPID:update(TIME:SECONDS, ALTITUDE).
  set throttPID:SETPOINT to DESIREDSPEED.
  set THROTT to throttPID:UPDATE(TIME:SECONDS, VERTICALSPEED).

  if LOGGING
    log LOGLINE to FILE.
  print "Desired speed: " + DESIREDSPEED + "                      " at (0, 6).
  print "Throttle: " + THROTT + "                         " at (0, 7) .
}.
print "finished".

wait until ship:liquidFuel < 0.1.

/////


