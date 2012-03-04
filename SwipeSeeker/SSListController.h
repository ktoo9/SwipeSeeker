#import <UIKit/UIKit.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAsset.h>
#import "SSPlayController.h"

@interface SSListController : UITableViewController
{
    NSArray* _items;
	SSPlayController* moviePlayer;
}

@property(nonatomic, strong) NSArray* items;

@end
