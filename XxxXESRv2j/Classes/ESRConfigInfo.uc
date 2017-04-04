class ESRConfigInfo extends Info;

var config array<String> ScopeClassName;
var config array<String> RifleSoundClassName;
var config array<String> PowerGelClassName;

var class<ESRConfigInfo> MainInfoClass;
var class<ClientInfo> ClientInfoClass;

var String MyRifleSoundClassName[11];
var String MyScopeClassName[10];
var String MyPowerGelClassName[10];

var String MyDefaultScope;
var String MyDefaultSound;
var bool   bHasBeenReplicated;

replication
{
  reliable if( bNetInitial && ( Role==ROLE_Authority ) )
    MyRifleSoundClassName,
    MyPowerGelClassName,
    MyScopeClassName,
    MyDefaultScope,
    MyDefaultSound,
    bHasBeenReplicated;
}

simulated function Load()
{
  local int index;
  if( Role==Role_Authority )
  {

    for( index =0;
         index < MainInfoClass.default.RifleSoundClassName.Length;
         index++)
    {
      MyRifleSoundClassName[index] = MainInfoClass.default.RifleSoundClassName[index];
    }

    for( index =0;
         index < MainInfoClass.default.ScopeClassName.Length;
         index++)
    {
      MyScopeClassName[index] = MainInfoClass.default.ScopeClassName[index];
    }

    for( index =0;
         index < MainInfoClass.default.PowerGelClassName.Length;
         index++)
    {
      MyPowerGelClassName[index] = MainInfoClass.default.PowerGelClassName[index];
    }

    bHasBeenReplicated = true;
  }
}

defaultproperties
{
     ScopeClassName(0)="XxxXESRv2j.ELITEScope"
     ScopeClassName(1)="XxxXESRv2j.UT2004CleanScope"
     ScopeClassName(2)="XxxXESRv2j.VSKScope"
     ScopeClassName(3)="XxxXESRv2j.UT99Scope"
     ScopeClassName(4)="XxxXESRv2j.UT2003Scope"
     ScopeClassName(5)="XxxXESRv2j.UT2004Scope"
     ScopeClassName(6)="XxxXESRv2j.NoScope"
     RifleSoundClassName(0)="XxxXESRv2j.UT99IGSound"
     RifleSoundClassName(1)="XxxXESRv2j.UT2003IGSound"
     RifleSoundClassName(2)="XxxXESRv2j.UT2004IGSound"
     RifleSoundClassName(3)="XxxXESRv2j.PhazerASound"
     RifleSoundClassName(4)="XxxXESRv2j.PhazerBSound"
     RifleSoundClassName(5)="XxxXESRv2j.PhazerCSound"
     RifleSoundClassName(6)="XxxXESRv2j.PhazerDSound"
     RifleSoundClassName(7)="XxxXESRv2j.TBLaserSound"
     RifleSoundClassName(8)="XxxXESRv2j.UnrealRifleSound"
     RifleSoundClassName(9)="XxxXESRv2j.UT99RifleSound"
     RifleSoundClassName(10)="XxxXESRv2j.UT2004RifleSound"
     PowerGelClassName(0)="XxxXESRv2j.XxxXGreenPowerGel"
     PowerGelClassName(1)="XxxXESRv2j.XxxXRedPowerGel"
     PowerGelClassName(2)="XxxXESRv2j.XxxXBluePowerGel"
     PowerGelClassName(3)="XxxXESRv2j.XxxXPurplePowerGel"
     PowerGelClassName(4)="XxxXESRv2j.XxxXGoldPowerGel"
     bAlwaysRelevant=True
     RemoteRole=ROLE_DumbProxy
}
