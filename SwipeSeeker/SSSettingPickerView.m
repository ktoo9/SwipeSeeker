#import "SSSettingPickerView.h"
#import "SSSettingManager.h"

@implementation SSSettingPickerView
{
  UIToolbar* _toolbar;
  UIPickerView* _picker;

  NSArray* _items;
  NSArray* _numItems;

  void (^completion)(NSString* selected);
}

#pragma mark - Init
- (id)init
{
  self = [super initWithFrame:[UIScreen mainScreen].bounds];
  if (!self) return nil;

  self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];

  _picker = [[UIPickerView alloc] init];
  _picker.showsSelectionIndicator = YES;
  _picker.delegate = self;
  _picker.dataSource = self;
  CGRect f = _picker.frame;
  f.origin.y = 480 - f.size.height;
  _picker.frame = f;
  [self addSubview:_picker];

  _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
  _toolbar.barStyle = UIBarStyleBlack;
  _toolbar.translucent = YES;
  f = _toolbar.frame;
  f.origin.y = _picker.frame.origin.y - 44;
  _toolbar.frame = f;
  [self addSubview:_toolbar];

  UIBarButtonItem* doneItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                  target:self
                                                  action:@selector(doneTapped:)];
  UIBarButtonItem* cancelItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                  target:self
                                                  action:@selector(hide)];
  UIBarButtonItem* spaceItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                  target:nil
                                                  action:nil];
  NSArray* buttonItems = [NSArray arrayWithObjects:cancelItem, spaceItem, doneItem, nil];
  [_toolbar setItems:buttonItems animated:NO];

  return self;
}

- (void)showInWindow:(UIWindow*)window completion:(void (^)(NSArray* selected))aCompletion;
{
  completion = [aCompletion copy];

  _items = [SSSettingManager sharedManager].allActions;
  _numItems = [NSArray arrayWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
  [self reselectInComponent:1];
  [self reselectInComponent:2];
  [self reselectInComponent:3];
  [_picker reloadAllComponents];

  CGRect f = _toolbar.frame;
  f.origin.y += 480;
  _toolbar.frame = f;

  f = _picker.frame;
  f.origin.y += 480;
  _picker.frame = f;

  [window addSubview:self];

  [UIView animateWithDuration:0.3
                   animations:^{
                     CGRect frame = _toolbar.frame;
                     frame.origin.y -= 480;
                     _toolbar.frame = frame;

                     frame = _picker.frame;
                     frame.origin.y -= 480;
                     _picker.frame = frame;
                   }];
}

- (CGFloat)pickerView:(UIPickerView*)pickerView widthForComponent:(NSInteger)component
{
  if(component == 0) {
    return 120;
  } else {
    return 40;
  }
}

- (UIView*)pickerView:(UIPickerView*)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView*)view {

  UILabel* retval;
  retval = (UILabel*)view;

  if (!retval) {
    retval = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 120.0, 44.0)];
    retval.backgroundColor = [UIColor clearColor];
    retval.textAlignment = SYSTEM_VERSION_LESS_THAN(@"6.0") ? UITextAlignmentCenter : NSTextAlignmentCenter;
    retval.font = [UIFont boldSystemFontOfSize:20];
  }

  if (component == 0) {
    retval.text = [_items objectAtIndex:row];
  } else {
    retval.text = [_numItems objectAtIndex:row % 10];
  }
  return retval;
}

#pragma mark - ItemsManupilation
-(void)reselectInComponent:(NSInteger)component
{
  NSUInteger max = 16384;
  NSUInteger base10 = (max / 2) - (max / 2) % 10;
  [_picker selectRow:[_picker selectedRowInComponent:component] % 10 + base10 inComponent:component animated:false];
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
  return [[SSSettingManager sharedManager].allActions count];
}

- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
  if (component == 0) {
    return [_items count];
  } else {
    return 16384;
  }
}

#pragma mark - UIPickerViewDelegate
- (NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  if (component == 0) {
    return [_items objectAtIndex:row];
  } else {
    return [_numItems objectAtIndex:row % 10];
  }
}

- (void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
  if (component == 0) {
    if (row == 0 || row == 1) {
      _numItems = [NSArray arrayWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    } else {
      _numItems = nil;
    }
    [_picker reloadAllComponents];
  } else if (component != 0 && _numItems != nil) {
    [self reselectInComponent:component];
  }
}

#pragma mark - Action
- (void)doneTapped:(id)sender
{
  NSNumber* timeLength = nil;
  if (_numItems) {
    timeLength = [[NSNumber alloc] initWithInt:
      ([_picker selectedRowInComponent:1] % 10) * 100 +
        ([_picker selectedRowInComponent:2] % 10) * 10 +
        ([_picker selectedRowInComponent:3] % 10)];
  }

  completion([NSArray arrayWithObjects:
    [_items objectAtIndex:[_picker selectedRowInComponent:0]],
    timeLength,
    nil]);

  [self hide];
}

- (void)hide
{
  completion(nil);
  [UIView animateWithDuration:0.3
                   animations:^{
                     CGRect frame = _toolbar.frame;
                     frame.origin.y += 480;
                     _toolbar.frame = frame;

                     frame = _picker.frame;
                     frame.origin.y += 480;
                     _picker.frame = frame;
                   }
                   completion:^ (BOOL finished) {
                     [self removeFromSuperview];

                     CGRect f = _toolbar.frame;
                     f.origin.y -= 480;
                     _toolbar.frame = f;

                     f = _picker.frame;
                     f.origin.y -= 480;
                     _picker.frame = f;
                   }];
}

@end
