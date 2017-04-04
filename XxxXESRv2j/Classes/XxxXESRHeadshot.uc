class XxxXESRHeadshot extends WeaponDamageType
	abstract;

var class<LocalMessage> KillerMessage;
var sound HeadHunter; // OBSOLETE

static function IncrementKills(Controller Killer)
{
	local xPlayerReplicationInfo xPRI;
	
	if ( PlayerController(Killer) == None )
		return;
		
	PlayerController(Killer).ReceiveLocalizedMessage( Default.KillerMessage, 0, Killer.PlayerReplicationInfo, None, None );
	xPRI = xPlayerReplicationInfo(Killer.PlayerReplicationInfo);
	if ( xPRI != None )
	{
		xPRI.headcount++;
		if ( (xPRI.headcount == 15) && (UnrealPlayer(Killer) != None) )
			UnrealPlayer(Killer).ClientDelayedAnnouncementNamed('HeadHunter',15);
	}
}

defaultproperties
{
     KillerMessage=Class'XGame.SpecialKillMessage'
     WeaponClass=Class'XxxXESRv2j.XxxXESR'
     DeathString="%o's head was displaced by %k's SSR"
     FemaleSuicide="%o violated the laws of space-time and sniped herself."
     MaleSuicide="%o violated the laws of space-time and sniped himself."
     bAlwaysSevers=True
     bSpecial=True
     bDetonatesGoop=True
     bSkeletize=True
     bCauseConvulsions=True
     GibPerterbation=0.750000
     VehicleDamageScaling=0.050000
     VehicleMomentumScaling=0.300000
}
