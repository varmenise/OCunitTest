@interface CBViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

- (NSString *)hello:(NSString *)name more:(NSString *)more;
+ (void) registerWithPushServer:(NSString *)token;
+ (void) showMessage:(NSString *)heading message:(NSString *)message;


@end
