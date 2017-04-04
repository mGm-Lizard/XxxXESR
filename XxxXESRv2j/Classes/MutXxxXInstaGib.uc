class MutXxxXInstaGib extends Mutator
	config(XxxXESRv2j);

var config bool bEnableBoost;
var config bool bEnableZoom;
var config bool bEnableMultiHit;
var config float ROF;
var config int XxxXBeamEffect;
var config bool bNormalWeapons;
var config bool bESRStart;
var config bool bInstaGibSkull;
var config bool bShowServerInfo;
var config string ServerLocation;
var config bool bInvisiBerserk;

var class<ESRConfigInfo> ESRConfigInfoClass;
var ESRConfigInfo ESRConfigInfo;

var localized string BoostDisplayText, BoostDescText, ROFDisplayText, ROFDescText, ZoomDisplayText, ZoomDescText, MultiHitDisplayText, MultiHitDescText, BeamColorDisplayText, BeamColorDescText, bInvisiBerserkDisplayText, bInvisiBerserkDescText;
var localized string bNormalWeaponsDisplayText, bNormalWeaponsDescText, bInstaGibSkullDisplayText, bInstaGibSkullDescText, bESRStartDisplayText, bESRStartDescText, bShowServerInfoDisplayText, bShowServerInfoDescText, ServerLocationDisplayText, ServerLocationDescText;

static function FillPlayInfo(PlayInfo PlayInfo)
{
	Super.FillPlayInfo(PlayInfo);

	PlayInfo.AddSetting("XxxX InstaGib", "bEnableBoost", default.BoostDisplayText, 1, 1, "Check");
	PlayInfo.AddSetting("XxxX InstaGib", "bEnableZoom", default.ZoomDisplayText, 1, 1, "Check");
	PlayInfo.AddSetting("XxxX InstaGib", "ROF", Default.ROFDisplayText, 1, 1, "Text", "3;0.2:2");
	PlayInfo.AddSetting("XxxX InstaGib", "bEnableMultiHit", default.MultiHitDisplayText, 1, 1, "Check");
	PlayInfo.AddSetting("XxxX InstaGib", "XxxXBeamEffect", default.BeamColorDisplayText, 1, 1, "Select", "0;XxxXGREEN;1;XxxXFIRE;2;XxxXPURPLE;3;XxxXRED;4;XxxXBLUE;5;ClassicRED;6;ClassicBlue");
	PlayInfo.AddSetting("XxxX InstaGib", "bNormalWeapons", default.bNormalWeaponsDisplayText, 1, 1, "Check");
	PlayInfo.AddSetting("XxxX InstaGib", "bESRStart", default.bESRStartDisplayText, 1, 1, "Check");
	PlayInfo.AddSetting("XxxX InstaGib", "bInstaGibSkull", default.bInstaGibSkullDisplayText, 1, 1, "Check");
	PlayInfo.AddSetting("XxxX InstaGib", "bShowServerInfo", default.bShowServerInfoDisplayText, 1, 1, "Check");
	PlayInfo.AddSetting("XxxX InstaGib", "ServerLocation", default.ServerLocationDisplayText, 1, 1, "Text", "20");
	PlayInfo.AddSetting("XxxX InstaGib", "bInvisiBerserk", default.bInvisiBerserkDisplayText, 1, 1, "Check");
}

static event string GetDescriptionText(string PropName)
{
	switch (PropName)
	{
		case "bEnableBoost":		return default.BoostDescText;
		case "ROF":			return Default.ROFDescText;
		case "bEnableZoom":		return Default.ZoomDescText;
		case "bEnableMultiHit":		return Default.MultiHitDescText;
		case "XxxXBeamEffect":		return Default.BeamColorDescText;
		case "bNormalWeapons":		return Default.bNormalWeaponsDescText;
		case "bESRStart":		return Default.bESRStartDescText;
		case "bInstaGibSkull":		return Default.bInstaGibSkullDescText;
		case "bShowServerInfo":		return Default.bShowServerInfoDescText;
		case "ServerLocation":		return Default.ServerLocationDescText;
		case "bInvisiBerserk":		return Default.bInvisiBerserkDescText;
	}
	return Super.GetDescriptionText(PropName);
}

function PreBeginPlay ()
{
  local Mutator M;
  Super.PreBeginPlay();

  StaticSaveConfig();

 if ( (bESRStart) && (bNormalWeapons) )
  DefaultWeaponName="XxxXESRv2j.XxxXESR";

 if (bInstaGibSkull)
 {
  M = Spawn(Class'XxxXESRv2j.MutInstaGib');

  if ( Level.Game.BaseMutator != None )
  {
    M.NextMutator = Level.Game.BaseMutator.NextMutator;
    Level.Game.BaseMutator.NextMutator = M;
  } 
    else 
  {
    Level.Game.BaseMutator = M;
  }
 }
}

simulated function BeginPlay()
{
	local Pickup L;
	local xWeaponBase B;
	local xPickupBase P;

     If (bNormalWeapons == False)
     {
	foreach AllActors(class'xPickupBase', P)
	{
		P.bHidden = true;
		if (P.myEmitter != None)
			P.myEmitter.Destroy();
	}

	foreach AllActors(class'xWeaponBase', B)
	{
		B.bHidden = true;
		if (B.myEmitter != None)
			B.myEmitter.Destroy();
	}

	foreach AllActors(class'Pickup', L)
		if ( L.IsA('WeaponLocker') )
			L.GotoState('Disabled');
     }
	Super.BeginPlay();
}

Simulated function PostBeginPlay()
{
     Super.PostBeginPlay();
	if ( bEnableBoost == True && (TeamGame(Level.Game) != None) )
		TeamGame(Level.Game).TeammateBoost = 1.0;
}

function string RecommendCombo(string ComboName)
{
	if ( (ComboName != "xGame.ComboSpeed") && (ComboName != "xGame.ComboInvis") )
	{
		if ( FRand() < 0.65 )
			ComboName = "xGame.ComboInvis";
		else
			ComboName = "xGame.ComboSpeed";
	}

	return Super.RecommendCombo(ComboName);
}

function bool AlwaysKeep(Actor Other)
{
	if ( Other.IsA('XxxXESR') )
		return true;

	if ( NextMutator != None )
		return ( NextMutator.AlwaysKeep(Other) );
	return false;
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant) 
{
	local int i;
	local WeaponLocker L;

     If (bNormalWeapons == False)
     {
	bSuperRelevant = 0;

	if (Other.isA('xPawn')) 
	{
		xPawn(Other).RequiredEquipment[0] = "XxxXESRv2j.XxxXESR";
		xPawn(Other).RequiredEquipment[1] = "XxxXESRv2j.XxxXESR";
	}

	if(Weapon(Other) != None)
	{
		if(Other.IsA('BallLauncher')) 
		{
			return true;
		}
	} 

	else if(Other.isA('ShieldGun')) 
	{
		return false;
	} 

	else if(Other.isA('UTWeaponPickup')) 
	{
		return false;
	} 

	else if(Other.isA('UTAmmoPickup')) 
	{
		return false;
	} 

	else if(Other.IsA('Pickup'))
	{
		return false;
	}

	else if(Other.IsA('xPickupBase'))
	{
		Other.bHidden = true;
	}

	return true;
     }

     else if (bNormalWeapons)
     {
	if ( xWeaponBase(Other) != None )
	{
		if ( xWeaponBase(Other).WeaponType == class'XWeapons.SuperShockRifle' )
			xWeaponBase(Other).WeaponType = class'XxxXESRv2j.XxxXESR';
	}

	else if ( WeaponPickup(Other) != None )
	{
		if ( string(Other.Class) == "XWeapons.SuperShockRifle" )
			ReplaceWith( Other, "XxxXESRv2j.XxxXESRPickup");
        }

	else if ( WeaponLocker(Other) != None )
	{
		L = WeaponLocker(Other);
		for (i = 0; i < L.Weapons.Length; i++)
		if ( L.Weapons[i].WeaponClass == class'SuperShockRifle')
			L.Weapons[i].WeaponClass = class'XxxXESR';
	}
	bSuperRelevant = 0;
	return true;
      }
}

simulated function Tick(float DeltaTime)
{
	local xPlayer PC;
	local int i;

     if (bInvisiBerserk)
     {
	if (Level.NetMode == NM_DedicatedServer)
	{
		disable('Tick');
		return;
	}

	PC = xPlayer(Level.GetLocalPlayerController());
	if (PC == None)
		return;

	for (i = 0; i < ArrayCount(PC.ComboList); i++)
		if (PC.ComboList[i] == class'ComboDefensive')
			PC.ComboList[i] = class'XxxXInvisiBerserk';
	disable('Tick');
      }
}

function Mutate( string MutateString, PlayerController Sender )
{
  if( ( Caps( Left( MutateString, 7 ) ) == "XXXXESR" ) )
  {
    if( ESRConfigInfo == None )
    {
      ESRConfigInfo = spawn( class'XxxXESRv2j.ESRConfigInfo' );
      ESRConfigInfo.MainInfoClass = ESRConfigInfoClass;
      ESRConfigInfo.Load();
    }

    if( Caps( Left( MutateString, 7 ) ) == "XXXXESR" )
    {
      Sender.ClientOpenMenu( "XxxXESRv2j.GUIClientMain" );
    }
  }
  Super.Mutate( MutateString, Sender );
}

function GetServerDetails( out GameInfo.ServerResponseLine ServerState )
{
   local int i;

 if (bShowServerInfo)
 {
   i = ServerState.ServerInfo.Length;
   ServerState.ServerInfo.Length = i+8;
   ServerState.ServerInfo[i].Key = "Mutator";
   ServerState.ServerInfo[i].Value = GetHumanReadableName();

   ServerState.ServerInfo[i+1].Key = "XxxX IG Version";
   ServerState.ServerInfo[i+1].Value = "v2i";

   ServerState.ServerInfo[i+2].Key = "XxxX IG Zoom";
	if ( bEnableZoom )
   ServerState.ServerInfo[i+2].Value = "Enabled";
    else ServerState.ServerInfo[i+2].Value = "Disabled";

   ServerState.ServerInfo[i+3].Key = "XxxX IG R.O.F.";
   ServerState.ServerInfo[i+3].Value = String(ROF);

   ServerState.ServerInfo[i+4].Key = "XxxX IG Boost";
	if ( bEnableBoost )
   ServerState.ServerInfo[i+4].Value = "Enabled";
    else ServerState.ServerInfo[i+4].Value = "Disabled";

   ServerState.ServerInfo[i+5].Key = "XxxX IG MultiHit";
	if ( bEnableMultiHit )
   ServerState.ServerInfo[i+5].Value = "Enabled";
    else ServerState.ServerInfo[i+5].Value = "Disabled";

   ServerState.ServerInfo[i+6].Key = "XxxX IG +NW";
	if ( bNormalWeapons )
   ServerState.ServerInfo[i+6].Value = "Enabled";
    else ServerState.ServerInfo[i+6].Value = "Disabled";

   ServerState.ServerInfo[i+7].Key = "Server Location";
   ServerState.ServerInfo[i+7].Value = ServerLocation;
 }
}

function ServerTraveling (string URL, bool bItems)
{
  local string Beamz0r;
  local string Rofz0r;
  local string Zoomz0r;
  local string Hitz0r;
  local string Boostz0r;
  local string NWz0r;
  local string Startz0r;
  local string Skullz0r;
  local string Showz0r;
  local string Adrenz0r;

  local array<string> Parts;
  local int i;

  Split(URL,"?",Parts);
  for (i=0;i<Parts.Length;i++)
   {
    if ( Parts[i] != "" )
    {
      if ( Left(Parts[i],Len("XxxXBeamEffect")) ~= "XxxXBeamEffect" )
      {
        Beamz0r = Right(Parts[i],Len(Parts[i]) - Len("XxxXBeamEffect") - 1);
      }
      if ( Left(Parts[i],Len("ROF")) ~= "ROF" )
      {
        Rofz0r = Right(Parts[i],Len(Parts[i]) - Len("ROF") - 1);
      }
      if ( Left(Parts[i],Len("bEnableZoom")) ~= "bEnableZoom" )
      {
        Zoomz0r = Right(Parts[i],Len(Parts[i]) - Len("bEnableZoom") - 1);
      }
      if ( Left(Parts[i],Len("bEnableMultiHit")) ~= "bEnableMultiHit" )
      {
        Hitz0r = Right(Parts[i],Len(Parts[i]) - Len("bEnableMultiHit") - 1);
      }
      if ( Left(Parts[i],Len("bEnableBoost")) ~= "bEnableBoost" )
      {
        Boostz0r = Right(Parts[i],Len(Parts[i]) - Len("bEnableBoost") - 1);
      }
      if ( Left(Parts[i],Len("bNormalWeapons")) ~= "bNormalWeapons" )
      {
        NWz0r = Right(Parts[i],Len(Parts[i]) - Len("bNormalWeapons") - 1);
      }
      if ( Left(Parts[i],Len("bESRStart")) ~= "bESRStart" )
      {
        Startz0r = Right(Parts[i],Len(Parts[i]) - Len("bESRStart") - 1);
      }
      if ( Left(Parts[i],Len("bInstaGibSkull")) ~= "bInstaGibSkull" )
      {
        Skullz0r = Right(Parts[i],Len(Parts[i]) - Len("bInstaGibSkull") - 1);
      }
      if ( Left(Parts[i],Len("bShowServerInfo")) ~= "bShowServerInfo" )
      {
        Showz0r = Right(Parts[i],Len(Parts[i]) - Len("bShowServerInfo") - 1);
      }
      if ( Left(Parts[i],Len("bInvisiBerserk")) ~= "bInvisiBerserk" )
      {
        Adrenz0r = Right(Parts[i],Len(Parts[i]) - Len("bInvisiBerserk") - 1);
      }
    }
   }

  if ( (Beamz0r != "") && (int(Beamz0r) < 7) && (int(Beamz0r) >= 0) )
    Default.XxxXBeamEffect = int(Beamz0r);

  if ( (Rofz0r != "") && (float(Rofz0r) <= 2) && (float(Rofz0r) >= 0.2) )
    Default.ROF = float(Rofz0r);

  if ( (Zoomz0r != "") && ((Zoomz0r ~= "True") || (Zoomz0r ~= "False")) )
    Default.bEnableZoom = Zoomz0r ~= "True";

  if ( (Hitz0r != "") && ((Hitz0r ~= "True") || (Hitz0r ~= "False")) )
    Default.bEnableMultiHit = Hitz0r ~= "True";

  if ( (Boostz0r != "") && ((Boostz0r ~= "True") || (Boostz0r ~= "False")) )
    Default.bEnableBoost = Boostz0r ~= "True";

  if ( (NWz0r != "") && ((NWz0r ~= "True") || (NWz0r ~= "False")) )
    Default.bNormalWeapons = NWz0r ~= "True";

  if ( (Startz0r != "") && ((Startz0r ~= "True") || (Startz0r ~= "False")) )
    Default.bESRStart = Startz0r ~= "True";

  if ( (Skullz0r != "") && ((Skullz0r ~= "True") || (Skullz0r ~= "False")) )
    Default.bInstaGibSkull = Skullz0r ~= "True";

  if ( (Showz0r != "") && ((Showz0r ~= "True") || (Showz0r ~= "False")) )
    Default.bShowServerInfo = Showz0r ~= "True";

  if ( (Adrenz0r != "") && ((Adrenz0r ~= "True") || (Adrenz0r ~= "False")) )
    Default.bInvisiBerserk = Adrenz0r ~= "True";

   StaticSaveConfig();
   Super.ServerTraveling(URL,bItems);
	if (NextMutator != None)
		NextMutator.ServerTraveling(URL,bItems);
}

defaultproperties
{
     bEnableZoom=True
     bEnableMultiHit=True
     ROF=0.900000
     bInstaGibSkull=True
     bShowServerInfo=True
     ServerLocation="Default Value"
     bInvisiBerserk=True
     ESRConfigInfoClass=Class'XxxXESRv2j.ESRConfigInfo'
     BoostDisplayText="Enable Boosting"
     BoostDescText="Enables Teammate Boost when shot."
     ROFDisplayText="Rate of fire"
     ROFDescText="Adjusts the ESR firing speed (UCL servers run 0.9)"
     ZoomDisplayText="Enable Zoom"
     ZoomDescText="Enables the ESR zoom function."
     MultiHitDisplayText="Enable Multi-Hit"
     MultiHitDescText="2 or more kills attainable per shot"
     BeamColorDisplayText="BeamColor"
     BeamColorDescText="Choose a default beam color for non-team games."
     bInvisiBerserkDisplayText="Invisi-Berserk Combo"
     bInvisiBerserkDescText="Enable Invisi-Berserk Combo -- Press Back, Back, Back, Back to go InvisiBerserk"
     bNormalWeaponsDisplayText="Normal Weapons"
     bNormalWeaponsDescText="Enable Normal Weapons -- SuperShockRifle Pickups will be replaced with the XxxXESR."
     bInstaGibSkullDisplayText="InstaGib Skull"
     bInstaGibSkullDescText="Adds the InstaGib Skull to the server info."
     bESRStartDisplayText="NW ESR Start"
     bESRStartDescText="Only check if in Normal Weapons mode!! -- Players will start with the XxxXESR in their inventory."
     bShowServerInfoDisplayText="Show Server Info"
     bShowServerInfoDescText="Shows settings in the server info window."
     ServerLocationDisplayText="Server Location"
     ServerLocationDescText="Must be set manually in the XxxXESRv2j.ini -- Shows Server Location in the server info window."
     bAddToServerPackages=True
     GroupName="Arena"
     FriendlyName="XxxX InstaGib v2j"
     Description="XxxX InstaGib v2j|F7 brings up the In-Game Weapon Menu||Credits: *XxZER01xX*|www.elitekillas.com||Credits: John Walstra|spoon@spoonware.org|http://spoonware.org||Visit www.elitekillas.com for Support, Updates, Contact Info, and other fine mutators."
     bNetTemporary=True
     bAlwaysRelevant=True
     RemoteRole=ROLE_SimulatedProxy
}
