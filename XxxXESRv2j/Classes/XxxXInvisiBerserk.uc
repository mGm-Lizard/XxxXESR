class XxxXInvisiBerserk extends Combo;

var xEmitter Effect;

function StartEffect(xPawn P)
{

    if (P.Role == ROLE_Authority)
     {
	if ( (Instigator.PlayerReplicationInfo.Team != None) && (Instigator.PlayerReplicationInfo.Team.TeamIndex == 0) )
        Effect = Spawn(class'XxxXOffensiveEffectRED', P,, P.Location, P.Rotation);

	else if ( (Instigator.PlayerReplicationInfo.Team != None) && (Instigator.PlayerReplicationInfo.Team.TeamIndex == 1) )
        Effect = Spawn(class'XxxXOffensiveEffectBLUE', P,, P.Location, P.Rotation);

	else if ( (Instigator.PlayerReplicationInfo.Team != None) && (Instigator.PlayerReplicationInfo.Team.TeamIndex == 2) )
        Effect = Spawn(class'XxxXOffensiveEffectGREEN', P,, P.Location, P.Rotation);

	else if ( (Instigator.PlayerReplicationInfo.Team != None) && (Instigator.PlayerReplicationInfo.Team.TeamIndex == 3) )
        Effect = Spawn(class'XxxXOffensiveEffectGOLD', P,, P.Location, P.Rotation);

	else
	 Effect = Spawn(class'OffensiveEffect', P,, P.Location, P.Rotation);
     }


    if (P.Weapon != None)
        P.Weapon.StartBerserk();

    P.bBerserk = true;
    P.SetInvisibility(60.0);
    P.Controller.Adrenaline=70;
}

function StopEffect(xPawn P)
{
    local Inventory Inv;

    if (Effect != None)
        Effect.Destroy();

    for ( Inv=P.Inventory; Inv!=None; Inv=Inv.Inventory )
        if (Inv.IsA('Weapon'))
        {
            Weapon(Inv).StopBerserk();
        }

    P.bBerserk = false;
    P.SetInvisibility(0.0);
}

defaultproperties
{
     ExecMessage="Invisi-Berserk!"
     ComboAnnouncementName="GodLike"
     keys(0)=2
     keys(1)=2
     keys(2)=2
     keys(3)=2
}
