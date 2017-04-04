class XxxXESRPickup extends UTWeaponPickup;

static function StaticPrecache(LevelInfo L)
{
	L.AddPrecacheMaterial(Texture'XEffectMat.Ion.Ion_beam');
	L.AddPrecacheMaterial(Texture'XxxXESRv2j.HUD');
	L.AddPrecacheMaterial(Texture'XxxXESRv2j.GreenDecal');
	L.AddPrecacheMaterial(Texture'XxxXESRv2j.FireDecal');
	L.AddPrecacheMaterial(Texture'XxxXESRv2j.XxxXSpark');
	L.AddPrecacheMaterial(Texture'XxxXESRv2j.ShockRifleTex1');
	L.AddPrecacheMaterial(Texture'XxxXESRv2j.VSK_scope');
	L.AddPrecacheMaterial(Texture'XxxXESRv2j.Elite_scope');
	L.AddPrecacheMaterial(Texture'XxxXESRv2j.UT2004Scope');
	L.AddPrecacheMaterial(Texture'XxxXESRv2j.UT2004ScopePV1');
	L.AddPrecacheMaterial(Texture'XxxXESRv2j.UT2004ScopePV2');
	L.AddPrecacheMaterial(Texture'XxxXESRv2j.UT99Scope');
	L.AddPrecacheMaterial(Texture'XxxXESRv2j.RReticle');
	L.AddPrecacheMaterial(Texture'XxxXESRv2j.bluebolt');
	L.AddPrecacheMaterial(Texture'XxxXESRv2j.goldbolt');
	L.AddPrecacheMaterial(Texture'XxxXESRv2j.newredbolt');
	L.AddPrecacheMaterial(Texture'XxxXESRv2j.goldbolt');
	L.AddPrecacheMaterial(Texture'XxxXESRv2j.MatrixOldTex');
	L.AddPrecacheMaterial(Texture'XxxXESRv2j.XxxXPowerGel');
	L.AddPrecacheMaterial(Texture'XxxXESRv2j.ShockTex1');
}

simulated function UpdatePrecacheMaterials()
{
	Level.AddPrecacheMaterial(Texture'XEffectMat.Ion.Ion_beam');
	Level.AddPrecacheMaterial(Texture'XxxXESRv2j.HUD');
	Level.AddPrecacheMaterial(Texture'XxxXESRv2j.GreenDecal');
	Level.AddPrecacheMaterial(Texture'XxxXESRv2j.FireDecal');
	Level.AddPrecacheMaterial(Texture'XxxXESRv2j.XxxXSpark');
	Level.AddPrecacheMaterial(Texture'XxxXESRv2j.ShockRifleTex1');
	Level.AddPrecacheMaterial(Texture'XxxXESRv2j.VSK_scope');
	Level.AddPrecacheMaterial(Texture'XxxXESRv2j.Elite_scope');
	Level.AddPrecacheMaterial(Texture'XxxXESRv2j.UT2004Scope');
	Level.AddPrecacheMaterial(Texture'XxxXESRv2j.UT2004ScopePV1');
	Level.AddPrecacheMaterial(Texture'XxxXESRv2j.UT2004ScopePV2');
	Level.AddPrecacheMaterial(Texture'XxxXESRv2j.UT99Scope');
	Level.AddPrecacheMaterial(Texture'XxxXESRv2j.RReticle');
	Level.AddPrecacheMaterial(Texture'XxxXESRv2j.bluebolt');
	Level.AddPrecacheMaterial(Texture'XxxXESRv2j.goldbolt');
	Level.AddPrecacheMaterial(Texture'XxxXESRv2j.newredbolt');
	Level.AddPrecacheMaterial(Texture'XxxXESRv2j.goldbolt');
	Level.AddPrecacheMaterial(Texture'XxxXESRv2j.MatrixOldTex');
	Level.AddPrecacheMaterial(Texture'XxxXESRv2j.XxxXPowerGel');
	Level.AddPrecacheMaterial(Texture'XxxXESRv2j.ShockTex1');

	super.UpdatePrecacheMaterials();
}

defaultproperties
{
     StandUp=(Y=0.250000,Z=0.000000)
     MaxDesireability=0.630000
     InventoryType=Class'XxxXESRv2j.XxxXESR'
     PickupMessage="You got the Xx Shock Rifle xX"
     PickupSound=Sound'PickupSounds.ShockRiflePickup'
     PickupForce="ShockRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'NewWeaponPickups.ShockPickupSM'
     DrawScale=0.550000
     Skins(0)=Texture'XxxXESRv2j.textures.ShockRifleTex1'
     Skins(1)=FinalBlend'XxxXESRv2j.Shaders.XxxXGreenShockFinal'
}
