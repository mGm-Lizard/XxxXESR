class XxxXESRFire extends SuperShockBeamFire;

var() float HeadShotRadius;
var() class<DamageType> DamageTypeHeadShot;
var bool bDisableMultiHit;
var float ROF;
var bool bBerserk;

function bool AllowMultiHit()
{
   if ( class'MutXxxXInstaGib'.default.bEnableMultiHit )
        bDisableMultiHit=True;
	return bDisableMultiHit;

   if ( class'MutXxxXInstaGib'.default.bEnableMultiHit == False )
        bDisableMultiHit=False;
	return false;
}

function TracePart(Vector Start, Vector End, Vector X, Rotator Dir, Pawn Ignored)
{
    local Vector HitLocation, HitNormal;
    local Actor Other;
    local float dist;

    Other = Ignored.Trace(HitLocation, HitNormal, End, Start, true);

    if ( (Other != None) && (Other != Ignored) )
    {
        if ( !Other.bWorldGeometry )
        {
            if ( (Pawn(Other) != None) && Other.GetClosestBone( HitLocation, X, dist, 'head', HeadShotRadius ) == 'head' && AllowMultiHit() )
            Other.TakeDamage(DamageMax, Instigator, HitLocation, Momentum*X, DamageTypeHeadShot);
            else
            {
            Other.TakeDamage(DamageMax, Instigator, HitLocation, Momentum*X, DamageType);
            }
            HitNormal = Vect(0,0,0);
            if ( (Pawn(Other) != None) && (HitLocation != Start) && AllowMultiHit() )
				TracePart(HitLocation,End,X,Dir,Pawn(Other));
        }
    }
    else
    {
        HitLocation = End;
        HitNormal = Vect(0,0,0);
    }
    SpawnBeamEffect(Start, Dir, HitLocation, HitNormal, 0);
}


event ModeDoFire()
{

  FireRate = ROF;

  if( bBerserk )
  {
    FireRate *= 0.70;
  }
 
  Super.ModeDoFire();
}

function StartBerserk()
{
  bBerserk = true;
  FireAnimRate = default.FireAnimRate * 0.70;
}

function StopBerserk()
{
  bBerserk = false;
  FireAnimRate = default.FireAnimRate;
}

function SpawnBeamEffect (Vector Start, Rotator Dir, Vector HitLocation, Vector HitNormal, int ReflectNum)
{
  local ShockBeamEffect Beam;

  if ( Instigator.PlayerReplicationInfo != None )
  {
      if ( (Instigator.PlayerReplicationInfo.Team != None) && (Instigator.PlayerReplicationInfo.Team.TeamIndex == 0) )
	Beam = Weapon.Spawn(Class'XxxXBeamEffectRED',,,Start,Dir);

      else if ( (Instigator.PlayerReplicationInfo.Team != None) && (Instigator.PlayerReplicationInfo.Team.TeamIndex == 1) )
        Beam = Weapon.Spawn(Class'XxxXBeamEffectBLUE',,,Start,Dir);

      else if ( (Instigator.PlayerReplicationInfo.Team != None) && (Instigator.PlayerReplicationInfo.Team.TeamIndex == 2) )
        Beam = Weapon.Spawn(Class'XxxXBeamEffectGREENb',,,Start,Dir);

      else if ( (Instigator.PlayerReplicationInfo.Team != None) && (Instigator.PlayerReplicationInfo.Team.TeamIndex == 3) )
        Beam = Weapon.Spawn(Class'XxxXBeamEffectGOLD',,,Start,Dir);

      else if ( (Instigator.PlayerReplicationInfo.Team == None ) && ( class'XxxXESRv2j.MutXxxXInstaGib'.default.XxxXBeamEffect == 0) )
        Beam = Weapon.Spawn(Class'XxxXBeamEffectGREEN',,,Start,Dir);

      else if ( (Instigator.PlayerReplicationInfo.Team == None ) && ( class'XxxXESRv2j.MutXxxXInstaGib'.default.XxxXBeamEffect == 1) )
        Beam = Weapon.Spawn(Class'XxxXBeamEffectFIRE',,,Start,Dir);

      else if ( (Instigator.PlayerReplicationInfo.Team == None ) && ( class'XxxXESRv2j.MutXxxXInstaGib'.default.XxxXBeamEffect == 2) )
        Beam = Weapon.Spawn(Class'XxxXBeamEffectPURPLE',,,Start,Dir);

      else if ( (Instigator.PlayerReplicationInfo.Team == None ) && ( class'XxxXESRv2j.MutXxxXInstaGib'.default.XxxXBeamEffect == 3) )
        Beam = Weapon.Spawn(Class'XxxXBeamEffectRED',,,Start,Dir);

      else if ( (Instigator.PlayerReplicationInfo.Team == None ) && ( class'XxxXESRv2j.MutXxxXInstaGib'.default.XxxXBeamEffect == 4) )
        Beam = Weapon.Spawn(Class'XxxXBeamEffectBLUE',,,Start,Dir);

      else if ( (Instigator.PlayerReplicationInfo.Team == None ) && ( class'XxxXESRv2j.MutXxxXInstaGib'.default.XxxXBeamEffect == 5) )
        Beam = Weapon.Spawn(Class'XxxXESRv2j.RedSuperShockBeam',,,Start,Dir);

      else if ( (Instigator.PlayerReplicationInfo.Team == None ) && ( class'XxxXESRv2j.MutXxxXInstaGib'.default.XxxXBeamEffect == 6) )
        Beam = Weapon.Spawn(Class'XxxXESRv2j.BlueSuperShockBeam',,,Start,Dir);

      if ( ReflectNum != 0 )
      {
        Beam.Instigator = None;
      }
      Beam.AimAt(HitLocation,HitNormal);
  }
}

defaultproperties
{
     HeadShotRadius=7.000000
     DamageTypeHeadShot=Class'XxxXESRv2j.XxxXESRHeadshot'
     BeamEffectClass=None
     DamageType=Class'XxxXESRv2j.XxxXESRInstaGib'
     TraceRange=24000.000000
     FireRate=0.900000
     AmmoClass=Class'XxxXESRv2j.XxxXAmmo'
     FlashEmitterClass=Class'XEffects.ShockMuzFlash3rd'
}
