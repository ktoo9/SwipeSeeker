#import "SSSettingManager.h"
#import "SSSetting.h"

@implementation SSSettingManager

@synthesize settings = _settings;
@synthesize allActions = _allActions;

static SSSettingManager* _sharedManager = nil;

+ (SSSettingManager*)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[SSSettingManager alloc] init];
    });
    return _sharedManager;
}

- (NSString*)_applicationPrivateDirectory
{	
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSString* libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString* privateDirectory = [libraryDirectory stringByAppendingPathComponent:@"PrivateDocuments"];
	if (![fileManager fileExistsAtPath:privateDirectory]) {
		[fileManager createDirectoryAtPath:privateDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
	}
	return privateDirectory;
}

- (void)replaceSetting:(SSSetting*)setting atIndex:(unsigned int)index
{
    if (!setting) return;
    if (index > [_settings count]) return;
    [_settings replaceObjectAtIndex:index withObject:setting];
}

- (void)load
{
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSString* path = [[self _applicationPrivateDirectory] stringByAppendingPathComponent:@"setting.dat"];
	if ([fileManager fileExistsAtPath:path]) {
		NSMutableData *data  = [NSMutableData dataWithContentsOfFile:path];
		NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
		_settings = [decoder decodeObjectForKey:@"setting"];
		[decoder finishDecoding];
	} else {

        SSSetting* (^defaultSetting)(NSString*, NSString*, NSNumber*) =
        ^(NSString* defaultGesture, NSString* defaultAction, NSNumber* defaultTime) {
            SSSetting* deafaultSetting = [[SSSetting alloc] init];
            deafaultSetting.gesture = defaultGesture;
            deafaultSetting.action = defaultAction;
            deafaultSetting.time = defaultTime;
            return  deafaultSetting;
        };
        _settings = [NSMutableArray arrayWithObjects:
                     defaultSetting(@"SwipeRight", @"forward", [NSNumber numberWithInt:5]),
                     defaultSetting(@"SwipeLeft", @"backward", [NSNumber numberWithInt:5]),
                     defaultSetting(@"SwipeUp", @"pause", nil),
                     defaultSetting(@"SwipeDown", @"stop", nil),
                     nil];
    }	
    _allActions = [NSArray arrayWithObjects:@"forward", @"backward", @"pause", @"stop", nil];
}

- (void)save
{
	NSMutableData* data = [NSMutableData data];
	NSKeyedArchiver* encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[encoder encodeObject:_settings forKey:@"setting"];
	[encoder finishEncoding];
	NSString* path = [[self _applicationPrivateDirectory] stringByAppendingPathComponent:@"setting.dat"];
	[data writeToFile:path atomically:YES];
}

@end
