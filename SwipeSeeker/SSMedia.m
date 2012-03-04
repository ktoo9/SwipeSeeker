#import "SSMedia.h"

@implementation SSMedia

@synthesize path = _path;
@synthesize position = _position;

- (id)initWithCoder:(NSCoder*)coder
{
	_path = [coder decodeObjectForKey:@"path"];
	_position = [coder decodeObjectForKey:@"position"];
	return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
	[encoder encodeObject:_path forKey:@"path"];
	[encoder encodeObject:_position forKey:@"position"];
}

@end
