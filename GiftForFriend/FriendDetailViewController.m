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
@property (strong, nonatomic) IBOutlet UILabel *countDay;
@property (strong, nonatomic) IBOutlet UIImageView *coverPic;
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
    NSString *url_Img1 = self.userData[0][@"pic_cover"][@"source"];
    
    NSLog(@"Show url_Img_FULL: %@",url_Img1);
    self.coverPic.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url_Img1]]];
}

-(void)setFriendLike:(NSArray *)friendData{
    NSLog(@"setFriendLike");
    self.userLike = friendData;

    int i = 0;
    NSMutableArray *userLikeArray = [[NSMutableArray alloc] init];
    for (NSDictionary *groupDic in self.userLike){
        NSLog(@"i = %d", i);
        NSArray *userLikeDetailArray = [[NSArray alloc] initWithObjects:self.userLike[i][@"type"],@"",nil];
        [userLikeArray addObject:userLikeDetailArray];
        i++;
    }
//    int i = 0;
//    NSMutableArray *userLikeArray = [[NSMutableArray alloc] init];
//    while(![self.userLike[i][@"type"] isEqualToString:@""]){
//        NSLog(@"get obj[%d] : %@ : %@ : %lu", i, self.userLike[i][@"type"], self.userLike[i][@"page_id"], (unsigned long)userLikeArray.count);
//        NSArray *userLikeDetailArray = [[NSArray alloc] initWithObjects:self.userLike[i][@"type"],@"",nil];
//        [userLikeArray addObject:userLikeDetailArray];
//        i++;
//    }
    
    NSLog(@"userLikeArray : %lu", (unsigned long)userLikeArray.count);
    NSLog(@"setFriendLike Done !!!!!!!!!!!!!!!!!!!!!!");
}

-(NSArray *)getFriendDetailData:(NSString *)aUID{
    NSLog(@"getFriendData");
    NSArray *result;
    NSString *query = [NSString stringWithFormat:
    @"SELECT uid, name, pic_square, birthday, pic_cover FROM user WHERE uid = %@", aUID];
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

-(NSArray *)getFriendLikePage:(NSString *)aUID{
    NSLog(@"getFriendLikePage");
    NSArray *result;
    NSString *query = [NSString stringWithFormat:
                       @"SELECT uid, page_id, type from page_fan where uid = %@", aUID];
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
                                  [self setFriendLike:friendInfo];
                              }
                          }];
    
    NSLog(@"getFriendLikePage Done");
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
    [self getFriendDetailData:userID];
    [self getFriendLikePage:userID];
    NSLog(@"viewDidLoad Done");
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
