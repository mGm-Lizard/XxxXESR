//============================================================================
// UT99Scope
//
// Author        : $Author: jwalstra $
// Revision      : $Revision: 1.1.1.1 $
// Checkout Date : $Date: 2004/05/11 03:35:52 $
// Source File   : $Source: /home/cvs/SA2K4/MetaClasses/UT99Scope.uc,v $
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
// $Log: UT99Scope.uc,v $
// Revision 1.1.1.1  2004/05/11 03:35:52  jwalstra
// First check in
//
//============================================================================

class UT99Scope extends XxxXScope;

var bool bCrossHairShow;

simulated function PostBeginPlay()
{
  Super.PostBeginPlay();
  bCrossHairShow = PlayerController(Instigator.Controller).MyHUD.bCrosshairShow;
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
  local float Scale;

  if( Instigator == None ) return;

  PlayerController(Instigator.Controller).MyHUD.bCrosshairShow = false;

  Scale = Canvas.ClipX/640;
  Canvas.SetPos( 0.5 * Canvas.ClipX - 128 * Scale, 
                 0.5 * Canvas.ClipY - 128 * Scale );
  Canvas.Style = ERenderStyle.STY_Translucent;
  Canvas.DrawTile( Texture'XxxXESRv2j.UT99Scope', 256 * Scale, 256 * Scale, 
                   0.0, 0.0, 
                   Texture'XxxXESRv2j.UT99Scope'.USize, Texture'XxxXESRv2j.RReticle'.VSize);
  Canvas.SetPos( 0.5 * Canvas.ClipX + 64 * Scale, 
                 0.5 * Canvas.ClipY + 96 * Scale);
  Canvas.DrawColor.R = 0;
  Canvas.DrawColor.G = 255;
  Canvas.DrawColor.B = 0;
  Scale = ( PlayerController(Instigator.Controller).DefaultFOV /
            PlayerController(Instigator.Controller).DesiredFOV ) + 0.05;

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



// auto-generated on Mon May 10 22:38:07 CDT 2004

defaultproperties
{
     ScopeName="UT99 Scope"
     ScopeAuthor="Epic - Unreal Tournament"
     WebImage="scope_ut99.jpg"
     ScopeShot=Texture'XxxXESRv2j.textures.UT99Scope_P'
}
