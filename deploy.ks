PRINT "1. Stage".STAGE.WAIT 5.Print "2. Deploying parts".FOR P IN SHIP:PARTS {
  IF P:NAME = "commDish" OR P:NAME = "longAntenna" {	Print "Deploying antenna".
    P:GetModule("ModuleDeployableAntenna"):DoEvent("extend antenna").	WAIT 5.
  }
  IF P:NAME = "solarPanels2" {	Print "Deploying solar panel".
    P:GetModule("ModuleDeployableSolarPanel"):DOEVENT("extend solar panel").	WAIT 5.
  }
}.