class GUIClientScopeConfig extends MidGamePanel;

var automated GUIImage             i_ScopeShot;
var automated GUIListBox           lb_ScopeList;
var automated AltSectionBackground sb_Scopes;
var automated GUIComboBox          cb_RifleSound;
var automated GUILabel             l_SoundLabel;
var automated GUIButton            b_Config;
var automated moCheckBox           c_ZoomSound;
var automated moCheckBox           c_OldModel;
var automated moCheckBox           c_Spiral;
var automated moCheckBox           c_Sparks;
var automated moCheckBox           c_HitSmoke;
var automated GUIComboBox          cb_PowerGel;
var automated GUILabel             l_PowerGelLabel;
var automated GUILabel             l_WarningLabel;

var ESRConfigInfo ESRConfigInfo;
var XxxXESR  SR;

var String ScopeClassName;
var String RifleSound;
var bool   bZoomSound;
var bool   bUseOldWeaponMesh;
var bool   bDisableSpiral;
var bool   bEnableSparks;
var bool   bEnableHitSmoke;
var String PowerGel;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
  local int                 index, selected_index;
  local String              TempScopeClassName;
  local class<XxxXScope>      ScopeClass;
  local String              SoundClassName;
  local class<XxxXSound> SoundClass;

  local String              PowerGelClassName;
  local class<XxxXPowerGel> PowerGelClass;


  Super.InitComponent(MyController, MyOwner);

  ScopeClassName = class'XxxXESRv2j.ClientInfo'.default.ScopeClassName;
  RifleSound     = class'XxxXESRv2j.ClientInfo'.default.RifleSound;
  bZoomSound     = class'XxxXESRv2j.ClientInfo'.default.bZoomSound;
  bUseOldWeaponMesh      = class'XxxXESRv2j.ClientInfo'.default.bUseOldWeaponMesh;
  bDisableSpiral      = class'XxxXESRv2j.ClientInfo'.default.bDisableSpiral;
  bEnableSparks      = class'XxxXESRv2j.ClientInfo'.default.bEnableSparks;
  bEnableHitSmoke      = class'XxxXESRv2j.ClientInfo'.default.bEnableHitSmoke;
  PowerGel		= class'XxxXESRv2j.ClientInfo'.default.PowerGel;

  foreach PlayerOwner().ChildActors( class'XxxXESRv2j.XxxXESR', 
                                     SR ) break;
  if( SR != None )
  {
    ScopeClassName = SR.CurrentScopeClassName;
    RifleSound     = SR.CurrentSound;
    bZoomSound     = SR.bZoomSound;
    bUseOldWeaponMesh     = SR.bUseOldWeaponMesh;
    bDisableSpiral = bDisableSpiral;
    bEnableSparks = bEnableSparks;
    bEnableHitSmoke = bEnableHitSmoke;
    PowerGel = SR.CurrentPowerGel;
  }

  c_ZoomSound.Checked( bZoomSound );
  c_OldModel.Checked( bUseOldWeaponMesh );
  c_Spiral.Checked( bDisableSpiral );
  c_Sparks.Checked( bEnableSparks );
  c_HitSmoke.Checked( bEnableHitSmoke );

  selected_index = 0;
  b_Config.MenuStateChange( MSAT_Disabled );
  b_Config.bNeverFocus=True;
  for( index =0;
       (index < 10 ) && ( ESRConfigInfo.MyScopeClassName[ index ] != "" ); 
       index++)
  {
    TempScopeClassName = ESRConfigInfo.MyScopeClassName[ index ];

    ScopeClass= class<XxxXScope>( DynamicLoadObject( TempScopeClassName, class'Class' ) );
    lb_ScopeList.List.Add( ScopeClass.default.ScopeName );
    if( ScopeClassName == TempScopeClassName )
    {
      i_ScopeShot.Image = ScopeClass.default.ScopeShot;
      if( ScopeClass.default.ConfigClassName != "" )
      {
        b_Config.MenuStateChange( MSAT_Focused );
        b_Config.bNeverFocus=False;
      }
      selected_index = index;
    }
  }
  lb_ScopeList.List.Index = selected_index;

  selected_index = 0;
  for( index =0;
       (index < 10 ) && ( ESRConfigInfo.MyRifleSoundClassName[ index ] != "" );
       index++)
  {
    SoundClassName = ESRConfigInfo.MyRifleSoundClassName[ index ];
    SoundClass= class<XxxXSound>( DynamicLoadObject( SoundClassName, class'Class' ) );

    cb_RifleSound.AddItem( SoundClass.default.SoundName );
    if( SoundClassName == RifleSound )
    {
      selected_index = index;
    }
  }
  cb_RifleSound.SetIndex( selected_index );


 selected_index = 0;
  for( index =0;
       (index < 10 ) && ( ESRConfigInfo.MyPowerGelClassName[ index ] != "" );
       index++)
  {
    PowerGelClassName = ESRConfigInfo.MyPowerGelClassName[ index ];
    PowerGelClass= class<XxxXPowerGel>( DynamicLoadObject( PowerGelClassName, class'Class' ) );

    cb_PowerGel.AddItem( PowerGelClass.default.PowerGelName );
    if( PowerGelClassName == PowerGel )
    {
      selected_index = index;
    }
  }
  cb_PowerGel.SetIndex( selected_index );

  }

function bool ChangeScope( GUIComponent Sender )
{
  local int index;
  local String         TempScopeClassName;
  local class<XxxXScope> ScopeClass;

  index = lb_ScopeList.List.Index;

  TempScopeClassName = ESRConfigInfo.MyScopeClassName[ index ];
  ScopeClass= class<XxxXScope>( DynamicLoadObject( TempScopeClassName, class'Class' ) );
  i_ScopeShot.Image = ScopeClass.default.ScopeShot;

  
  if( ScopeClass.default.ConfigClassName != "" )
  {
    b_Config.MenuStateChange( MSAT_Focused );
    b_Config.bNeverFocus=False;
  }
  else
  {
    b_Config.MenuStateChange( MSAT_Disabled );
    b_Config.bNeverFocus=True;
  }

  ScopeClassName = TempScopeClassName;

  return true;
}

function bool OpenConfigMenu(GUIComponent Sender)
{
  local int index;
  local String         TempScopeClassName;
  local String         ConfigClassName;
  local class<XxxXScope> ScopeClass;

  index = lb_ScopeList.List.Index;
  TempScopeClassName = ESRConfigInfo.MyScopeClassName[ index ];
  ScopeClass= class<XxxXScope>( DynamicLoadObject( TempScopeClassName, class'Class' ) );

  ConfigClassName = ScopeClass.default.ConfigClassName;

  // just in case
  if( ScopeClass.default.ConfigClassName == "" ) return false;

  Controller.OpenMenu( ConfigClassName );

  return true;
}

event Closed(GUIComponent Sender, bool bCancelled)
{
  local int index;
  local String SoundClassName;
  local String PowerGelClassName;

    index = cb_RifleSound.GetIndex();
  SoundClassName = ESRConfigInfo.MyRifleSoundClassName[ index ];

    index = cb_PowerGel.GetIndex();
  PowerGelClassName = ESRConfigInfo.MyPowerGelClassName[ index ];

  if( SR != None )
  {
    SR.SetRifleSound( SoundClassName );
    SR.bZoomSound = c_ZoomSound.IsChecked();
    SR.bUseOldWeaponMesh = c_OldModel.IsChecked();
  }

  class'ClientInfo'.default.ScopeClassName = ScopeClassName;
  class'ClientInfo'.default.bZoomSound = c_ZoomSound.IsChecked();
  class'ClientInfo'.default.bUseOldWeaponMesh = c_OldModel.IsChecked();
  class'ClientInfo'.default.bDisableSpiral = c_Spiral.IsChecked();
  class'ClientInfo'.default.bEnableSparks = c_Sparks.IsChecked();
  class'ClientInfo'.default.bEnableHitSmoke = c_HitSmoke.IsChecked();
  class'ClientInfo'.default.RifleSound = SoundClassName;
  class'ClientInfo'.default.PowerGel = PowerGelClassName;

  class'ClientInfo'.static.StaticSaveConfig();

  Super.Closed(Sender, bCancelled);
}

defaultproperties
{
     Begin Object Class=GUIImage Name=ScopeShot
         Image=Texture'XxxXESRv2j.textures.NoneScope_P'
         ImageStyle=ISTY_Scaled
         WinTop=0.050000
         WinLeft=0.550000
         WinWidth=0.400000
         WinHeight=0.500000
         bNeverFocus=True
     End Object
     i_ScopeShot=GUIImage'XxxXESRv2j.GUIClientScopeConfig.ScopeShot'

     Begin Object Class=GUIListBox Name=ScopeList
         OnCreateComponent=ScopeList.InternalOnCreateComponent
         WinTop=0.150000
         WinLeft=0.100000
         WinWidth=0.350000
         WinHeight=0.250000
         OnClick=GUIClientScopeConfig.ChangeScope
     End Object
     lb_ScopeList=GUIListBox'XxxXESRv2j.GUIClientScopeConfig.ScopeList'

     Begin Object Class=AltSectionBackground Name=sbAvailScopes
         Caption="Available Scopes"
         WinTop=0.050000
         WinLeft=0.050000
         WinWidth=0.450000
         WinHeight=0.500000
         OnPreDraw=sbAvailScopes.InternalPreDraw
     End Object
     sb_Scopes=AltSectionBackground'XxxXESRv2j.GUIClientScopeConfig.sbAvailScopes'

     Begin Object Class=GUIComboBox Name=RifleSoundCB
         bReadOnly=True
         WinTop=0.880000
         WinLeft=0.780000
         WinWidth=0.200000
         WinHeight=0.050000
         OnKeyEvent=RifleSoundCB.InternalOnKeyEvent
     End Object
     cb_RifleSound=GUIComboBox'XxxXESRv2j.GUIClientScopeConfig.RifleSoundCB'

     Begin Object Class=GUILabel Name=SoundLabel
         Caption="Fire Sound"
         TextColor=(B=255,G=255,R=255)
         WinTop=0.880000
         WinLeft=0.550000
         WinWidth=0.400000
         WinHeight=0.050000
     End Object
     l_SoundLabel=GUILabel'XxxXESRv2j.GUIClientScopeConfig.SoundLabel'

     Begin Object Class=GUIButton Name=ConfigButton
         Caption="Configure Scope"
         bAutoShrink=False
         WinTop=0.600000
         WinLeft=0.550000
         WinWidth=0.400000
         WinHeight=0.100000
         OnClick=GUIClientScopeConfig.OpenConfigMenu
         OnKeyEvent=ConfigButton.InternalOnKeyEvent
     End Object
     b_Config=GUIButton'XxxXESRv2j.GUIClientScopeConfig.ConfigButton'

     Begin Object Class=moCheckBox Name=ZoomSounds
         CaptionWidth=0.900000
         Caption="Zoom Sounds"
         OnCreateComponent=ZoomSounds.InternalOnCreateComponent
         Hint="Play sounds when zooming in and out"
         WinTop=0.710000
         WinLeft=0.550000
         WinWidth=0.400000
         WinHeight=0.050000
     End Object
     c_ZoomSound=moCheckBox'XxxXESRv2j.GUIClientScopeConfig.ZoomSounds'

     Begin Object Class=moCheckBox Name=OldModel
         CaptionWidth=0.900000
         Caption="Classic Weapon"
         OnCreateComponent=ZoomSounds.InternalOnCreateComponent
         Hint="Use the Shock Rifle From UT2k3 (Requires respawn)"
         WinTop=0.780000
         WinLeft=0.550000
         WinWidth=0.400000
         WinHeight=0.050000
     End Object
     c_OldModel=moCheckBox'XxxXESRv2j.GUIClientScopeConfig.OldModel'

     Begin Object Class=moCheckBox Name=Spiral
         CaptionWidth=0.900000
         Caption="Disable Beam Spiral"
         OnCreateComponent=ZoomSounds.InternalOnCreateComponent
         Hint="Removes the coil from the beam"
         WinTop=0.570000
         WinLeft=0.050000
         WinWidth=0.450000
         WinHeight=0.050000
     End Object
     c_Spiral=moCheckBox'XxxXESRv2j.GUIClientScopeConfig.Spiral'

     Begin Object Class=moCheckBox Name=Sparks
         CaptionWidth=0.900000
         Caption="Enable Hit Sparks"
         OnCreateComponent=ZoomSounds.InternalOnCreateComponent
         Hint="Toggle the Spark effects on and off."
         WinTop=0.640000
         WinLeft=0.050000
         WinWidth=0.450000
         WinHeight=0.050000
     End Object
     c_Sparks=moCheckBox'XxxXESRv2j.GUIClientScopeConfig.Sparks'

     Begin Object Class=moCheckBox Name=HitSmoke
         CaptionWidth=0.900000
         Caption="Enable Hit Smoke"
         OnCreateComponent=ZoomSounds.InternalOnCreateComponent
         Hint="Turns the SmokeRing hit effect on and off."
         WinTop=0.710000
         WinLeft=0.050000
         WinWidth=0.450000
         WinHeight=0.050000
     End Object
     c_HitSmoke=moCheckBox'XxxXESRv2j.GUIClientScopeConfig.HitSmoke'

     Begin Object Class=GUIComboBox Name=PowerGelCB
         bReadOnly=True
         WinTop=0.880000
         WinLeft=0.300000
         WinWidth=0.200000
         WinHeight=0.050000
         OnKeyEvent=RifleSoundCB.InternalOnKeyEvent
     End Object
     cb_PowerGel=GUIComboBox'XxxXESRv2j.GUIClientScopeConfig.PowerGelCB'

     Begin Object Class=GUILabel Name=PowerGelLabel
         Caption="PowerGel"
         TextColor=(B=255,G=255,R=255)
         WinTop=0.880000
         WinLeft=0.050000
         WinWidth=0.400000
         WinHeight=0.050000
     End Object
     l_PowerGelLabel=GUILabel'XxxXESRv2j.GUIClientScopeConfig.PowerGelLabel'

     Begin Object Class=GUILabel Name=WarningLabel
         Caption="Warning: Only open this menu while dead to avoid game crashes."
         TextColor=(B=0,R=255)
         WinLeft=0.090000
         WinWidth=0.800000
         WinHeight=0.050000
     End Object
     l_WarningLabel=GUILabel'XxxXESRv2j.GUIClientScopeConfig.WarningLabel'

}
