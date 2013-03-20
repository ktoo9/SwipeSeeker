#import "SSSettingController.h"
#import "SSSettingPickerView.h"
#import "SSSettingManager.h"
#import "SSSetting.h"

@implementation SSSettingController
{
  NSArray* _items;
}

#pragma mark - Init
- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (!self) return nil;
  return self;
}

#pragma mark - View
- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

  self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
    // ios6
    UIView *bgView = [[UIView alloc] initWithFrame:self.tableView.frame];
    bgView.backgroundColor = [UIColor grayColor];
    self.tableView.backgroundView = bgView;
  } else {
    // not ios6
    self.tableView.backgroundColor = [UIColor grayColor];
  }

  NSIndexPath* indexPath;
  indexPath = [self.tableView indexPathForSelectedRow];
  if (indexPath) {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
  }

  for (UITableViewCell* cell in [self.tableView visibleCells]) {
    [self _updateCell:cell atIndexPath:[self.tableView indexPathForCell:cell]];
  }
}

#pragma mark - Rotate
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
  return 4;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
  static NSString* CellIdentifier = @"Cell";

  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
  }

  [self _updateCell:cell atIndexPath:indexPath];

  return cell;
}

#pragma mark - TableViewCellUpdate
- (void)_updateCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
  SSSetting* setting;
  setting = [[SSSettingManager sharedManager].settings objectAtIndex:indexPath.row];

  if (setting.time) {
    cell.textLabel.text = setting.gesture;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@  %@s", setting.action, [setting.time stringValue]];
  } else {
    cell.textLabel.text = setting.gesture;
    cell.detailTextLabel.text = setting.action;
  }
}

#pragma mark - TableViewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
  SSSettingPickerView* settingPickerView = [[SSSettingPickerView alloc] init];
  settingPickerView.selectedCell = indexPath;
  UIWindow* window = [[UIApplication sharedApplication] keyWindow];
  [settingPickerView showInWindow:window completion:^(NSArray* completion){

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (!completion) return;

    SSSetting* setting;
    setting = [[SSSettingManager sharedManager].settings objectAtIndex:indexPath.row];

    SSSetting* saveSetting = [[SSSetting alloc] init];
    saveSetting.gesture = setting.gesture;
    saveSetting.action = [completion objectAtIndex:0];
    saveSetting.time = nil;
    if ([completion count] == 2) saveSetting.time = [completion objectAtIndex:1];

    [[SSSettingManager sharedManager] replaceSetting:saveSetting atIndex:indexPath.row];
    [[SSSettingManager sharedManager] save];

    for (UITableViewCell* cell in [self.tableView visibleCells]) {
      [self _updateCell:cell atIndexPath:[self.tableView indexPathForCell:cell]];
    }
  }];
}

@end
