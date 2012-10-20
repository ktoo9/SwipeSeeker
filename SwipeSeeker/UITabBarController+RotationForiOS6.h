#import <Foundation/Foundation.h>

@interface UITabBarController (RotationForiOS6)

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
- (BOOL)shouldAutorotate;
- (NSUInteger)supportedInterfaceOrientations;
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation;
#endif

@end