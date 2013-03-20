#import "SSPlayController.h"
#import "SSSettingManager.h"
#import "SSSetting.h"
#import "SSMediaManager.h"
#import "SSMedia.h"

@implementation SSPlayController
{
  SSMedia* _media;
}

#pragma mark - View
- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

  // AVAudioSession Category
  AVAudioSession *audioSession =[AVAudioSession sharedInstance];
  if (SYSTEM_VERSION_LESS_THAN(@"6.0")) {
    [audioSession setCategory:AVAudioSessionCategoryAmbient error:nil];
  }
  else {
    [audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
  }

  // Get SSMedia
  [[SSSettingManager sharedManager] load];
  [[SSMediaManager sharedManager] load];
  for (NSString* suffix in [SSMediaManager sharedManager].videoSuffixes) {
    if ([self.moviePlayer.contentURL.pathExtension isEqualToString:suffix]) {
      _media = [[SSMediaManager sharedManager].videos objectAtIndex:_selectedIndexRow];
    }
  }
  for (NSString* suffix in [SSMediaManager sharedManager].audioSuffixes) {
    if ([self.moviePlayer.contentURL.pathExtension isEqualToString:suffix]) {
      _media = [[SSMediaManager sharedManager].audios objectAtIndex:_selectedIndexRow];
    }
  }

  // moviePlayer
  self.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
  self.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
  self.moviePlayer.initialPlaybackTime = [_media.position floatValue];

  // Notification
  NSNotificationCenter* center;
  center = [NSNotificationCenter defaultCenter];
  [center addObserver:self
             selector:@selector(playbackDidFinish:)
                 name:MPMoviePlayerPlaybackDidFinishNotification
               object:nil];

  // Gesture
  UISwipeGestureRecognizer* swipeGestureU = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(_swipeMethod:)];
  swipeGestureU.direction = UISwipeGestureRecognizerDirectionUp;
  [self.view addGestureRecognizer:swipeGestureU];

  UISwipeGestureRecognizer* swipeGestureD = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(_swipeMethod:)];
  swipeGestureD.direction = UISwipeGestureRecognizerDirectionDown;
  [self.view addGestureRecognizer:swipeGestureD];

  UISwipeGestureRecognizer* swipeGestureL = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(_swipeMethod:)];
  swipeGestureL.direction = UISwipeGestureRecognizerDirectionLeft;
  [self.view addGestureRecognizer:swipeGestureL];

  UISwipeGestureRecognizer* swipeGestureR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(_swipeMethod:)];
  swipeGestureR.direction = UISwipeGestureRecognizerDirectionRight;
  [self.view addGestureRecognizer:swipeGestureR];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];

  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [self _saveAtTime:self.moviePlayer.currentPlaybackTime];
}

#pragma mark - Rotate
- (BOOL)shouldAutorotate
{
  return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
  return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
  return UIInterfaceOrientationPortrait;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
  return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Gesture Action
- (void)_swipeMethod:(id)sender
{
  UISwipeGestureRecognizer* swipe = (UISwipeGestureRecognizer*)sender;

  SSSetting* setting;
  switch (swipe.direction) {
    case UISwipeGestureRecognizerDirectionRight:
      setting = [[SSSettingManager sharedManager].settings objectAtIndex:0];
      [self _doActionWithSetting:setting];
      break;
    case UISwipeGestureRecognizerDirectionLeft:
      setting = [[SSSettingManager sharedManager].settings objectAtIndex:1];
      [self _doActionWithSetting:setting];
      break;
    case UISwipeGestureRecognizerDirectionUp:
      setting = [[SSSettingManager sharedManager].settings objectAtIndex:2];
      [self _doActionWithSetting:setting];
      break;
    case UISwipeGestureRecognizerDirectionDown:
      setting = [[SSSettingManager sharedManager].settings objectAtIndex:3];
      [self _doActionWithSetting:setting];
      break;
    default:
      break;
  }
}

- (void)_doActionWithSetting:(SSSetting*)setting
{
  NSTimeInterval currentTime = self.moviePlayer.currentPlaybackTime;

  if ([setting.action isEqualToString:@"forward"]) {

    double playForwardTime = [setting.time doubleValue];
    if (self.moviePlayer.duration > currentTime + playForwardTime) {
      self.moviePlayer.currentPlaybackTime = currentTime + playForwardTime;
    } else {
      self.moviePlayer.currentPlaybackTime = 0;
    }
  } else if ([setting.action isEqualToString:@"backward"]) {

    double playBackTime = [setting.time doubleValue];
    if (currentTime > playBackTime) {
      self.moviePlayer.currentPlaybackTime = currentTime - playBackTime;
    } else {
      self.moviePlayer.currentPlaybackTime = 0;
    }
  } else if ([setting.action isEqualToString:@"pause"]) {

    if (self.moviePlayer.playbackState == 1) {
      [self.moviePlayer pause];
    } else {
      [self.moviePlayer play];
    }
  } else if ([setting.action isEqualToString:@"stop"]) {

    [self.moviePlayer pause];
    if ([_delegate respondsToSelector:@selector(SSPlayControllerDidStop:)]) {
      [_delegate SSPlayControllerDidStop:self];
    }
  }
}

#pragma mark - Save
- (void)_saveAtTime:(NSTimeInterval)time
{
  SSMedia* media = [[SSMedia alloc] init];
  media.path = self.moviePlayer.contentURL.path;
  media.position = [NSNumber numberWithFloat:time];

  for (NSString* suffix in [SSMediaManager sharedManager].videoSuffixes) {
    if ([self.moviePlayer.contentURL.pathExtension isEqualToString:suffix]) {
      [[SSMediaManager sharedManager] replaceVideo:media atIndex:_selectedIndexRow];
    }
  }

  for (NSString* suffix in [SSMediaManager sharedManager].audioSuffixes) {
    if ([self.moviePlayer.contentURL.pathExtension isEqualToString:suffix]) {
      [[SSMediaManager sharedManager] replaceAudio:media atIndex:_selectedIndexRow];
    }
  }
  [[SSMediaManager sharedManager] save];
}

#pragma mark - Notification
- (void)playbackDidFinish:(NSNotification*)notification
{
  NSNumber* reason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
  switch ([reason intValue]) {
    case MPMovieFinishReasonPlaybackEnded:
      self.moviePlayer.currentPlaybackTime = 0;
      [self _saveAtTime:self.moviePlayer.currentPlaybackTime];
      break;
    case MPMovieFinishReasonUserExited:
      break;
    case MPMovieFinishReasonPlaybackError:
      break;
    default:
      break;
  }
}

@end
