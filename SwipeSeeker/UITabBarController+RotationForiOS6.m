#import "UITabBarController+RotationForiOS6.h"

@implementation UITabBarController (RotationForiOS6)

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
- (BOOL)shouldAutorotate
{
  return [self.selectedViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
  return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
  return UIInterfaceOrientationPortrait;
}
#endif

@end