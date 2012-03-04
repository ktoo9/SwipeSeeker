#import "SSListCell.h"

@implementation SSListCell

@synthesize titleLabel = _titleLabel;
@synthesize timeLabel = _timeLabel;

#pragma mark - Init
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.highlightedTextColor = [UIColor whiteColor];
    [self.contentView addSubview:_titleLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _timeLabel.font = [UIFont systemFontOfSize:15.0f];
    _timeLabel.textColor = [UIColor blackColor];
    _timeLabel.textAlignment = UITextAlignmentRight;
    _timeLabel.highlightedTextColor = [UIColor whiteColor];
    [self.contentView addSubview:_timeLabel];
    
    return self;
}

#pragma mark - Selection
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    _titleLabel.highlighted = selected;
    _timeLabel.highlighted = selected;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];

    _titleLabel.highlighted = highlighted;
    _timeLabel.highlighted = highlighted;
}

#pragma mark - Layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds;
    bounds = self.contentView.bounds;
    
    CGRect rect;
    rect.origin.x = CGRectGetMinX(bounds) + 4.0f;
    rect.origin.y = CGRectGetMinY(bounds) + 2.0f;
    rect.size.width = CGRectGetWidth(bounds) - 8.0f;
    rect.size.height = 30.0f;
    _titleLabel.frame = rect;
    
    rect.origin.x = CGRectGetMinX(_titleLabel.frame);
    rect.origin.y = CGRectGetMaxY(_titleLabel.frame);
    rect.size.width = CGRectGetWidth(_titleLabel.frame);
    rect.size.height = 28.0f;
    _timeLabel.frame = rect;
}

@end
