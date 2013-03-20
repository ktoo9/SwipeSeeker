#import "SSListController.h"
#import "SSListCell.h"
#import "SSMediaManager.h"
#import "SSMedia.h"
#import "SSPlayController.h"

@implementation SSListController
{
  NSArray* _items;
  SSPlayController* moviePlayer;
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

  [[SSMediaManager sharedManager] load];

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
  return [_items count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
  SSListCell* cell;
  cell = (SSListCell*)[tableView dequeueReusableCellWithIdentifier:@"SSListCell"];
  if (!cell) {
    cell = [[SSListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SSListCell"];
  }

  [self _updateCell:cell atIndexPath:indexPath];

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 60.0f;
}

#pragma mark - TableViewCellUpdate
- (void)_updateCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
  SSListCell* listCell;
  listCell = (SSListCell*)cell;

  SSMedia* media = [_items objectAtIndex:indexPath.row];

  NSString* title;
  title = [[media.path lastPathComponent] stringByDeletingPathExtension];
  UIColor* titleColor = [UIColor blackColor];
  listCell.titleLabel.text = title;
  listCell.titleLabel.textColor = titleColor;

  AVPlayerItem* playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:media.path]];
  CMTime duration = playerItem.duration;
  float seconds_all = CMTimeGetSeconds(duration);
  int min_all = floor(seconds_all / 60);
  int sec_all = round(seconds_all - min_all * 60);

  float seconds_part = [media.position floatValue];
  int min_part = floor(seconds_part / 60);
  int sec_part = round(seconds_part - min_part * 60);

  listCell.timeLabel.text = [NSString stringWithFormat:@"%02dm%02ds / %02dm%02ds", min_part, sec_part, min_all, sec_all];
}

#pragma mark - TableViewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
  SSMedia* media = [_items objectAtIndex:indexPath.row];
  moviePlayer =[[SSPlayController alloc] initWithContentURL:[NSURL fileURLWithPath:media.path]];
  moviePlayer.selectedIndexRow = indexPath.row;
  moviePlayer.delegate = self;
  [self presentMoviePlayerViewControllerAnimated:moviePlayer];
}

#pragma mark - SSPlayControllerDelegate
- (void)SSPlayControllerDidStop:(SSPlayController*)controller {
  [self dismissMoviePlayerViewControllerAnimated];
}

@end
