#import "SetupOTAInstallView.h"
#import "SetupLS.h"
#include <sys/sysctl.h>

@implementation SetupOTAInstallView
-(id)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if(self){
		mController = [[MercuryController alloc] init];
    	[mController loadUp];


    	module = [mController.modules objectForKey:@"com.greyd00r"]; //And just like that I have access to many things. I loaded up too much I think just to get this view but whatever right? I'll fix it later... *buys coffee*... Sorry, what? I forgot what I was doing.
		if(module){
			NSLog(@"Found module! %@",  module.viewController.view);
			//[[[[self.navigationController viewControllers] firstObject] view] addSubview:module.viewController.view];
			[self addSubview:module.viewController.view];
			[module.viewController directOpen];

			
			moduleView = (ModuleView*)module.viewController.view;
			moduleView.setupInstallController = self;
			//currentModuleID = [module valueForKey:@"moduleID"];
			[moduleView.installView setAnimationWait:0.8 length:1.4 alpha:0.4];
			[moduleView showInstallScreen];
			moduleView.installView.backgroundColor = [UIColor whiteColor]; //Now I need to set all label background colours to white -__-;
			moduleView.alpha = 1.0;


		installTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width / 2) - 160,frame.size.height / 2 - 20, 320, 40)];
		installTitleLabel.textAlignment = UITextAlignmentCenter;
		[installTitleLabel setFont:[UIFont fontWithName:@"Verdana-Bold" size:24]];
		installTitleLabel.textColor = [UIColor blackColor];
		installTitleLabel.backgroundColor = [UIColor clearColor];
		installTitleLabel.text = NSLocalizedBundleString(@"FINISH_INSTALL_HEADER", nil);
		[self addSubview:installTitleLabel];
		//[aboutHeader release];

	    installBody = [[UITextView alloc] initWithFrame:CGRectMake((frame.size.width / 2) - 160, installTitleLabel.frame.origin.y + 40, 320, 150)];
	    installBody.backgroundColor = [UIColor clearColor];
	    installBody.textColor = [UIColor blackColor];
	    installBody.font = [UIFont fontWithName:@"Helvetica" size:14];
	    installBody.userInteractionEnabled = TRUE;
	    installBody.textAlignment = UITextAlignmentCenter;
	    installBody.text = NSLocalizedBundleString(@"FINISH_INSTALL_BODY", nil);
	    installBody.editable = FALSE;
	    [self addSubview:installBody];

installBodyOverlay = [[UIView alloc] initWithFrame:installBody.frame];
[installBodyOverlay setBackgroundColor:[UIColor whiteColor]];
[installBodyOverlay setUserInteractionEnabled:NO];
[self addSubview:installBodyOverlay];

NSArray *colors = [NSArray arrayWithObjects:
                   (id)[[UIColor colorWithWhite:0 alpha:1] CGColor],
                   (id)[[UIColor colorWithWhite:0 alpha:0] CGColor],
                   nil];

CAGradientLayer *layer = [CAGradientLayer layer];
[layer setFrame:installBodyOverlay.bounds];
[layer setColors:colors];
[layer setStartPoint:CGPointMake(0.0f, 1.0f)];
[layer setEndPoint:CGPointMake(0.0f, 0.6f)];
[installBodyOverlay.layer setMask:layer];
installBodyOverlay.alpha = 1.0;

 	installButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[installButton addTarget:self 
           action:@selector(installPressed)
 forControlEvents:UIControlEventTouchDown];
[installButton setTitle:NSLocalizedBundleString(@"FINISH_INSTALL_BUTTON", nil) forState:UIControlStateNormal];
[installButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
[installButton setTitleColor:[UIColor colorWithRed:0.0 green:50.0/255.0 blue:200.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
installButton.frame = CGRectMake((frame.size.width / 2) - 160,frame.size.height - 70, 320, 40);
installButton.font = [UIFont fontWithName:@"Arial" size:24];
installButton.alpha = 1.0; //Only show this when an OTA option has been chosen!
[installButton setBackgroundImage:nil forState:UIControlStateNormal];
[self addSubview:installButton];

		}	
	}
	return self;
}


-(void)reshowInstallStartViews{
	 			//[moduleView.installView stopAnimation];
				//[moduleView.installView clearScreen]; //Wipe all the data there...

				

	         	[UIView animateWithDuration:0.25
                      delay:0.0
                    options:UIViewAnimationOptionBeginFromCurrentState
                 animations:^{
                      	installTitleLabel.alpha = 1.0;
						installBody.alpha = 1.0;
						installButton.alpha = 1.0;
						installBodyOverlay.alpha = 1.0;
						installTitleLabel.userInteractionEnabled = TRUE;
						installBody.userInteractionEnabled = TRUE;
						installButton.userInteractionEnabled = TRUE;

                 }
                 completion:^(BOOL finished){
                 	[moduleView.installView startAnimation];
                 }];

	         	
}

-(void)continuePressed{
	 [moduleView.installView stopAnimation];
	 [self.controller.vManager changeToViewWithID:@"setupls.activationView"];

}

-(void)installPressed{

	         	[UIView animateWithDuration:0.25
                      delay:0.0
                    options:UIViewAnimationOptionBeginFromCurrentState
                 animations:^{
                      	installTitleLabel.alpha = 0.0;
						installBody.alpha = 0.0;
						installButton.alpha = 0.0;
						installBodyOverlay.alpha = 0.0;
						installTitleLabel.userInteractionEnabled = FALSE;
						installBody.userInteractionEnabled = FALSE;
						installButton.userInteractionEnabled = FALSE;

                 }
                 completion:nil];
	//Taken from the moduleViewController thingy. I bypass the alert view asking if they want to install updates and instead just use this because I don't actually want to see the install view. If that makes sense.
	module.viewController.isInstalling = TRUE;
	[moduleView.installView setAnimationWait:0.4 length:1.0 alpha:0.0];
	[moduleView.installView startUpdates];
	[UIApplication sharedApplication].idleTimerDisabled = TRUE;
	[module installUpdates]; 
}
@end