#import <Foundation/Foundation.h>

@interface SSSetting : NSObject
<NSCoding>
{
}

@property (nonatomic, strong) NSString* gesture;
@property (nonatomic, strong) NSString* action;
@property (nonatomic, strong) NSNumber* time;

@end
