//=============================================================================
// XxxX ESR - Modified by *XxZER01xX* - WwW.ELITEKILLAS.COM
//=============================================================================
class XxxXESR extends SuperShockRifle;

var() bool bZoomed;
var float  MyZoomLevel;    
var float  FOVAdj;
var transient float LastFOV;

var float  NextFireTime; // used so scopes can access the next fire time.
var float  FireRate;     // used so scopes can access the fire rate.

var XxxXScope CurrentScope;
var String  CurrentSound;
var String  CurrentScopeClassName;
var bool    bZoomSound;
var String MyDefaultSound;

var String MyDefaultPowerGel;
var String  CurrentPowerGel;

var float ROF;
var bool RepbEnableZoom;

replication
{
  reliable if( bNetInitial && ( Role==ROLE_Authority ) )
	RepbEnableZoom, ROF;
}

simulated function PostBeginPlay()
{
  Super.PostBeginPlay();

   MyZoomLevel = ( 90 * 8.3 - 90 ) / ( 8.3 * 88 );
   bZoomSound = class'XxxXESRv2j.ClientInfo'.default.bZoomSound;
   bUseOldWeaponMesh = class'XxxXESRv2j.ClientInfo'.default.bUseOldWeaponMesh;

  if( Role==Role_Authority )
    ROF = class'MutXxxXInstaGib'.default.ROF;

  if ( class'MutXxxXInstaGib'.default.bEnableZoom == False )
    RepbEnableZoom=True;

  if ( (class'MutXxxXInstaGib'.default.bNormalWeapons) && (class'MutXxxXInstaGib'.default.bESRStart == False) )
    bCanThrow=True;

  if ( bUseOldWeaponMesh )
   {
    Skins[0] = Texture'XxxXESRv2j.ShockTex1';
    Skins[1] = combiner'XxxXESRv2j.MatrixOldComb';
    DisplayFOV = 60;
    HighDetailOverlay = NONE;
   }

  if ( Class'ClientInfo'.default.bFirstRun )
  {
    ConsoleCommand("Set Input f7 Mutate XxxXESR");
    Class'ClientInfo'.default.bFirstRun = False;
    Class'ClientInfo'.StaticSaveConfig();
  }
}

simulated function PostNetBeginPlay()
{
  XxxXESRFire( FireMode[0] ).ROF = ROF;
}

exec function ZOOMIN()
{
  FOVAdj = +0.025;
}

exec function ZOOMOUT()
{
  FOVAdj = -0.025;
}

simulated function resetFOVAdj()
{
  FOVAdj = 0;
}

simulated function SetRifleSound( optional String NewRifleSound )
{
  local class<XxxXSound> RifleSoundClass;

  if( NewRifleSound != ""  )
  {
    CurrentSound = NewRifleSound;
  }
  else if( PlayerController( Instigator.Controller ) != None )
  {
    CurrentSound = class'XxxXESRv2j.ClientInfo'.default.RifleSound;
  }
  else
  {
    CurrentSound = MyDefaultSound;
  }

 RifleSoundClass = class<XxxXSound>(DynamicLoadObject( CurrentSound, class'Class'));
 XxxXESRFire( FireMode[0] ).FireSound = RifleSoundClass.default.RifleSound;

}

simulated function SetPowerGel( optional String NewPowerGel )
{
  local class<XxxXPowerGel> PowerGelClass;

  if( NewPowerGel != ""  )
  {
    CurrentPowerGel = NewPowerGel;
  }
  else if( PlayerController( Instigator.Controller ) != None )
  {
    CurrentPowerGel = class'XxxXESRv2j.ClientInfo'.default.PowerGel;
  }
  else
  {
    CurrentPowerGel = MyDefaultPowerGel;
  }

 PowerGelClass = class<XxxXPowerGel>(DynamicLoadObject( CurrentPowerGel, class'Class'));
 if ( bUseOldWeaponMesh == False)
 Skins[1] = PowerGelClass.default.PowerGel;
}

simulated function SetScope( optional String ScopeClassName )
{
  local class<XxxXScope> ScopeClass;

  // screw the bots! they don't get a scope

  if( PlayerController( Instigator.Controller ) == None ) return;

  if( CurrentScopeClassName == "" )
  {
    CurrentScopeClassName = class'XxxXESRv2j.ClientInfo'.default.ScopeClassName;
  }

  // if we have a current scope, get rid of it.
  if( CurrentScope != None )
  {
    CurrentScope.Destroy();
  }

  // replace the current if one is passed in.
  if( ScopeClassName != "" )
  {
    CurrentScopeClassName = ScopeClassName;
  }
 
  ScopeClass = class<XxxXScope>(DynamicLoadObject(CurrentScopeClassName, class'Class'));
  CurrentScope = Spawn( ScopeClass, Self );
}

simulated function Destroyed()
{
  if( CurrentScope != None )
  {
    CurrentScope.Destroy();
  }
  Super.Destroyed();
}

simulated function ClientWeaponThrown()
{
  if( (Instigator != None) && 
      (PlayerController(Instigator.Controller) != None) )
  {
    PlayerController(Instigator.Controller).EndZoom();
  }
  Super.ClientWeaponThrown();
}

simulated event RenderOverlays( Canvas Canvas )
{
  local float ZoomLevel;

if ( RepbEnableZoom == True )
{
      Super.RenderOverlays( Canvas );

	if ( (Instigator != None) && (Instigator.PlayerReplicationInfo != None) && (Instigator.PlayerReplicationInfo.Team != None) )
	{
		if ( (Instigator.PlayerReplicationInfo.Team.TeamIndex == 0 ) && ( bUseOldWeaponMesh == False) )
			Skins[1] = FinalBlend'XxxXESRv2j.XxxXRedShockFinal';
		else if ( (Instigator.PlayerReplicationInfo.Team.TeamIndex == 1 ) && ( bUseOldWeaponMesh == False) )
			Skins[1] = FinalBlend'XxxXESRv2j.XxxXBlueShockFinal';
		else if ( (Instigator.PlayerReplicationInfo.Team.TeamIndex == 2 ) && ( bUseOldWeaponMesh == False) )
			Skins[1] = FinalBlend'XxxXESRv2j.XxxXGreenShockFinal';
		else if ( (Instigator.PlayerReplicationInfo.Team.TeamIndex == 3 ) && ( bUseOldWeaponMesh == False) )
			Skins[1] = FinalBlend'XxxXESRv2j.XxxXGoldShockFinal';
	}

  if( PlayerController(Instigator.Controller) == None  ) return;

  if( CurrentScopeClassName == "" ) { SetScope(); }
  if( CurrentSound == "" )          { SetRifleSound(); }
  if( CurrentPowerGel == "" )          { SetPowerGel(); }

  NextFireTime = FireMode[0].NextFireTime;
  FireRate     = FireMode[0].FireRate;

      PlayerController(Instigator.Controller).EndZoom();
      bZoomed=false;
}

if ( RepbEnableZoom == False )
{
	if ( (Instigator != None) && (Instigator.PlayerReplicationInfo != None) && (Instigator.PlayerReplicationInfo.Team != None) )
	{
		if ( (Instigator.PlayerReplicationInfo.Team.TeamIndex == 0 ) && ( bUseOldWeaponMesh == False) )
			Skins[1] = FinalBlend'XxxXESRv2j.XxxXRedShockFinal';
		else if ( (Instigator.PlayerReplicationInfo.Team.TeamIndex == 1 ) && ( bUseOldWeaponMesh == False) )
			Skins[1] = FinalBlend'XxxXESRv2j.XxxXBlueShockFinal';
		else if ( (Instigator.PlayerReplicationInfo.Team.TeamIndex == 2 ) && ( bUseOldWeaponMesh == False) )
			Skins[1] = FinalBlend'XxxXESRv2j.XxxXGreenShockFinal';
		else if ( (Instigator.PlayerReplicationInfo.Team.TeamIndex == 3 ) && ( bUseOldWeaponMesh == False) )
			Skins[1] = FinalBlend'XxxXESRv2j.XxxXGoldShockFinal';
	}

  if( PlayerController(Instigator.Controller) == None  ) return;

  if( CurrentScopeClassName == "" ) { SetScope(); }
  if( CurrentSound == "" )          { SetRifleSound(); }
  if( CurrentPowerGel == "" )          { SetPowerGel(); }

  NextFireTime = FireMode[0].NextFireTime;
  FireRate     = FireMode[0].FireRate;

  if( ( FOVAdj != 0.0 ) && 
      ( bZoomed ) && 
      ( !PlayerController(Instigator.Controller).bZooming ) )
  {
    ZoomLevel = PlayerController(Instigator.Controller).ZoomLevel;
    ZoomLevel += FOVAdj;
    if( ZoomLevel > MyZoomLevel ) ZoomLevel = MyZoomLevel;
    if( ZoomLevel <= 0.0 )
    {
      PlayerController(Instigator.Controller).ZoomLevel = 0;
      PlayerController(Instigator.Controller).EndZoom();
      bZoomed=false;
    }
    else
    {
      PlayerController(Instigator.Controller).DesiredFOV = FClamp(90.0 - (ZoomLevel * 88.0), 1, 170);
      PlayerController(Instigator.Controller).ZoomLevel = ZoomLevel;
    }
    resetFOVAdj();
  }

  if( bZoomSound )
  {
    if( LastFOV > PlayerController(Instigator.Controller).DesiredFOV )
    {
      PlaySound(Sound'WeaponSounds.LightningGun.LightningZoomIn',
                SLOT_Misc,,, ,,false);
    }
    else if( LastFOV < PlayerController(Instigator.Controller).DesiredFOV )
    {
      PlaySound(Sound'WeaponSounds.LightningGun.LightningZoomOut',
                SLOT_Misc,, ,,,false);
    }
  }

  LastFOV = PlayerController(Instigator.Controller).DesiredFOV;

  if( PlayerController(Instigator.Controller).DesiredFOV == 
      PlayerController(Instigator.Controller).DefaultFOV )
  {
    Super.RenderOverlays( Canvas );
    if( CurrentScope != None ) CurrentScope.RenderNormal( Canvas );
    bZoomed=false;
  }
  else
  {
    if( CurrentScope != None ) CurrentScope.RenderZoom( Canvas );

    bZoomed = true;
  }
}
}

simulated function ClientStartFire(int mode)
{
  if (mode == 1)
  {
    FireMode[mode].bIsFiring = true;
    if( Instigator.Controller.IsA( 'PlayerController' ) )
    {
      PlayerController(Instigator.Controller).ToggleZoomWithMax( MyZoomLevel );
    }
  }
  else
  {
    Super.ClientStartFire(mode);
  } 
}

simulated function ClientStopFire(int mode)
{
  if (mode == 1)
  {
    FireMode[mode].bIsFiring = false;
    if( Instigator.Controller.IsA( 'PlayerController' ) )
    {
      PlayerController(Instigator.Controller).StopZoom();
    }
  }
  else
  {
    Super.ClientStopFire(mode);
  }
}

simulated function BringUp(optional Weapon PrevWeapon)
{
  if ( PlayerController(Instigator.Controller) != None )
  {
    LastFOV = PlayerController(Instigator.Controller).DesiredFOV;
  }

  if( CurrentScope != None ) CurrentScope.BringUp( PrevWeapon );
  Super.BringUp();
}

simulated function bool PutDown()
{
  if( Instigator.Controller.IsA( 'PlayerController' ) )
  {
    PlayerController(Instigator.Controller).EndZoom();
  }
  if ( Super.PutDown() )
  {
    if( CurrentScope != None ) CurrentScope.PutDown();
    return true;
  }
  return false;
}

simulated function vector GetEffectStart()
{
    local Vector X,Y,Z;

    // this function should actually never be called in third person views
    // any effect that needs a 3rdp weapon offset should figure it out itself

    // 1st person
    if (Instigator.IsFirstPerson())
    {
        if ( WeaponCentered() )
			return CenteredEffectStart();

        GetViewAxes(X, Y, Z);
        if ( class'PlayerController'.Default.bSmallWeapons )
			return (Instigator.Location +
				Instigator.CalcDrawOffset(self) +
				SmallEffectOffset.X * X  +
				SmallEffectOffset.Y * Y * Hand +
				SmallEffectOffset.Z * Z);
        else
			return (Instigator.Location +
				Instigator.CalcDrawOffset(self) +
				EffectOffset.X * X +
				EffectOffset.Y * Y * Hand +
				EffectOffset.Z * Z);
    }
    // 3rd person
    else
    {
        return (Instigator.Location +
            Instigator.EyeHeight*Vect(0,0,0.5) +
            Vector(Instigator.Rotation) * 40.0);
    }
}

defaultproperties
{
     FireModeClass(0)=Class'XxxXESRv2j.XxxXESRFire'
     FireModeClass(1)=Class'XxxXESRv2j.XxxXZoom'
     bSniping=True
     OldPlayerViewOffset=(X=-10.000000,Y=3.000000,Z=-2.000000)
     OldSmallViewOffset=(X=2.000000,Y=9.000000)
     Description="XxxX InstaGib v2h / F7 brings up the In-Game Weapon Menu / Visit www.elitekillas.com for updates, contact info, and other fine mutators."
     Priority=15
     CustomCrossHairColor=(B=0,G=255)
     PickupClass=Class'XxxXESRv2j.XxxXESRPickup'
     AttachmentClass=Class'XxxXESRv2j.XxxXAttachment'
     IconMaterial=Texture'XxxXESRv2j.HUD'
     ItemName="Xx SuperShock xX"
     Skins(0)=Texture'XxxXESRv2j.textures.ShockRifleTex1'
     Skins(1)=FinalBlend'XxxXESRv2j.Shaders.XxxXGreenShockFinal'
}
