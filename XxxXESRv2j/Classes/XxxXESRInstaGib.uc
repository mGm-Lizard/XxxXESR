class XxxXESRInstaGib extends WeaponDamageType
	abstract;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictemHealth )
{
   if ( class'Clientinfo'.default.bEnableHitSmoke )
    HitEffects[0] = class'XxxXSmokeRing';
}

defaultproperties
{
     WeaponClass=Class'XxxXESRv2j.XxxXESR'
     DeathString="%o was wasted by %k's ESR"
     FemaleSuicide="%o somehow managed to shoot herself in the neck."
     MaleSuicide="%o somehow managed to shoot himself in the neck."
     bLocationalHit=False
     bAlwaysSevers=True
     bDetonatesGoop=True
     DamageOverlayMaterial=Shader'XGameShaders.PlayerShaders.LightningHit'
     DeathOverlayMaterial=Shader'WeaponSkins.ShockLaser.LaserShader'
     DamageOverlayTime=0.900000
     GibPerterbation=0.750000
     VehicleDamageScaling=0.050000
     VehicleMomentumScaling=0.300000
}
