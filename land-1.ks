declare PARAMETER b.

clearscreen.
PRINT "=== LANDING on " + b:name + " ===".

SET logfile TO "land" + (round(random()*10000)) + ".txt".
SET initTime TO TIME:SECONDS.

LOG "time,altitude,vx,vy,throttle" TO logfile.

LOCK logLine TO (TIME:SECONDS - initTime) + "," + ALT:RADAR + "," + verticalspeed + "," + groundSpeed + "," + THROTTLE.
LOG logLine TO logfile.

SET spaces to "                  ".
SET g to b:mu / (b:radius * b:radius).
SET acceleration TO SHIP:maxthrust / SHIP:mass.

PRINT "- Waiting for radar to catch altitude" + spaces.

WAIT UNTIL ALT:RADAR < 10000.
LOG logLine TO logfile.
SAS ON.
WAIT 0.001.
SET SASMODE TO "retrograde".

WAIT UNTIL ALT:RADAR < 9900.
LOG logLine TO logfile.

SET speed TO SHIP:VELOCITY:SURFACE:MAG.
// v = sqrt ( 2 * h / g)
SET potentialVertSpeed TO -SQRT(2 * ALT:RADAR / g).

SET totalVertSpeed TO potentialVertSpeed + verticalSpeed.
SET totalSpeed TO SQRT(totalVertSpeed ^ 2 + groundSpeed ^ 2).
SET totalBurn TO totalSpeed / acceleration.

//SET verticalAcceleration TO (verticalSpeed / speed) * acceleration.
// h = a . t^2 / 2 -> SET altForVerticalVelocity TO verticalAcceleration * (verticalSpeed / verticalAcceleration) ^ 2 / 2.
// simplified to
//SET altForVerticalVelocity TO (verticalSpeed * speed) / (2 * verticalAcceleration).

//SET distForHorizontalVelocity TO (groundSpeed * speed) / (2 * acceleration).
// x = h . sin(arccos(y/h)) => y = h . sqrt(1 - (x/h) ^ 2)
//SET altForHorizontalVelocity TO speed * sqrt(1 - (groundSpeed / speed)).

//SET altForGravity TO (potentialVertSpeed ^ 2) / (2 * acceleration).

//SET optimalAlt TO altForGravity + altForVerticalVelocity + altForHorizontalVelocity.
//SET targetAlt TO optimalAlt + 300.

//SET targetAlt TO -totalBurn * totalVertSpeed - 1/2 * g * totalBurn ^ 2 - 1/2 * verticalAcceleration ^ 2.

LOCK remainingFlightTime TO (verticalSpeed + SQRT(verticalSpeed ^ 2 + 2 * g * ALT:RADAR)) / g.
SET fireAt TO totalBurn - SQRT(2 * totalBurn).
SET burningAlt TO -(totalVertSpeed * totalBurn).

PRINT "                            g: " + ROUND(g,2) + "m/s2" + spaces.
PRINT "                    MaxThrust: " + ROUND(SHIP:maxthrust) + "N" + spaces.
PRINT "              MaxAcceleration: " + ROUND(acceleration) + "m/s2" + spaces.
PRINT "               Vertical speed: " + ROUND(verticalSpeed) + "m/s" + spaces.
PRINT "              Potential speed: " + ROUND(potentialVertSpeed) + "m/s" + spaces.
//PRINT "             Optimal altitude: " + ROUND(optimalAlt) + "m" + spaces.
//PRINT "        Will burn at altitude: " + ROUND(targetAlt) + "m" + spaces.
PRINT "                    Burn time: " + ROUND(totalBurn) + "s" + spaces.
//PRINT "        Remaining flight time: " + ROUND(remainingFlightTime, 1) + "s" + spaces.
PRINT "                   Burning at: " + ROUND(fireAt) + "s" + spaces.
PRINT "                   Burning at: " + ROUND(burningAlt) + "m" + spaces.

//SET targetAlt TO 5000.

WAIT UNTIL ALT:RADAR < burningAlt + 50.
//WAIT remainingFlightTime - fireAt.

LOCK throttle TO 1.

set T0 to TIME:SECONDS.
UNTIL SHIP:VELOCITY:SURFACE:MAG < 10 {
  LOG logLine TO logfile.
  PRINT "          Burn time (elapsed): " + ROUND(TIME:SECONDS - T0) + "s" + spaces AT (0, 19).
  WAIT 0.1.
}.

CLEARSCREEN.
PRINT " SECOND PHASE".


set KP to 0.03.
set KI to 0.04545455.
set KD to 0.00495.

SET PID to PIDLOOP(kp, ki, kd, 0, 1).
LOCK setPoint to -MAX(0.5, ALT:RADAR / 5).

WHEN VERTICALSPEED > 3 THEN
  WHEN VERTICALSPEED < 2 THEN
    SET SASMODE to "".

until ALT:RADAR < 1 and VERTICALSPEED < 0.00001 {
  LOG logLine TO logfile.
  SET PID:SETPOINT to setPoint.
  PRINT "SetPoint: " + Round(SetPoint, 1) + "m/s" + spaces AT (0,1).
  PRINT "  Spread: " + Round(SetPoint - SHIP:VELOCITY:SURFACE:MAG, 1) + "m/s" + spaces AT (0,2).
  PRINT "     PID: " + Round(PID:UPDATE(TIME:SECONDS, VERTICALSPEED) * 100, 1) + "%" + spaces AT (0, 3).

  wait 0.01.
  LOCK THROTTLE to MIN(1, MAX(0, PID:UPDATE(TIME:SECONDS, VERTICALSPEED))).
}.

SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
LOCK THROTTLE to 0.
