class XxxXScope extends Actor;

var String  ScopeName;
var String  ScopeAuthor;
var String  WebImage;
var Texture ScopeShot;
var String  ConfigClassName; //popup config class for a scope :O

// this is called when you are not zoomed
simulated function RenderNormal( Canvas Canvas );

// this is called when you are zoomed
simulated function RenderZoom( Canvas Canvas );

// this is called when you bring up the ESR
simulated function BringUp( optional Weapon PrevWeapon );

// this is called when you put down the ESR
simulated function bool PutDown();

simulated function PostBeginPlay()
{
  Super.PostBeginPlay();
  Instigator = Owner.Instigator;
}

defaultproperties
{
     ScopeName="wasup"
     ScopeAuthor="rgr"
     bHidden=True
}
