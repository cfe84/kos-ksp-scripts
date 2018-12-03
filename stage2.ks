CLEARSCREEN.
PRINT "Stage 2 program.".
WAIT UNTIL NOT CORE:MESSAGES:EMPTY.

LOCK fairing_sep_altitude TO SHIP:ALTITUDE > 30000.

ON fairing_sep_altitude {
	PRINT "4. Payload fairing separation".
	STAGE.
}

SET RECEIVED TO CORE:MESSAGES:POP.
PRINT "1. Fairing separation".
STAGE.
WAIT 1.

PRINT "2. Stage separation and distancing".
STAGE.
STAGE.
WAIT UNTIL SHIP:SOLIDFUEL = 0.

PRINT "3. Starting burn".

run round(100000).