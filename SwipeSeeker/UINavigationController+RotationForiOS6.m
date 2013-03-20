#import "UINavigationController+RotationForiOS6.h"

@implementation UINavigationController (RotationForiOS6)

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
- (BOOL)shouldAutorotate
{
  return NO;
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