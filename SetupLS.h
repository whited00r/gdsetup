#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "SetupLSViewManager.h"
#import "NSString+Localize.h"
#import "MercuryController.h"




@interface SetupLS : NSObject {
  UILabel *timeLabel;
}
@property (nonatomic, assign) MercuryController *mController;
@property (nonatomic, assign) UIView *view; //Set this up in the init method. This is your view that is going to be the new lockscreen. 
@property (nonatomic, assign) SetupLSViewManager *vManager;
@property (nonatomic, assign) UIImageView *blurOverlay; //Like magic, it lets things blur so smoothly? 
-(id)init; //Required
-(float)liblsVersion; //Required
-(void)unlock;
@end