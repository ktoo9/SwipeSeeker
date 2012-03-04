#import <Foundation/Foundation.h>

@class SSSetting;

@interface SSSettingManager : NSObject
{
    NSMutableArray* _settings;
}

@property (nonatomic, readonly, strong) NSArray* settings;
@property (nonatomic, readonly, strong) NSArray* allActions;

+ (SSSettingManager*)sharedManager;

- (void)replaceSetting:(SSSetting*)setting atIndex:(unsigned int)index;

- (void)load;
- (void)save;

@end
