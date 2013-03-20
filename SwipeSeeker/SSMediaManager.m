#import "SSMediaManager.h"
#import "SSMedia.h"

@implementation SSMediaManager
{
  NSMutableArray* _videos;
  NSMutableArray* _audios;
}

static SSMediaManager* _sharedManager = nil;
+ (SSMediaManager*)sharedManager
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
  _sharedManager = [[SSMediaManager alloc] init];
});
  return _sharedManager;
}

- (id)init
{
  self = [super init];
  if (!self) return nil;

  _videos = [NSMutableArray array];
  _audios = [NSMutableArray array];
  _videoSuffixes = [NSArray arrayWithObjects:@"mp4", @"m4v", @"mov", nil];
  _audioSuffixes = [NSArray arrayWithObjects:@"mp3", nil];

  return self;
}

- (void)replaceVideo:(SSMedia*)media atIndex:(unsigned int)index {
  if (!media) return;
  if (index > [_videos count]) return;
  [_videos replaceObjectAtIndex:index withObject:media];
}

- (void)replaceAudio:(SSMedia*)media atIndex:(unsigned int)index {
  if (!media) return;
  if (index > [_audios count]) return;
  [_audios replaceObjectAtIndex:index withObject:media];
}

- (NSString*)_applicationPrivateDirectory
{
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSString *libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
  NSString *privateDirectory = [libraryDirectory stringByAppendingPathComponent:@"PrivateDocuments"];
  if (![fileManager fileExistsAtPath:privateDirectory]) {
    [fileManager createDirectoryAtPath:privateDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
  }
  return privateDirectory;
}

- (void)load
{
  NSFileManager* fileManager = [NSFileManager defaultManager];
  NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString* docPath = [paths objectAtIndex:0];
  NSError* error;
  if (![fileManager contentsOfDirectoryAtPath:docPath error:&error]) return;

  // Video
  NSMutableArray* tempVideos = [NSMutableArray array];
  for (NSString* content in [fileManager contentsOfDirectoryAtPath:docPath error:&error]) {
    for (NSString* suffix in _videoSuffixes) {
      if ([content hasSuffix:suffix]) {
        SSMedia* video = [[SSMedia alloc] init];
        video.path = [docPath stringByAppendingPathComponent:content];
        video.position = 0;
        [tempVideos addObject:video];
      }
    }
  }
  [_videos setArray:tempVideos];

  NSString* videoPath = [[self _applicationPrivateDirectory] stringByAppendingPathComponent:@"video.dat"];
  if ([fileManager fileExistsAtPath:videoPath]) {
    NSArray* tempVideos;
    tempVideos = [NSKeyedUnarchiver unarchiveObjectWithFile:videoPath];
    if (tempVideos && _videos) {
      for (SSMedia* video in _videos) {
        for (SSMedia* tempVideo in tempVideos) {
          if ([video.path isEqualToString:tempVideo.path]) {
            video.position = tempVideo.position;
          }
        }
      }
    }
  }

  // Audio
  NSMutableArray* tempAudios = [NSMutableArray array];
  for (NSString* content in [fileManager contentsOfDirectoryAtPath:docPath error:&error]) {
    for (NSString* suffix in _audioSuffixes) {
      if ([content hasSuffix:suffix]) {
        SSMedia* audio = [[SSMedia alloc] init];
        audio.path = [docPath stringByAppendingPathComponent:content];
        audio.position = 0;
        [tempAudios addObject:audio];
      }
    }
  }
  [_audios setArray:tempAudios];

  NSString* audioPath = [[self _applicationPrivateDirectory] stringByAppendingPathComponent:@"audio.dat"];
  if ([fileManager fileExistsAtPath:audioPath]) {
    NSArray* tempAudios;
    tempAudios = [NSKeyedUnarchiver unarchiveObjectWithFile:audioPath];
    if (tempAudios && _audios) {
      for (SSMedia* audio in _audios) {
        for (SSMedia* tempAudio in tempAudios) {
          if ([audio.path isEqualToString:tempAudio.path]) {
            audio.position = tempAudio.position;
          }
        }
      }
    }
  }
}

- (void)save
{
  NSString* videoPath = [[self _applicationPrivateDirectory] stringByAppendingPathComponent:@"video.dat"];
  [NSKeyedArchiver archiveRootObject:_videos toFile:videoPath];
  NSString* audioPath = [[self _applicationPrivateDirectory] stringByAppendingPathComponent:@"audio.dat"];
  [NSKeyedArchiver archiveRootObject:_audios toFile:audioPath];
}

@end
