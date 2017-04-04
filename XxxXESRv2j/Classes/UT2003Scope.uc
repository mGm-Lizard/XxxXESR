//============================================================================
// UT2004Scope - The UT2004 Sniper Scope
//
// Author        : $Author: jwalstra $
// Revision      : $Revision: 1.1.1.1 $
// Checkout Date : $Date: 2004/05/11 03:35:52 $
// Source File   : $Source: /home/cvs/SA2K4/MetaClasses/UT2003Scope.uc,v $
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
// $Log: UT2003Scope.uc,v $
// Revision 1.1.1.1  2004/05/11 03:35:52  jwalstra
// First check in
//
//============================================================================

class UT2003Scope extends XxxXScope;

var() float testX;
var() float testY;

var() float borderX;
var() float borderY;

var() float focusX;
var() float focusY;
var() float innerArrowsX;
var() float innerArrowsY;
var() Color ArrowColor;
var() Color TargetColor;
var() Color NoTargetColor;
var() Color FocusColor;
var() Color ChargeColor;

var() vector RechargeOrigin;
var() vector RechargeSize;

// compensate for bright fog
simulated function SetZoomBlendColor(Canvas c)
{
  local Byte    val;
  local Color   clr;
  local Color   fog;

  clr.R = 255;
  clr.G = 255;
  clr.B = 255;
  clr.A = 255;

  if( Instigator.Region.Zone.bDistanceFog )
  {
    fog = Instigator.Region.Zone.DistanceFogColor;
    val = 0;
    val = Max( val, fog.R);


    val = Max( val, fog.G);
    val = Max( val, fog.B);

    if( val > 128 )
    {
      val -= 128;
      clr.R -= val;
      clr.G -= val;
      clr.B -= val;
    }
  }
  c.DrawColor = clr;
}


simulated function RenderZoom( Canvas Canvas )
{
  local float tileScaleX;
  local float tileScaleY;
  local float bX;
  local float bY;
  local float fX;
  local float fY;
  local float ReloadCharge;

  local float tX;
  local float tY;

  local float barOrgX;
  local float barOrgY;
  local float barSizeX;
  local float barSizeY;

  if( Instigator == None ) return;

  if ( XxxXESR( Owner ).NextFireTime <= Level.TimeSeconds )
  {
    ReloadCharge = 1.0;
  }
  else
  {
    ReloadCharge = 1.0 - ( ( XxxXESR( Owner ).NextFireTime - Level.TimeSeconds) /
                             XxxXESR( Owner ).FireRate);
  }

  tileScaleX = Canvas.SizeX / 640.0f;
  tileScaleY = Canvas.SizeY / 480.0f;

  bX = borderX * tileScaleX;
  bY = borderY * tileScaleY;
  fX = focusX * tileScaleX;
  fY = focusY * tileScaleX;

  tX = testX * tileScaleX;
  tY = testY * tileScaleX;

  barOrgX = RechargeOrigin.X * tileScaleX;
  barOrgY = RechargeOrigin.Y * tileScaleY;

  barSizeX = RechargeSize.X * tileScaleX;
  barSizeY = RechargeSize.Y * tileScaleY;

  SetZoomBlendColor(Canvas);

  Canvas.Style = 255;
  Canvas.SetPos(0,0);
  Canvas.DrawTile( Material'ZoomFB', Canvas.SizeX, Canvas.SizeY, 
                   0.0, 0.0, 512, 512 ); // !! hardcoded size

  Canvas.Style = ERenderStyle.STY_Alpha;
  Canvas.SetPos(0,0);
  Canvas.DrawTile( Texture'SniperBorder', bX, bY, 0.0, 0.0, 
                   Texture'SniperBorder'.USize, 
                   Texture'SniperBorder'.VSize );

  Canvas.SetPos(Canvas.SizeX-bX,0);
  Canvas.DrawTile( Texture'SniperBorder', bX, bY, 0.0, 0.0, 
                   -Texture'SniperBorder'.USize, 
                   Texture'SniperBorder'.VSize );

  Canvas.SetPos(Canvas.SizeX-bX,Canvas.SizeY-bY);
  Canvas.DrawTile( Texture'SniperBorder', bX, bY, 0.0, 0.0, 
                   -Texture'SniperBorder'.USize, 
                   -Texture'SniperBorder'.VSize );

  Canvas.SetPos(0,Canvas.SizeY-bY);
  Canvas.DrawTile( Texture'SniperBorder', bX, bY, 0.0, 0.0, 
                   Texture'SniperBorder'.USize, 
                   -Texture'SniperBorder'.VSize );

  Canvas.DrawColor = FocusColor;
  Canvas.DrawColor.A = 255; // 255 was the original -asp. WTF??!?!?!
  Canvas.Style = ERenderStyle.STY_Alpha;

  Canvas.SetPos((Canvas.SizeX*0.5)-fX,(Canvas.SizeY*0.5)-fY);
  Canvas.DrawTile( Texture'SniperFocus', fX*2.0, fY*2.0, 0.0, 0.0,
                   Texture'SniperFocus'.USize, 
                   Texture'SniperFocus'.VSize );

  fX = innerArrowsX * tileScaleX;
  fY = innerArrowsY * tileScaleY;

  Canvas.DrawColor = ArrowColor;
  Canvas.SetPos((Canvas.SizeX*0.5)-fX,(Canvas.SizeY*0.5)-fY);
  Canvas.DrawTile( Texture'SniperArrows', fX*2.0, fY*2.0, 0.0, 0.0, 
                   Texture'SniperArrows'.USize, 
                   Texture'SniperArrows'.VSize );

  // Draw the Charging meter  -AsP
  Canvas.DrawColor = ChargeColor;
  Canvas.DrawColor.A = 255;

  if(ReloadCharge <1)
  {
    Canvas.DrawColor.R = 255*ReloadCharge;
  }
  else
  {
    Canvas.DrawColor.R = 0;
    Canvas.DrawColor.B = 0;
  }

  if(ReloadCharge == 1)
  {
    Canvas.DrawColor.G = 255;
  }
  else
  {
    Canvas.DrawColor.G = 0;
  }

  Canvas.Style = ERenderStyle.STY_Alpha;
  Canvas.SetPos( barOrgX, barOrgY );
  Canvas.DrawTile(Texture'Engine.WhiteTexture',barSizeX,barSizeY*ReloadCharge, 
                  0.0, 0.0,
                  Texture'Engine.WhiteTexture'.USize,
                  Texture'Engine.WhiteTexture'.VSize*ReloadCharge);
}



// auto-generated on Mon May 10 22:38:07 CDT 2004

defaultproperties
{
     testX=100.000000
     testY=100.000000
     borderX=60.000000
     borderY=60.000000
     focusX=135.000000
     focusY=105.000000
     innerArrowsX=42.000000
     innerArrowsY=42.000000
     ArrowColor=(R=255,A=255)
     TargetColor=(B=255,G=255,R=255,A=255)
     NoTargetColor=(B=200,G=200,R=200,A=255)
     FocusColor=(B=126,G=90,R=71,A=215)
     ChargeColor=(B=255,G=255,R=255,A=255)
     RechargeOrigin=(X=600.000000,Y=330.000000)
     RechargeSize=(X=10.000000,Y=-180.000000)
     ScopeName="UT2003 Scope"
     ScopeAuthor="Epic - Unreal Tournament 2003"
     WebImage="scope_ut2003.jpg"
     ScopeShot=Texture'XxxXESRv2j.textures.UT2003Scope_P'
}
