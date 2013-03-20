@interface SSPlayController : MPMoviePlayerViewController

@property (nonatomic, weak) id delegate;
@property(nonatomic) int selectedIndexRow;

@end

@interface NSObject (SSPlayControllerDelegate)

- (void)SSPlayControllerDidStop:(SSPlayController*)controller;

@end
