//
//  FriendDetailViewController.m
//  GiftForFriend
//
//  Created by Chang-Che Lu on 3/27/14.
//  Copyright (c) 2014 Chang-Che Lu. All rights reserved.
//

#import "FriendDetailViewController.h"

@interface FriendDetailViewController ()
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
//@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *userBD;
@end

@implementation FriendDetailViewController

@synthesize userID;

-(void)setFriendData:(NSArray *)friendData{
    NSLog(@"setFriendData");
    self.userData = friendData;
//    for (int i = 0 ; i < self.userData.count ; i ++){
//        NSLog(@" Detail data : %@", self.userData[i]);
//    }
    self.profilePictureView.profileID = self.userID;
    self.userName.text = self.userData[0][@"name"];
    self.userBD.text = self.userData[0][@"birthday"];
}

-(NSArray *)getFriendDetailData:(NSString *)aUID{
    // Query to fetch the active user's friends, limit to 25.
    NSLog(@"getFriendData");
    NSArray *result;
    NSString *query = [NSString stringWithFormat:
    @"SELECT uid, name, pic_square,birthday FROM user WHERE uid = %@", aUID];
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
                                  result = friendInfo;
                                  // Show the friend details display
                                  [self setFriendData:friendInfo];
                              }
                          }];
    
    NSLog(@"getFriendDetailData Done");
    return result;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.friendName = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 200, 100)];
//    self.friendName.text = userID;
//    [self.view addSubview:self.friendName];
    [self getFriendDetailData:userID];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
