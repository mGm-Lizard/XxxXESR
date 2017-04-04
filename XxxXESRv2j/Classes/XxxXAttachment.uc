class XxxXAttachment extends xWeaponAttachment;

var class<xEmitter>     MuzFlashClass;
var xEmitter            MuzFlash;
var bool bInitOldMesh;
var Mesh OldMesh;

simulated event BaseChange()
{
	if ( (Pawn(Base) != None) && (Pawn(Base).PlayerReplicationInfo != None) && (Pawn(Base).PlayerReplicationInfo.Team != None) )
	{
		if ( (Pawn(Base).PlayerReplicationInfo.Team.TeamIndex == 0 ) && ( class'ClientInfo'.Default.bUseOldWeaponMesh == false) )
			Skins[1] = FinalBlend'XxxXESRv2j.XxxXRedShockFinal';
		else if ( (Pawn(Base).PlayerReplicationInfo.Team.TeamIndex == 1 ) && ( class'ClientInfo'.Default.bUseOldWeaponMesh == false) )
			Skins[1] = FinalBlend'XxxXESRv2j.XxxXBlueShockFinal';
		else if ( (Pawn(Base).PlayerReplicationInfo.Team.TeamIndex == 2 ) && ( class'ClientInfo'.Default.bUseOldWeaponMesh == false) )
			Skins[1] = FinalBlend'XxxXESRv2j.XxxXGreenShockFinal';
		else if ( (Pawn(Base).PlayerReplicationInfo.Team.TeamIndex == 3 ) && ( class'ClientInfo'.Default.bUseOldWeaponMesh == false) )
			Skins[1] = FinalBlend'XxxXESRv2j.XxxXGoldShockFinal';
	}
}

simulated function Destroyed()
{
    if (MuzFlash != None)
        MuzFlash.Destroy();

    Super.Destroyed();
}

simulated function PostBeginPlay()
{
  Super.PostBeginPlay();

   if ( class'ClientInfo'.Default.bUseOldWeaponMesh && (OldMesh != None) )
    {
     Skins[0] = Texture'XxxXESRv2j.ShockTex1';
     Skins[1] = combiner'XxxXESRv2j.MatrixOldComb';
		bInitOldMesh = true;
		LinkMesh(OldMesh);
		SetRelativeLocation(Vect(0,0,0));
		SetRelativeRotation(Rot(0,0,0));
    }

  if ( Instigator.PlayerReplicationInfo != None )
  {
      if ( (Instigator.PlayerReplicationInfo.Team != None) && (Instigator.PlayerReplicationInfo.Team.TeamIndex == 0) )
	LightHue=0;

      else if ( (Instigator.PlayerReplicationInfo.Team != None) && (Instigator.PlayerReplicationInfo.Team.TeamIndex == 1) )
        LightHue=160;

      else if ( (Instigator.PlayerReplicationInfo.Team != None) && (Instigator.PlayerReplicationInfo.Team.TeamIndex == 2) )
        LightHue=80;

      else if ( (Instigator.PlayerReplicationInfo.Team != None) && (Instigator.PlayerReplicationInfo.Team.TeamIndex == 3) )
        LightHue=40;

      else if ( (Instigator.PlayerReplicationInfo.Team == None ) && ( class'XxxXESRv2j.MutXxxXInstaGib'.default.XxxXBeamEffect == 0) )
        LightHue=80;

      else if ( (Instigator.PlayerReplicationInfo.Team == None ) && ( class'XxxXESRv2j.MutXxxXInstaGib'.default.XxxXBeamEffect == 1) )
        LightHue=40;

      else if ( (Instigator.PlayerReplicationInfo.Team == None ) && ( class'XxxXESRv2j.MutXxxXInstaGib'.default.XxxXBeamEffect == 2) )
        LightHue=200;

      else if ( (Instigator.PlayerReplicationInfo.Team == None ) && ( class'XxxXESRv2j.MutXxxXInstaGib'.default.XxxXBeamEffect == 3) )
        LightHue=0;

      else if ( (Instigator.PlayerReplicationInfo.Team == None ) && ( class'XxxXESRv2j.MutXxxXInstaGib'.default.XxxXBeamEffect == 4) )
        LightHue=160;

      else if ( (Instigator.PlayerReplicationInfo.Team == None ) && ( class'XxxXESRv2j.MutXxxXInstaGib'.default.XxxXBeamEffect == 5) )
        LightHue=0;

      else if ( (Instigator.PlayerReplicationInfo.Team == None ) && ( class'XxxXESRv2j.MutXxxXInstaGib'.default.XxxXBeamEffect == 6) )
        LightHue=160;
  }
}

simulated event ThirdPersonEffects()
{
    local rotator r;

    if ( Level.NetMode != NM_DedicatedServer && FlashCount > 0 )
	{
		if ( FiringMode == 0 )
			WeaponLight();
        else
        {
            if (MuzFlash == None)
            {
                MuzFlash = Spawn(MuzFlashClass);
                AttachToBone(MuzFlash, 'tip');
            }
            if (MuzFlash != None)
            {
                MuzFlash.mStartParticles++;
                r.Roll = Rand(65536);
                SetBoneRotation('Bone_Flash', r, 0, 1.f);
            }
        }
    }

    Super.ThirdPersonEffects();
}

defaultproperties
{
     MuzFlashClass=Class'XEffects.ShockProjMuzFlash3rd'
     OldMesh=SkeletalMesh'Weapons.ShockRifle_3rd'
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightHue=165
     LightSaturation=70
     LightBrightness=200.000000
     LightRadius=4.000000
     LightPeriod=3
     Mesh=SkeletalMesh'NewWeapons2004.NewShockRifle_3rd'
     RelativeLocation=(X=-3.000000,Y=-5.000000,Z=-10.000000)
     RelativeRotation=(Pitch=32768)
     Skins(0)=Texture'XxxXESRv2j.textures.ShockRifleTex1'
     Skins(1)=FinalBlend'XxxXESRv2j.Shaders.XxxXGreenShockFinal'
}
