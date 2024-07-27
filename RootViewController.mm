#import "RootViewController.h"
#import "SetupLS.h"

@implementation RootViewController
- (void)loadView {
	self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
	self.view.backgroundColor = [UIColor whiteColor];
	SetupLS *setupLSController = [[SetupLS alloc] init];
	[self.view addSubview:setupLSController.view];
}
@end
