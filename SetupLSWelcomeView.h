#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "UIImage+LiveBlur.h"

#import "SetupLSWelcomeScrollView.h"
#import "NSString+Localize.h"

@class SetupLS;
@interface SetupLSWelcomeView : UIView <UIScrollViewDelegate>{
	SetupLSWelcomeScrollView *scrollView;
	UIView *contentView;
	UILabel *slideLabel;
	UITextView *aboutTextView;
	UIView *aboutContentView;
	UIImageView *aboutImageHeader;
	bool hasSnapshot;
	bool canceledTimer;

}
@property (nonatomic, assign) UIImageView *blurredImageView;
@property (nonatomic, assign) SetupLS *controller;
@end