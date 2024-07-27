#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "UIImage+LiveBlur.h"
#import "NSString+Localize.h"
#import "MercuryController.h"

@class SetupLS;

@interface SetupOTAInstallView : UIView{
	MercuryController *mController;
	ModuleView *moduleView;
	MercuryModule *module;
	UIButton *installButton;
	UILabel *installTitleLabel;
	UITextView *installBody;
	UIView *installBodyOverlay;
}
@property (nonatomic, assign) SetupLS *controller;
@end