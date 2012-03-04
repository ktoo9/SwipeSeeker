#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@class SSMedia;

@interface SSPlayController : MPMoviePlayerViewController
{
    SSMedia* _media;
}

@property (nonatomic, weak) id delegate;
@property(nonatomic) int selectedIndexRow;

@end

@interface NSObject (SSPlayControllerDelegate)

- (void)SSPlayControllerDidStop:(SSPlayController*)controller;

@end
