#import "SSSetting.h"

@implementation SSSetting

- (id)init
{
  self = [super init];
  if (!self) return nil;
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
