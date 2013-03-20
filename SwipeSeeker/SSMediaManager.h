@class SSMedia;

@interface SSMediaManager : NSObject

@property (nonatomic, readonly, strong) NSMutableArray* videos;
@property (nonatomic, readonly, strong) NSMutableArray* audios;
@property (nonatomic, readonly, strong) NSArray* videoSuffixes;
@property (nonatomic, readonly, strong) NSArray* audioSuffixes;

+ (SSMediaManager*)sharedManager;

- (void)replaceVideo:(SSMedia*)media atIndex:(unsigned int)index;
- (void)replaceAudio:(SSMedia*)media atIndex:(unsigned int)index;

- (void)load;
- (void)save;

@end
