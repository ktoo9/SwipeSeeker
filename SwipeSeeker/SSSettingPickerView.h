#import <UIKit/UIKit.h>

@interface SSSettingPickerView : UIView
<UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIToolbar* _toolbar;
    UIPickerView* _picker;

    NSArray* _settingItems;
    
    NSArray* _items;
    NSArray* _numItems;

    void (^completion)(NSString* selected);
}

@property(nonatomic, strong) NSIndexPath* selectedCell;

-(void)reselectInComponent:(NSInteger)component;

- (void)showInWindow:(UIWindow*)window completion:(void (^)(NSArray* selected))aCompletion;
- (void)hide;

@end
