class GUIClientMain extends FloatingWindow;

var GUIClientScopeConfig ClientScopeConfig;
var bool ScopeTab;
var ESRConfigInfo ESRConfigInfo;
var automated GUITabControl Tabs;

function GetESRConfigInfo()
{
  local ESRConfigInfo TempConfig;

  foreach PlayerOwner().AllActors( class'ESRConfigInfo', TempConfig, '' )
  {
    ESRConfigInfo = TempConfig;
    break;
  }
}

function InitComponent( GUIController MyController, GUIComponent MyOwner )
{
  Super.InitComponent(MyController, MyOwner);
  i_FrameBG.Image=Texture'XxxXESRv2j.MenuBG1';
  i_FrameBG.ImageRenderStyle=MSTY_Alpha;

  SetTimer( 0.25, True );
}

function Timer()
{
  if( PlayerOwner() != None )
  {
    if( ESRConfigInfo == None )
    {
      GetESRConfigInfo();
    }
      ClientScopeConfig = new(None) class'XxxXESRv2j.GUIClientScopeConfig';
      ClientScopeConfig.ESRConfigInfo = ESRConfigInfo;
      Tabs.AddTab( "Settings", "", ClientScopeConfig,, ScopeTab);

      T_WindowTitle.Caption = "www.elitekillas.com";
      T_WindowTitle.DockedTabs = Tabs;

      SetTimer( 0.0, false );
    }
  }

defaultproperties
{
     ScopeTab=True
     Begin Object Class=GUITabControl Name=LoginMenuTC
         bFillSpace=True
         bDockPanels=True
         TabHeight=0.037500
         BackgroundStyleName="TabBackground"
         WinTop=0.060215
         WinLeft=0.012500
         WinWidth=0.974999
         WinHeight=0.044644
         bScaleToParent=True
         bAcceptsInput=True
         OnActivate=LoginMenuTC.InternalOnActivate
     End Object
     Tabs=GUITabControl'GUI2K4.UT2K4PlayerLoginMenu.LoginMenuTC'

     bResizeWidthAllowed=False
     bResizeHeightAllowed=False
     bMoveAllowed=False
     bCaptureInput=True
     bAllowedAsLast=True
     WinTop=0.200000
     WinLeft=0.100000
     WinWidth=0.800000
     WinHeight=0.600000
}
