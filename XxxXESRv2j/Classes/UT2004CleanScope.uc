//============================================================================
// UT2004CleanScope - The UT99/UT2004 Hybrid scope
//
// Author        : $Author: jwalstra $
// Revision      : $Revision: 1.1.1.1 $
// Checkout Date : $Date: 2004/05/11 03:35:52 $
// Source File   : $Source: /home/cvs/SA2K4/MetaClasses/UT2004CleanScope.uc,v $
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
// $Log: UT2004CleanScope.uc,v $
// Revision 1.1.1.1  2004/05/11 03:35:52  jwalstra
// First check in
//
//============================================================================

class UT2004CleanScope extends XxxXScope
  Config( XxxXESRCFG );

//CODE_BEGIN

// Quick color structure
struct QCStruct
{
  var String Name;
  var Color  Color;
};

// Remember scope color per map structure
struct RemeberStruct
{
  var String MapName;
  var Color  Color;
};

var config Color                ScopeColor;
var config bool                 bShowCrosshair;
var config array<QCStruct>      QCList;
var config array<RemeberStruct> RemeberList;

var bool   bCrossHairShow;

var String MapName;

// this is used to get the scope color for different maps
simulated function Color GetScopeColor()
{
  local int index;
  local Color RetColor;

  RetColor = ScopeColor;
  for( index = 0; index < RemeberList.Length; index++ )
  {
    if( RemeberList[index].MapName == MapName )
    {
      RetColor = RemeberList[index].Color;
      break;
    }
  }
  return RetColor;
}

simulated function PostBeginPlay()
{
  Super.PostBeginPlay();

  bCrossHairShow = PlayerController(Instigator.Controller).MyHUD.bCrosshairShow;
  MapName        = Level.Title;
  ScopeColor     = GetScopeColor();
}

simulated function RenderNormal( Canvas Canvas )
{
  if( Instigator == None ) return;

  if( PlayerController(Instigator.Controller).DesiredFOV ==
        PlayerController(Instigator.Controller).DefaultFOV )
  {
    PlayerController(Instigator.Controller).MyHUD.bCrosshairShow = true;
  }
  Super.RenderNormal( Canvas );
}

simulated function RenderZoom( Canvas Canvas )
{
  local float CX,CY,Scale;

  if( Instigator == None ) return;

  // if the user wants to disable the crosshair when zooming, do so
  if( !bShowCrosshair )
  {
    PlayerController(Instigator.Controller).MyHUD.bCrosshairShow = false;
  }

  CX = Canvas.ClipX/2;
  CY = Canvas.ClipY/2;
  Scale = Canvas.ClipX/1024;

  Canvas.Style = ERenderStyle.STY_Alpha;
  Canvas.DrawColor = ScopeColor;

  // Draw the crosshair
  Canvas.SetPos(CX-169*Scale,CY-155*Scale);
  Canvas.DrawTile(texture'XxxXESRv2j.UT2004Scope',169*Scale,310*Scale, 163,35, 169,310);
  Canvas.SetPos(CX,CY-155*Scale);
  Canvas.DrawTile(texture'XxxXESRv2j.UT2004Scope',169*Scale,310*Scale, 333,345, -170,-310);

  // UT99 style zoom display
  Canvas.SetPos( 0.5 * Canvas.ClipX + 128 * Scale,
                 0.5 * Canvas.ClipY + 128 * Scale);
  Scale = ( PlayerController(Instigator.Controller).DefaultFOV /
            PlayerController(Instigator.Controller).DesiredFOV ) + 0.05;
  Canvas.Font = Canvas.SmallFont;
  Canvas.DrawText("X"$int(Scale)$"."$int(10 * Scale - 10 * int(Scale)));

  Super.RenderZoom( Canvas );
}

simulated function bool PutDown()
{
  if( ( Instigator != None ) &&
      ( PlayerController(Instigator.Controller) != None ) &&
      ( PlayerController(Instigator.Controller).MyHUD != None ) )
  {
    PlayerController(Instigator.Controller).MyHUD.bCrosshairShow = true;
  }
  return true;
}

simulated function Destroyed()
{
  PlayerController(Instigator.Controller).MyHUD.bCrosshairShow = true;
}


simulated function Save()
{
  SaveConfig();
}


//CODE_END


// auto-generated on Mon May 10 22:38:07 CDT 2004

defaultproperties
{
     ScopeColor=(G=255,R=255,A=255)
     QCList(0)=(Name="Green",Color=(G=255,A=255))
     QCList(1)=(Name="Black",Color=(A=255))
     QCList(2)=(Name="White",Color=(B=255,G=255,R=255,A=255))
     QCList(3)=(Name="Red",Color=(R=255,A=255))
     QCList(4)=(Name="Blue",Color=(B=255,A=255))
     QCList(5)=(Name="Yellow",Color=(G=255,R=255,A=255))
     QCList(6)=(Name="Purple",Color=(B=255,R=255,A=255))
     QCList(7)=(Name="Cyan",Color=(B=255,G=255,A=255))
     QCList(8)=(Name="Pink",Color=(B=128,G=128,R=255,A=255))
     ScopeName="UT99/UT2004 Hybrid"
     ScopeAuthor="Epic/spoon - Unreal Tournament 2004"
     WebImage="scope_ut99_2004.jpg"
     ScopeShot=Texture'XxxXESRv2j.textures.UT99_2004Scope_P'
     ConfigClassName="XxxXESRv2j.UT2004CleanScopeControl"
}
