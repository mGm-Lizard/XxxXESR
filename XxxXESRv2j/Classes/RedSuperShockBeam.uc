class RedSuperShockBeam extends ShockBeamEffect;

simulated function SpawnImpactEffects(rotator HitRot, vector EffectLoc)
{
	Spawn(class'ShockImpactFlareB',,, EffectLoc, HitRot);
	Spawn(class'ShockImpactRingB',,, EffectLoc, HitRot);
	Spawn(class'ShockImpactScorch',,, EffectLoc, Rotator(-HitNormal));
	Spawn(class'ShockExplosionCoreB',,, EffectLoc, HitRot);

   if ( class'Clientinfo'.default.bEnableSparks == True )
	Spawn(class'RedSparks',,, EffectLoc, HitRot);
}

simulated function SpawnEffects()
{
    local ShockBeamCoil Coil;
    local xWeaponAttachment Attachment;
	
    if (Instigator != None)
    {
        if ( Instigator.IsFirstPerson() )
        {
			if ( (Instigator.Weapon != None) && (Instigator.Weapon.Instigator == Instigator) )
				SetLocation(Instigator.Weapon.GetEffectStart());
			else
				SetLocation(Instigator.Location);
            Spawn(MuzFlashClass,,, Location);
        }
        else
        {
            Attachment = xPawn(Instigator).WeaponAttachment;
            if (Attachment != None && (Level.TimeSeconds - Attachment.LastRenderTime) < 1)
                SetLocation(Attachment.GetTipLocation());
            else
                SetLocation(Instigator.Location + Instigator.EyeHeight*Vect(0,0,1) + Normal(mSpawnVecA - Instigator.Location) * 25.0); 
            Spawn(MuzFlash3Class);
        }
    }

    if ( EffectIsRelevant(mSpawnVecA + HitNormal*2,false) && (HitNormal != Vect(0,0,0)) )
		SpawnImpactEffects(Rotator(HitNormal),mSpawnVecA + HitNormal*2);

	if ( class'Clientinfo'.default.bDisableSpiral == True )
		CoilClass=NONE;
	
    if ( (!Level.bDropDetail && (Level.DetailMode != DM_Low) && (VSize(Location - mSpawnVecA) > 40) && !Level.GetLocalPlayerController().BeyondViewDistance(Location,0))
		|| ((Instigator != None) && Instigator.IsFirstPerson()) )
    {
	    Coil = Spawn(CoilClass,,, Location, Rotation);
	    if (Coil != None)
		    Coil.mSpawnVecA = mSpawnVecA;
    }
}

defaultproperties
{
     CoilClass=Class'XEffects.ShockBeamCoilB'
     MuzFlashClass=Class'XEffects.ShockMuzFlashB'
     MuzFlash3Class=Class'XEffects.ShockMuzFlashB3rd'
     bNetTemporary=False
     Skins(0)=ColorModifier'InstagibEffects.Effects.RedSuperShockBeam'
}
