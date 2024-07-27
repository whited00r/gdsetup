#import "SetupLSWelcomeView.h"
#import "SetupLS.h"



@interface UILabel (FSHighlightAnimationAdditions)

- (void)setTextWithChangeAnimation:(NSString*)text;

@end


@implementation UILabel (FSHighlightAnimationAdditions)

- (void)setTextWithChangeAnimation:(NSString*)text
{
   
    self.text = text;
    CALayer *maskLayer = [CALayer layer];

    // Mask image ends with 0.15 opacity on both sides. Set the background color of the layer
    // to the same value so the layer can extend the mask image.
    //maskLayer.backgroundColor = [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.25f] CGColor];
    maskLayer.contents = (id)[[UIImage imageWithContentsOfFile:@"/Applications/GDSetup.app/Mask.png"] CGImage]; 

    // Center the mask image on twice the width of the text layer, so it starts to the left
    // of the text layer and moves to its right when we translate it by width.
    maskLayer.contentsGravity = kCAGravityCenter;
    maskLayer.frame = CGRectMake(self.frame.size.width * -1, 0.0f, self.frame.size.width * 2, self.frame.size.height);




CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
animationGroup.duration = 2.5f;
animationGroup.repeatCount = INFINITY;


    // Animate the mask layer's horizontal position
    CABasicAnimation *maskAnim = [CABasicAnimation animationWithKeyPath:@"position.x"];
    maskAnim.byValue = [NSNumber numberWithFloat:self.frame.size.width];
    //maskAnim.repeatCount = HUGE_VALF;
    maskAnim.duration = 2.0f;

animationGroup.animations = @[maskAnim];

[maskLayer addAnimation:animationGroup forKey:@"slideAnim"];


    //[maskLayer addAnimation:maskAnim forKey:@"slideAnim"];

    self.layer.mask = maskLayer;
}

@end

static bool passTouchesToDelegate = TRUE;



@implementation SetupLSWelcomeView

-(id)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if(self){
		self.backgroundColor = [UIColor clearColor];
		hasSnapshot = FALSE;
		canceledTimer = FALSE;
		self.userInteractionEnabled = TRUE;
		scrollView = [[SetupLSWelcomeScrollView alloc] initWithFrame:CGRectMake(0,0,frame.size.width, frame.size.height)];
		scrollView.delegate = self;
		scrollView.backgroundColor = [UIColor clearColor];
		scrollView.clipsToBounds = FALSE;
		scrollView.contentSize = CGSizeMake(frame.size.width * 2, frame.size.height);
		scrollView.userInteractionEnabled = TRUE;
		scrollView.showsHorizontalScrollIndicator = FALSE;
		scrollView.pagingEnabled = TRUE;
		scrollView.contentOffset = CGPointMake(frame.size.width, 0); 
		//[scrollView setPassTouchesToDelegate:TRUE];

		contentView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width,0,frame.size.width, frame.size.height)];
		contentView.backgroundColor = [UIColor whiteColor];
		[scrollView addSubview:contentView];

		aboutContentView = [[UIView alloc] initWithFrame:CGRectMake(0,0,frame.size.width, frame.size.height)];
		aboutContentView.backgroundColor = [UIColor clearColor];
		aboutContentView.userInteractionEnabled = FALSE;
		aboutContentView.alpha = 0.0;
		aboutContentView.transform=CGAffineTransformMakeScale(0.5, 0.5);

		UILabel *gdLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,(frame.size.height / 2) - 30,frame.size.width,60)];
    	gdLabel.textAlignment = UITextAlignmentCenter;
    	[gdLabel setFont:[UIFont fontWithName:@"Arial" size:48]];
    	gdLabel.textColor = [UIColor blackColor];
    	gdLabel.text = @"Grayd00r";
    	gdLabel.backgroundColor = [UIColor clearColor];
    	gdLabel.alpha = 1;

    	[contentView addSubview:gdLabel]; //Why don't we add the actual content to the scroll view? Because this looks cool.


		self.blurredImageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width,0,frame.size.width, frame.size.height)];
		self.blurredImageView.alpha = 0.0;
		self.blurredImageView.backgroundColor = [UIColor clearColor];
		self.blurredImageView.userInteractionEnabled = TRUE;
		self.blurredImageView.layer.masksToBounds = FALSE;
		//self.blurredImageView.clipsToBounds = YES;
    	self.blurredImageView.layer.contentsRect = CGRectMake(0.0, 0.0, 1, 1);
		[scrollView addSubview:self.blurredImageView];




		UILabel * unlockShadeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,frame.size.height - 70, frame.size.width, 40)];
	   	UILabel* unlockLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,frame.size.height - 70, frame.size.width, 40)];
	    unlockLabel.textAlignment = UITextAlignmentCenter;
	    unlockShadeLabel.textAlignment = UITextAlignmentCenter;
	    [unlockLabel setFont:[UIFont fontWithName:@"Arial" size:22]];
	    [unlockShadeLabel setFont:[UIFont fontWithName:@"Arial" size:22]];
	    unlockShadeLabel.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.60f];
	    unlockLabel.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f]; //Or set all numbers to 255 to make it white instead of black and drop down alpha a couple points
	    unlockLabel.backgroundColor = [UIColor clearColor];
	    unlockShadeLabel.backgroundColor = [UIColor clearColor];

	    unlockShadeLabel.text = NSLocalizedBundleString(@"SLIDE_TO_SETUP", nil);
	    [unlockLabel setTextWithChangeAnimation:NSLocalizedBundleString(@"SLIDE_TO_SETUP", nil)];
	    NSLog(@"GDSETUPDEBUG: Main bundle is :%@", [NSBundle mainBundle]);

	    [contentView addSubview:unlockShadeLabel];
	    [contentView addSubview:unlockLabel];
	    [unlockLabel release];

	    [unlockShadeLabel release];


		UILabel* aboutHeader = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width / 2) - 160,200, 320, 40)];
		aboutHeader.textAlignment = UITextAlignmentCenter;
		[aboutHeader setFont:[UIFont fontWithName:@"Verdana-Bold" size:24]];
		aboutHeader.textColor = [UIColor blackColor];
		aboutHeader.backgroundColor = [UIColor clearColor];
		aboutHeader.text = NSLocalizedBundleString(@"ABOUT_HEADER", nil);
		[aboutContentView addSubview:aboutHeader];
		//[aboutHeader release];

	    aboutTextView = [[UITextView alloc] initWithFrame:CGRectMake((frame.size.width / 2) - 160,aboutHeader.frame.origin.y + 25, 320, 80)];
	    aboutTextView.backgroundColor = [UIColor clearColor];
	    aboutTextView.textColor = [UIColor blackColor];
	    aboutTextView.font = [UIFont fontWithName:@"Helvetica" size:18];
	    aboutTextView.userInteractionEnabled = FALSE;
	    aboutTextView.textAlignment = UITextAlignmentCenter;
	    aboutTextView.text = NSLocalizedBundleString(@"ABOUT_BODY", nil);
	    [aboutContentView addSubview:aboutTextView];
	    //[aboutTextView release];

	    UITextView * aboutSetupTextView = [[UITextView alloc] initWithFrame:CGRectMake((frame.size.width / 2) - 150,aboutTextView.frame.origin.y + 100, 300, 100)];
	    aboutSetupTextView.backgroundColor = [UIColor clearColor];
	    aboutSetupTextView.textColor = [UIColor blackColor];
	    aboutSetupTextView.font = [UIFont fontWithName:@"Arial" size:14];
	    aboutSetupTextView.userInteractionEnabled = FALSE;
	    aboutSetupTextView.textAlignment = UITextAlignmentCenter;
	    aboutSetupTextView.text = NSLocalizedBundleString(@"ABOUT_SETUP", nil);
	    [aboutContentView addSubview:aboutSetupTextView];
	    //[aboutSetupTextView release];

	    aboutImageHeader = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width /2) - 60,40,120, 120)];

	    aboutImageHeader.image = [UIImage imageWithContentsOfFile:@"/Applications/GDSetup.app/Greyd00rLogoNoGear.png"];
	    [aboutContentView addSubview:aboutImageHeader];
	    [aboutImageHeader release];


 	UIButton *continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[continueButton addTarget:self 
           action:@selector(continuePressed)
 forControlEvents:UIControlEventTouchDown];
[continueButton setTitle:NSLocalizedBundleString(@"CONTINUE_SETUP", nil) forState:UIControlStateNormal];
[continueButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
[continueButton setTitleColor:[UIColor colorWithRed:0.0 green:50.0/255.0 blue:200.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
continueButton.frame = CGRectMake((frame.size.width / 2) - 160,frame.size.height - 70, 320, 40);
continueButton.font = [UIFont fontWithName:@"Arial" size:24];
[continueButton setBackgroundImage:nil forState:UIControlStateNormal];
[aboutContentView addSubview:continueButton];
	   
		
		[self addSubview:scrollView];
		

		[self addSubview:aboutContentView];

		
		[aboutTextView release];
	}

	return self;
}

-(void)layoutSubviews{
[super layoutSubviews];
if(!hasSnapshot){
	hasSnapshot = TRUE;
	[UIImage prepareSnapshotOfView:self forSnapshotHolderView:self.blurredImageView];

	self.blurredImageView.layer.masksToBounds = FALSE;
	//self.blurredImageView.clipsToBounds = YES;
    self.blurredImageView.layer.contentsRect = CGRectMake(0.0, 0.0, 1, 1);
	//[UIImage liveBlurForScreenWithQuality:4 interpolation:4 blurRadius:15];
}

}

-(void)continuePressed{
	[self.controller.vManager changeToViewWithID:@"setupls.OTASettingView"];
}


-(void)scrollViewDidScroll:(UIScrollView *)sView{
  	//if(!sView.dragging){
		if(sView.contentOffset.x <= self.frame.size.width / 3){ //Not being moved manually?
			//NSLog(@"NOTMOVEDMANUALLY");
			//sView.userInteractionEnabled = FALSE;
			aboutContentView.userInteractionEnabled = TRUE;
			//[scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
			//sView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);

		}
	//}

	float alphaBlur = 1 - ((sView.contentOffset.x * 2) / self.frame.size.width); 
	float alphaAbout = 1 - ((sView.contentOffset.x * 2) / self.frame.size.width * 2);
	if(alphaBlur > 1.0){
		//alphaBlur = 1.0;
	}

	float aboutScale = alphaBlur;
	if(aboutScale < 0.5){
		aboutScale = 0.5;
	}
	float alphaContent = -1 + ((sView.contentOffset.x * 2) / self.frame.size.width); 
	//NSLog(@"GDSETUPDEBUG: alpha is %f, %f", alphaBlur, alphaContent);
	self.blurredImageView.alpha = alphaBlur + 0.1;
	contentView.alpha = alphaContent + 0.2;
	aboutContentView.alpha = alphaAbout;
	aboutContentView.transform=CGAffineTransformMakeScale(aboutScale, aboutScale);




}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
  NSLog(@"GDSETUPDEBUG: touchesBegan");

}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{


  NSLog(@"GDSETUPDEBUG: touchesEnded");

  if(scrollView.contentOffset.x <= self.frame.size.width / 3){
      //[self.lsController unlock];
  	  //[scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:YES];

      NSLog(@"GDSETUPDEBUG: ScrollView scrolled to unlock point");

    }
}
@end