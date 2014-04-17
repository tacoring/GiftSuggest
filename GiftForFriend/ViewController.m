//
//  ViewController.m
//  GiftForFriend
//
//  Created by Chang-Che Lu on 3/12/14.
//  Copyright (c) 2014 Chang-Che Lu. All rights reserved.
//
#import <FacebookSDK/FacebookSDK.h>
#import "ViewController.h"

#import "AppDelegate.h"


@interface ViewController ()
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic) BOOL isLogin;
@property (strong, nonatomic) IBOutlet UIButton *query;
@property (strong, nonatomic) UIToolbar *toolbar;

@end

@implementation ViewController

@synthesize testString;


- (void)addItemViewController:(FriendViewController *)controller didFinishEnteringItem:(NSString *)item
{
    NSLog(@"This was returned from FriendViewController %@",item);
}

#pragma mark - Helper methods

/*
 * Present the friend details display view controller
 */
- (void)showFriends:(NSArray *)friendData
{
    // Set up the view controller that will show friend information
    FriendViewController *viewController = [[FriendViewController alloc] initWithStyle:UITableViewStylePlain];
    viewController.userData = friendData;
    // Present view controller modally.
    [self presentViewController:viewController animated:YES completion:nil];
}

-(void)selectedValueIs:(NSString *)value
{
        // do whatever you want with the value string
    NSLog(@"what is isi isi  : %@", value);
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    self.isLogin = false;
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"viewDidLoad testString: %@", testString);
    [self init];
//    [self getCurrentTime];
    
    
//    self.navigationController.toolbarHidden = NO;
//    self.navigationController.navigationBarHidden = NO;
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if (self.isLogin){
        self.query.hidden = true;
    }else{
        self.query.hidden = true;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"didReceiveMemoryWarning");
}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
-(id)init
{
    
    NSLog(@"initWithNibName");
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"self");
        // Create a FBLoginView to log the user in with basic, email and likes permissions
        // You should ALWAYS ask for basic permissions (basic_info) when logging the user in
        FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"basic_info", @"email", @"user_likes",
                                                                                @"user_birthday", @"friends_birthday"]];
        
        // Set this loginUIViewController to be the loginView button's delegate
        loginView.delegate = self;
        
        // Align the button in the center horizontally
        loginView.frame = CGRectOffset(loginView.frame,
                                       (self.view.center.x - (loginView.frame.size.width / 2)),
                                       self.view.center.y + (loginView.frame.size.width / 2));
        
        // Align the button in the center vertically
//        loginView.center = self.view.center;
        
        // Add the button to the view
        [self.view addSubview:loginView];
        
    }
    return self;
}

// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    self.profilePictureView.profileID = user.id;
    self.nameLabel.text = user.name;
}

// Implement the loginViewShowingLoggedInUser: delegate method to modify your app's UI for a logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    self.statusLabel.text = @"You're logged in as";
    self.isLogin = true;
    self.query.hidden = true;

    
     
    
}

// Implement the loginViewShowingLoggedOutUser: delegate method to modify your app's UI for a logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.profilePictureView.profileID = nil;
    self.nameLabel.text = @"";
    self.statusLabel.text= @"You're not logged in!";
    self.isLogin = false;
    self.query.hidden = true;

}

// You need to override loginView:handleError in order to handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures since that happen outside of the app.
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (IBAction)queryFriendPressed:(id)sender {
    // Query to fetch the active user's friends, limit to 25.
    NSLog(@"queryFriendPressed");
    NSString *query =
    @"SELECT uid, name, pic_square,birthday FROM user WHERE uid IN "
    @"(SELECT uid2 FROM friend WHERE uid1 = me() limit 5) AND birthday != \"\"";
    // Set up the query parameter
    NSDictionary *queryParam = @{ @"q": query };
    // Make the API request that uses FQL
    [FBRequestConnection startWithGraphPath:@"/fql"
                                 parameters:queryParam
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              if (error) {
                                  NSLog(@"Error: %@", [error localizedDescription]);
                              } else {
                                  NSLog(@"Result: %@", result);
                                  // Get the friend data to display
                                  NSArray *friendInfo = (NSArray *) result[@"data"];
                                  // Show the friend details display
                                  [self showFriends:friendInfo];
                              }
                          }];
}

-(void)getCurrentTime{
    NSLog(@"getCurrentTime");
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:date];
//    self.TimeLabel.text = dateString;
    
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"US/Pacific"]];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"America/New_York"]];
    
    NSString *melbourneTime = [dateFormatter stringFromDate:date];
    NSLog(@"Current Time : %@", melbourneTime);
    
}
@end
