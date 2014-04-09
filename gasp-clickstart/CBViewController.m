#import "CBViewController.h"
#import "CBNetworkClient.h"

@interface CBViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webBrowser;
@property (weak, nonatomic) IBOutlet UIPickerView *restaurantList;

@end

@implementation CBViewController


NSArray *restaurants;

//TODO: UPDATE ME TO YOUR REAL APP!
static NSString *const HOST = @"http://gasp.partnerdemo.cloudbees.net";
static NSString *const PUSH_SERVER = @"http://gasp-push-server.partnerdemo.cloudbees.net/apn/register";


/*
 * Initialise the view on loading.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.restaurantList.dataSource = self;
    self.restaurantList.delegate = self;
    [self loadInitialRestaurants];
    //For hard coded testing of registering with the push server
    //[CBViewController registerWithPushServer:@"token-here"];

}


/*
 * Show a web view of the selected restaurant
 */
- (void) loadWebView:(NSString *)urlAddress {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:urlAddress];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self webBrowser] loadRequest:requestObj];
        });
    });
    
}


/*
 * Called to tell cloudbees about this mobile app instance
 */
+ (void) registerWithPushServer:(NSString *)token {
    CBNetworkClient *client = [CBNetworkClient sharedNetworkClient];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[client registerForPush:PUSH_SERVER withToken:token] start];
    });
}


- (void)loadInitialRestaurants {    
    CBNetworkClient *client = [CBNetworkClient sharedNetworkClient];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *data = [client listRestaurants:HOST];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data != nil) {
                restaurants = data;
                [[self restaurantList] reloadAllComponents];
            } else {
                [CBViewController showMessage:@"Unable to contact server"
                          message:@"Please check the address of the Gasp! server"];
            }
        });
    });
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *website = [[restaurants objectAtIndex:row] valueForKey:@"website"];
    [self loadWebView:website];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [restaurants count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[restaurants objectAtIndex:row] valueForKey:@"name"];
}


/*
 * this is a placeholder for a method that you can unit tests
 * even if it is in a controller 
 */
- (NSString *)hello:(NSString *)name more:(NSString *)more {
    return name;
}


/*
 * Simple message popup
 */
+ (void) showMessage:(NSString *)heading message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:heading
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];

}

@end
