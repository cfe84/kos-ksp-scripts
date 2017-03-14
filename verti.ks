clearscreen.
print "== ASCENT ==".

set ANGLE to 90.
lock STEERING to HEADING(90, ANGLE).

set KP to 0.03.
set KI to 0.04545455.
set KD to 0.00495.

set THROTT to 1.
stage.

lock THROTTLE to THROTT.

SET PID to PIDLOOP(kp, ki, kd, 0, 1).
set PID:SETPOINT to 100.
until SHIP:LIQUIDFUEL < 0.1 {
  wait 0.01.

  set THROTT to PID:UPDATE(TIME:SECONDS, VERTICALSPEED).
}.
