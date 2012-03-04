#import "SSSetting.h"

@implementation SSSetting

@synthesize gesture = _gesture;
@synthesize action = _action;
@synthesize time = _time;

- (id)init
{
    if (self = [super init]) {
	}
	return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
	_gesture = [coder decodeObjectForKey:@"gesture"];
	_action = [coder decodeObjectForKey:@"action"];
	_time = [coder decodeObjectForKey:@"time"];
	return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
	[encoder encodeObject:_gesture forKey:@"gesture"];
	[encoder encodeObject:_action forKey:@"action"];
	[encoder encodeObject:_time forKey:@"time"];
}

@end
