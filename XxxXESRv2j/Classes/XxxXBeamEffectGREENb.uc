class XxxXBeamEffectGREENb extends ShockBeamEffect;

simulated function SpawnImpactEffects(rotator HitRot, vector EffectLoc)
{
	Spawn(class'GreenRing',,, EffectLoc, HitRot);
	Spawn(class'GreenImpactScorch',,, EffectLoc, Rotator(-HitNormal));
        spawn(class'GreenExplosionCore',,, EffectLoc + HitNormal, HitRot);

   if ( class'Clientinfo'.default.bEnableSparks == True )
	Spawn(class'GreenSparks',,, EffectLoc, HitRot);
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
     CoilClass=Class'XxxXESRv2j.XxxXCoilGREEN'
     MuzFlashClass=Class'XxxXESRv2j.GreenMuzFlash'
     MuzFlash3Class=Class'XxxXESRv2j.GreenMuzFlash3rd'
     mRegen=False
     mStartParticles=10
     mMaxParticles=1
     mLifeRange(0)=0.500000
     mLifeRange(1)=0.000000
     mSizeRange(0)=7.000000
     mSizeRange(1)=0.000000
     mColorRange(0)=(B=50,G=240,R=50)
     mColorRange(1)=(B=240,G=0,R=0)
     bNetTemporary=False
     Skins(0)=Texture'XEffectMat.Ion.Ion_beam'
}
