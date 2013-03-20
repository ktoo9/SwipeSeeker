@interface SSSettingPickerView : UIView <UIPickerViewDataSource, UIPickerViewDelegate>

@property(nonatomic, strong) NSIndexPath* selectedCell;

-(void)reselectInComponent:(NSInteger)component;

- (void)showInWindow:(UIWindow*)window completion:(void (^)(NSArray* selected))aCompletion;
- (void)hide;

@end
