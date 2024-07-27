THEOS_DEVICE_IP = 192.168.1.19
GO_EASY_ON_ME = 1
include theos/makefiles/common.mk
ARCHS = armv7

APPLICATION_NAME = GDSetup
GDSetup_FILES = main.m GDSetupApplication.mm RootViewController.mm SetupLS.mm SetupLSViewManager.m SetupLSWelcomeView.m SetupOTAInstallView.m SetupActivationView.m UIImage+StackBlur.m UIImage+Resize.m UIImage+LiveBlur.m SetupLSWelcomeScrollView.m SetupLSOTASettingView.m UIView+ToolTip.m MercuryModule.m ModuleInstallView.m ModuleView.m ModuleViewController.m ComponentEntryCell.m MercuryController.m NSData+Base64.m

GDSetup_FRAMEWORKS = UIKit CoreGraphics QuartzCore Foundation Security

include $(THEOS_MAKE_PATH)/application.mk
