#import "SSSettingController.h"
#import "SSSettingPickerView.h"
#import "SSSettingManager.h"
#import "SSSetting.h"

@interface SSSettingController (private)

- (void)_updateCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;

@end

@implementation SSSettingController

@synthesize items = _items;

#pragma mark - Init
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (!self) return nil;

    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.tableView.backgroundColor = [UIColor grayColor];
    NSIndexPath* indexPath;
    indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    for (UITableViewCell* cell in [self.tableView visibleCells]) {
        [self _updateCell:cell atIndexPath:[self.tableView indexPathForCell:cell]];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationPortrait) return YES;
    return NO;
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
