PRINT "1. Stage".
  IF P:NAME = "commDish" OR P:NAME = "longAntenna" {
    P:GetModule("ModuleDeployableAntenna"):DoEvent("extend antenna").
  }
  IF P:NAME = "solarPanels2" {
    P:GetModule("ModuleDeployableSolarPanel"):DOEVENT("extend solar panel").
  }
}.