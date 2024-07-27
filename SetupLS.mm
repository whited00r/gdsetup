#import "SetupLS.h"


/*
TO-DO:
Modular setup screens. Pre-build UI from .plist files. Can load up images and such. Predefined layout blocks can be used.
Toggles can be loaded up to switch preferences around if needed for features, along with descriptions as to what they do.
This way new screens can be added with OTA updates to walk through new features each time. Just use IDs for setup screens.

Maybe not the best idea actually. Lacks the "loving" touch?


*/


@implementation SetupLS

-(id)init{
  self = [super init];
    if (self){
    //self.controller = controller; //With this, we can use methods from the tweak that could be useful.



      
    CGRect screenFrame = [[UIScreen mainScreen] bounds]; //Get the screen size
    float screenWidth = screenFrame.size.width;
    float screenHeight = screenFrame.size.height;

    self.vManager = [[SetupLSViewManager alloc] init];
    self.vManager.controller = self;
    [self.vManager loadUp];

    self.view = [[UIView alloc] initWithFrame:CGRectMake(0,0,screenWidth, screenHeight)];
    self.view.backgroundColor = [UIColor whiteColor];//[UIColor colorWithPatternImage:[controller backgroundImage]]; //Like this! Just a simple thing to set the background image.

 

/*
 UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
[button addTarget:self 
           action:@selector(unlock)
 forControlEvents:UIControlEventTouchDown];
[button setTitle:@"Unlock" forState:UIControlStateNormal];
button.frame = CGRectMake((screenWidth / 2) - 160,0, 320, 40);
[self.view addSubview:button];
*/

self.blurOverlay = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,screenWidth, screenHeight)];
self.blurOverlay.alpha = 0;
self.blurOverlay.userInteractionEnabled = FALSE;
[self.view addSubview:self.blurOverlay];


[self.vManager changeToViewWithID:@"setupls.welcomeView"];

 //[UIApplication sharedApplication].idleTimerDisabled = TRUE;


  }
    return self;
}


-(float)liblsVersion{
  return 0.1; //What version of liblockscreen you built this using, so that legacy support can be provided and things don't break.
}









-(void)dealloc{
  [self.vManager release];
  [super dealloc];
}

@end