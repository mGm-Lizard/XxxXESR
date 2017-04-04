class VSKScope extends XxxXScope;

var bool bCrossHairShow;

simulated function PostBeginPlay()
{
  Super.PostBeginPlay();
  bCrossHairShow = PlayerController(Instigator.Controller).MyHUD.bCrosshairShow;
}


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

  SetZoomBlendColor(Canvas);
  PlayerController(Instigator.Controller).MyHUD.bCrosshairShow = false;

  Scale = Canvas.ClipX/640 * 1.0; //1.5
  Canvas.SetPos(0.5 * Canvas.ClipX - 128 * Scale, 0.5 * Canvas.ClipY - 128 * Scale );
        Canvas.Style = ERenderStyle.STY_Translucent;
  Canvas.DrawIcon(Texture'VSK_Scope', Scale);
  Canvas.SetPos(0.5 * Canvas.ClipX + 64 * Scale, 0.5 * Canvas.ClipY + 96 * Scale);
  Canvas.DrawColor.R = 0;
  Canvas.DrawColor.G = 155;
  Canvas.DrawColor.B = 0;
  Scale = ( PlayerController(Instigator.Controller).DefaultFOV /
            PlayerController(Instigator.Controller).DesiredFOV );
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

defaultproperties
{
     ScopeName="VSK Scope"
     ScopeAuthor="RAY@VSK??"
     WebImage="scope_ut2003.jpg"
     ScopeShot=Texture'XxxXESRv2j.textures.VSK_scope'
}
