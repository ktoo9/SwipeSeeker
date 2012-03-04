#import <Foundation/Foundation.h>

@class SSMedia;

@interface SSMediaManager : NSObject
{
    NSMutableArray* _videos;
    NSMutableArray* _audios;
}

@property (nonatomic, readonly, strong) NSMutableArray* videos;
@property (nonatomic, readonly, strong) NSMutableArray* audios;
@property (nonatomic, readonly, strong) NSArray* videoSuffixes;
@property (nonatomic, readonly, strong) NSArray* audioSuffixes;

+ (SSMediaManager*)sharedManager;

- (void)addVideo:(SSMedia*)media;
- (void)replaceVideo:(SSMedia*)media atIndex:(unsigned int)index;
- (void)addAudio:(SSMedia*)media;
- (void)replaceAudio:(SSMedia*)media atIndex:(unsigned int)index;

- (void)load;
- (void)save;

@end
