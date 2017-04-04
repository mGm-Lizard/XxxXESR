//============================================================================
// UT2004Scope - The UT2004 Sniper Scope
//
// Author        : $Author: jwalstra $
// Revision      : $Revision: 1.1.1.1 $
// Checkout Date : $Date: 2004/05/11 03:35:52 $
// Source File   : $Source: /home/cvs/SA2K4/MetaClasses/UT2004Scope.uc,v $
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
// $Log: UT2004Scope.uc,v $
// Revision 1.1.1.1  2004/05/11 03:35:52  jwalstra
// First check in
//
//============================================================================

class UT2004Scope extends XxxXScope;

var color ChargeColor;

simulated function RenderZoom( Canvas Canvas )
{
  local float CX,CY,Scale;
  local float chargeBar;
  local float barOrgX, barOrgY;
  local float barSizeX, barSizeY;

  if( Instigator == None ) return;

  if ( XxxXESR( Owner ).NextFireTime <= Level.TimeSeconds )
  {
    chargeBar = 1.0;
  }
  else
  {
    chargeBar = 1.0 - ( ( XxxXESR( Owner ).NextFireTime - Level.TimeSeconds) /
                          XxxXESR( Owner ).FireRate);
  }

  CX = Canvas.ClipX/2;
  CY = Canvas.ClipY/2;
  Scale = Canvas.ClipX/1024;

  Canvas.Style = ERenderStyle.STY_Alpha;
  Canvas.SetDrawColor(0,0,0);

  // Draw the crosshair
  Canvas.SetPos(CX-169*Scale,CY-155*Scale);
  Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair',169*Scale,310*Scale, 164,35, 169,310);
  Canvas.SetPos(CX,CY-155*Scale);
  Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair',169*Scale,310*Scale, 332,345, -169,-310);

  // Draw Cornerbars
  Canvas.SetPos(160*Scale,160*Scale);
  Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair', 111*Scale, 111*Scale , 0 , 0, 111, 111);

  Canvas.SetPos(Canvas.ClipX-271*Scale,160*Scale);
  Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair', 111*Scale, 111*Scale , 111 , 0, -111, 111);

  Canvas.SetPos(160*Scale,Canvas.ClipY-271*Scale);
  Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair', 111*Scale, 111*Scale, 0 , 111, 111, -111);

  Canvas.SetPos(Canvas.ClipX-271*Scale,Canvas.ClipY-271*Scale);
  Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair', 111*Scale, 111*Scale , 111 , 111, -111, -111);

  // Draw the 4 corners
  Canvas.SetPos(0,0);
  Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair',160*Scale,160*Scale, 0, 274, 159, -158);

  Canvas.SetPos(Canvas.ClipX-160*Scale,0);
  Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair',160*Scale,160*Scale, 159,274, -159, -158);

  Canvas.SetPos(0,Canvas.ClipY-160*Scale);
  Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair',160*Scale,160*Scale, 0,116, 159, 158);

  Canvas.SetPos(Canvas.ClipX-160*Scale,Canvas.ClipY-160*Scale);
  Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair',160*Scale,160*Scale, 159, 116, -159, 158);

  // Draw the Horz Borders
  Canvas.SetPos(160*Scale,0);
  Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair', Canvas.ClipX-320*Scale, 160*Scale, 284, 512, 32, -160);

  Canvas.SetPos(160*Scale,Canvas.ClipY-160*Scale);
  Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair', Canvas.ClipX-320*Scale, 160*Scale, 284, 352, 32, 160);

  // Draw the Vert Borders
  Canvas.SetPos(0,160*Scale);
  Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair', 160*Scale, Canvas.ClipY-320*Scale, 0,308, 160,32);

  Canvas.SetPos(Canvas.ClipX-160*Scale,160*Scale);
  Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair', 160*Scale, Canvas.ClipY-320*Scale, 160,308, -160,32);

  // Draw the Charging meter
  Canvas.DrawColor = ChargeColor;
  Canvas.DrawColor.A = 255;

  if(chargeBar <1)
  {
    Canvas.DrawColor.R = 255*chargeBar;
  }
  else
  {
    Canvas.DrawColor.R = 0;
    Canvas.DrawColor.B = 0;
  }

  if(chargeBar == 1)
  {
    Canvas.DrawColor.G = 255;
  }
  else
  {
    Canvas.DrawColor.G = 0;
  }

  Canvas.Style = ERenderStyle.STY_Alpha;
  Canvas.SetPos( barOrgX, barOrgY );
  Canvas.DrawTile(Texture'Engine.WhiteTexture',barSizeX,barSizeY*chargeBar, 0.0, 0.0,Texture'Engine.WhiteTexture'.USize,Texture'Engine.WhiteTexture'.VSize*chargeBar);
}



// auto-generated on Mon May 10 22:38:07 CDT 2004

defaultproperties
{
     ChargeColor=(B=255,G=255,R=255,A=255)
     ScopeName="UT2004 Scope"
     ScopeAuthor="Epic - Unreal Tournament 2004"
     WebImage="scope_ut2004.jpg"
     ScopeShot=Texture'XxxXESRv2j.textures.UT2004Scope_P'
}
