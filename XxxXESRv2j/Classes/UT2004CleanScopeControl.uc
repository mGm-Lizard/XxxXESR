//============================================================================
// GUIClientMain
//
// Base class for the main client GUI page
//
// Author        : $Author: jwalstra $
// Revision      : $Revision: 1.1.1.1 $
// Checkout Date : $Date: 2004/05/11 03:35:52 $
// Source File   : $Source: /home/cvs/SA2K4/MetaClasses/UT2004CleanScopeControl.uc,v $
//============================================================================
//
// Copyright (C) 2003 John Walstra
// spoon@spoonware.org
// http://spoonware.org
//
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 2.1 of the License, or (at your option) any later version.
//
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
//
// See LICENSE.uc

//
//============================================================================
// $Log: UT2004CleanScopeControl.uc,v $
// Revision 1.1.1.1  2004/05/11 03:35:52  jwalstra
// First check in
//
//===========================================================================

//CODE_START

class UT2004CleanScopeControl extends FloatingWindow;

var automated GUILabel    l_QC, l_Red, l_Green, l_Blue, l_Alpha;
var automated GUISlider   sl_Red, sl_Green, sl_Blue, sl_Alpha;
var automated GUIComboBox cb_QuickColor;
var automated moCheckBox  cb_ShowCH;
var automated GUIImage    i_PreviewOne, i_PreviewTwo;

var UT2004CleanScope SC;
var Color NewScopeColor;
var bool  bReady;
var bool  bSpawned;

function InitComponent( GUIController MyController, GUIComponent MyOwner )
{
  local int index;
  local UT2004CleanScope TempSC;

  Super.InitComponent(MyController, MyOwner);

  foreach PlayerOwner().DynamicActors( class'UT2004CleanScope', TempSC )
  {
    SC = TempSC;
    break;
  }

  if( SC == None )
  {
    SC = PlayerOwner().Spawn( class'UT2004CleanScope', PlayerOwner() );
    bSpawned = true;
  }


  i_FrameBG.Image=Texture'XxxXESRv2j.MenuBG1';
  i_FrameBG.ImageRenderStyle=MSTY_Alpha;

  T_WindowTitle.Caption = "UT99/2004 Hybrid Scope Control";

  NewScopeColor = SC.ScopeColor;

  cb_ShowCH.Checked( SC.bShowCrosshair );
  cb_QuickColor.AddItem( "Choose ..." );
  for( index = 0; index < SC.QCList.Length; index++ )
  {
    cb_QuickColor.AddItem( SC.QCList[index].Name );
  }
  bReady=True;
  SetSliders( NewScopeColor );
}

function SetSliders( Color Color )
{
  local int R,G,B,A;

  i_PreviewTwo.ImageColor = Color;

  R = ( 255 / Color.R ) * 100;
  G = ( 255 / Color.G ) * 100;
  B = ( 255 / Color.B ) * 100;
  A = ( 255 / Color.A ) * 100;

  sl_Red.SetValue( R );
  sl_Green.SetValue( G );
  sl_Blue.SetValue( B );
  sl_Alpha.SetValue( A );
}

function QCChange(GUIComponent Sender)
{
  local int index;

  if( !bReady ) return;

  index = cb_QuickColor.GetIndex() - 1;
  if( index < 0 ) return;
  SetSliders( SC.QCList[index].Color );

  AdjustColor( Sender );
}

function AdjustColor( GUIComponent Sender )
{
  NewScopeColor.R = 255 * ( sl_Red.Value / 100 );
  NewScopeColor.G = 255 * ( sl_Green.Value / 100 );
  NewScopeColor.B = 255 * ( sl_Blue.Value / 100 );
  NewScopeColor.A = 255 * ( sl_Alpha.Value / 100 );

  i_PreviewTwo.ImageColor = NewScopeColor;
}

event Closed(GUIComponent Sender, bool bCancelled)
{
  SC.ScopeColor     = NewScopeColor;
  SC.bShowCrosshair = cb_ShowCH.IsChecked();
  SC.Save();

  if( bSpawned )
  {
    SC.Destroy();
  }

  Super.Closed(Sender, bCancelled);
}


//CODE_END


// auto-generated on Mon May 10 22:38:07 CDT 2004

defaultproperties
{
     Begin Object Class=GUILabel Name=QCLabel
         Caption="Quick Color"
         TextColor=(B=255,G=255,R=255)
         WinTop=0.100000
         WinLeft=0.050000
         WinWidth=0.400000
         WinHeight=0.050000
     End Object
     l_QC=GUILabel'XxxXESRv2j.UT2004CleanScopeControl.QCLabel'

     Begin Object Class=GUILabel Name=RedLabel
         Caption="Red %"
         TextColor=(B=255,G=255,R=255)
         WinTop=0.180000
         WinLeft=0.050000
         WinWidth=0.250000
         WinHeight=0.050000
     End Object
     l_Red=GUILabel'XxxXESRv2j.UT2004CleanScopeControl.RedLabel'

     Begin Object Class=GUILabel Name=GreenLabel
         Caption="Green %"
         TextColor=(B=255,G=255,R=255)
         WinTop=0.260000
         WinLeft=0.050000
         WinWidth=0.250000
         WinHeight=0.050000
     End Object
     l_Green=GUILabel'XxxXESRv2j.UT2004CleanScopeControl.GreenLabel'

     Begin Object Class=GUILabel Name=BlueLabel
         Caption="Blue  %"
         TextColor=(B=255,G=255,R=255)
         WinTop=0.340000
         WinLeft=0.050000
         WinWidth=0.250000
         WinHeight=0.050000
     End Object
     l_Blue=GUILabel'XxxXESRv2j.UT2004CleanScopeControl.BlueLabel'

     Begin Object Class=GUILabel Name=AlphaLabel
         Caption="Alpha %"
         TextColor=(B=255,G=255,R=255)
         WinTop=0.420000
         WinLeft=0.050000
         WinWidth=0.250000
         WinHeight=0.050000
     End Object
     l_Alpha=GUILabel'XxxXESRv2j.UT2004CleanScopeControl.AlphaLabel'

     Begin Object Class=GUISlider Name=RedSlider
         bIntSlider=True
         Hint="Amount of red in the scope"
         WinTop=0.180000
         WinLeft=0.300000
         WinWidth=0.300000
         WinHeight=0.050000
         OnClick=RedSlider.InternalOnClick
         OnMousePressed=RedSlider.InternalOnMousePressed
         OnMouseRelease=RedSlider.InternalOnMouseRelease
         OnChange=UT2004CleanScopeControl.AdjustColor
         OnKeyEvent=RedSlider.InternalOnKeyEvent
         OnCapturedMouseMove=RedSlider.InternalCapturedMouseMove
     End Object
     sl_Red=GUISlider'XxxXESRv2j.UT2004CleanScopeControl.RedSlider'

     Begin Object Class=GUISlider Name=GreenSlider
         bIntSlider=True
         Hint="Amount of green in the scope"
         WinTop=0.260000
         WinLeft=0.300000
         WinWidth=0.300000
         WinHeight=0.050000
         OnClick=GreenSlider.InternalOnClick
         OnMousePressed=GreenSlider.InternalOnMousePressed
         OnMouseRelease=GreenSlider.InternalOnMouseRelease
         OnChange=UT2004CleanScopeControl.AdjustColor
         OnKeyEvent=GreenSlider.InternalOnKeyEvent
         OnCapturedMouseMove=GreenSlider.InternalCapturedMouseMove
     End Object
     sl_Green=GUISlider'XxxXESRv2j.UT2004CleanScopeControl.GreenSlider'

     Begin Object Class=GUISlider Name=BlueSlider
         bIntSlider=True
         Hint="Amount of blue in the scope"
         WinTop=0.340000
         WinLeft=0.300000
         WinWidth=0.300000
         WinHeight=0.050000
         OnClick=BlueSlider.InternalOnClick
         OnMousePressed=BlueSlider.InternalOnMousePressed
         OnMouseRelease=BlueSlider.InternalOnMouseRelease
         OnChange=UT2004CleanScopeControl.AdjustColor
         OnKeyEvent=BlueSlider.InternalOnKeyEvent
         OnCapturedMouseMove=BlueSlider.InternalCapturedMouseMove
     End Object
     sl_Blue=GUISlider'XxxXESRv2j.UT2004CleanScopeControl.BlueSlider'

     Begin Object Class=GUISlider Name=AlphaSlider
         bIntSlider=True
         Hint="Amount of green in the scope"
         WinTop=0.420000
         WinLeft=0.300000
         WinWidth=0.300000
         WinHeight=0.050000
         OnClick=AlphaSlider.InternalOnClick
         OnMousePressed=AlphaSlider.InternalOnMousePressed
         OnMouseRelease=AlphaSlider.InternalOnMouseRelease
         OnChange=UT2004CleanScopeControl.AdjustColor
         OnKeyEvent=AlphaSlider.InternalOnKeyEvent
         OnCapturedMouseMove=AlphaSlider.InternalCapturedMouseMove
     End Object
     sl_Alpha=GUISlider'XxxXESRv2j.UT2004CleanScopeControl.AlphaSlider'

     Begin Object Class=GUIComboBox Name=QuickColor
         bReadOnly=True
         WinTop=0.100000
         WinLeft=0.500000
         WinWidth=0.400000
         WinHeight=0.050000
         OnChange=UT2004CleanScopeControl.QCChange
         OnKeyEvent=QuickColor.InternalOnKeyEvent
     End Object
     cb_QuickColor=GUIComboBox'XxxXESRv2j.UT2004CleanScopeControl.QuickColor'

     Begin Object Class=moCheckBox Name=ShowCH
         ComponentJustification=TXTA_Left
         CaptionWidth=0.900000
         Caption="Show stock crosshair"
         OnCreateComponent=ShowCH.InternalOnCreateComponent
         Hint="Disables the normal crosshair when zoomed"
         WinTop=0.700000
         WinLeft=0.050000
         WinWidth=0.900000
         WinHeight=0.050000
     End Object
     cb_ShowCH=moCheckBox'XxxXESRv2j.UT2004CleanScopeControl.ShowCH'

     Begin Object Class=GUIImage Name=PreOne
         Image=Texture'XxxXESRv2j.textures.UT2004ScopePV1'
         ImageStyle=ISTY_Scaled
         ImageRenderStyle=MSTY_Normal
         WinTop=0.180000
         WinLeft=0.650000
         WinWidth=0.300000
         WinHeight=0.500000
         RenderWeight=0.110000
         bBoundToParent=True
         bScaleToParent=True
     End Object
     i_PreviewOne=GUIImage'XxxXESRv2j.UT2004CleanScopeControl.PreOne'

     Begin Object Class=GUIImage Name=PreTwo
         Image=Texture'XxxXESRv2j.textures.UT2004ScopePV2'
         ImageStyle=ISTY_Scaled
         WinTop=0.180000
         WinLeft=0.650000
         WinWidth=0.300000
         WinHeight=0.500000
         RenderWeight=0.120000
         bBoundToParent=True
         bScaleToParent=True
     End Object
     i_PreviewTwo=GUIImage'XxxXESRv2j.UT2004CleanScopeControl.PreTwo'

     bResizeWidthAllowed=False
     bResizeHeightAllowed=False
     bMoveAllowed=False
     bCaptureInput=True
     bAllowedAsLast=True
     WinTop=0.300000
     WinLeft=0.200000
     WinWidth=0.600000
     WinHeight=0.400000
}
