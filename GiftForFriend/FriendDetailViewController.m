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
@property (strong, nonatomic) IBOutlet UILabel *firstLike;
@property (strong, nonatomic) IBOutlet UILabel *secondLike;
@property (strong, nonatomic) IBOutlet UILabel *thirdLike;
@property (strong, nonatomic) IBOutlet UILabel *thirdLikeTitle;
@property (strong, nonatomic) IBOutlet UIImageView *coverPic;
@end

@implementation FriendDetailViewController

@synthesize userID;

-(void)setFriendData:(NSArray *)friendData{
    NSLog(@"setFriendData");
    self.userData = friendData;
    self.profilePictureView.profileID = self.userID;
    self.userName.text = self.userData[0][@"name"];
    self.userBD.text = self.userData[0][@"birthday_date"];
    
    NSInteger timeDiff = [self compareTime:[self formatBD:self.userData[0][@"birthday_date"]]];
    self.countDay.text = [NSString stringWithFormat:@"%ld", (long)timeDiff];
    
    NSLog(@"setFriendData 1");
    if (![[self.userData[0][@"pic_cover"] description] isEqualToString:@"<null>"]){
        NSString *url_Img1 = self.userData[0][@"pic_cover"][@"source"];
        self.coverPic.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url_Img1]]];
    }else{
        NSLog(@"pic null");
    }
    NSLog(@"setFriendData 2");
    
}

-(void)setFriendLike:(NSArray *)friendData{
    NSLog(@"setFriendLike");
    self.userLike = friendData;

    NSMutableArray *userLikeArray = [[NSMutableArray alloc] init];
    for (NSDictionary *groupDic in self.userLike){
//        NSLog(@"groupDic :%@", [groupDic description]);
        FBUserLike *aUserLike = [[FBUserLike alloc] initWithUserLike:groupDic[@"page_id"]
                                                             andType:groupDic[@"type"]
                                                              anduid:groupDic[@"uid"]];
        [userLikeArray addObject:aUserLike];
    }
    
    NSMutableArray *userLikeTemp = [[NSMutableArray alloc] init];
    Boolean haveThis = false;
    for (FBUserLike *obj in userLikeArray){
        NSString *aType = obj.type;
        for (FBUserLikeFreq *obj2 in userLikeTemp){
            if ([aType isEqualToString:obj2.type]){
                haveThis = true;
                obj2.freq++;
            }
        }
        if (haveThis == true){
            
        }else{
//            NSLog(@"add object : %@", aType);
            FBUserLikeFreq *aUser = [[FBUserLikeFreq alloc] initWithUserLike:aType andFreq:1];
            [userLikeTemp addObject:aUser];
        }
        haveThis = false;
        
    }
//    NSLog(@"Done Done");
    if (userLikeTemp.count == 1){
        FBUserLikeFreq *obj1 = userLikeTemp[0];
        self.firstLike.text = obj1.type;
        self.secondLike.hidden = true;
        self.thirdLike.hidden = true;
        self.thirdLikeTitle.hidden = true;
        
    }else if (userLikeTemp.count == 2){
        FBUserLikeFreq *obj1 = userLikeTemp[0];
        FBUserLikeFreq *obj2 = userLikeTemp[1];
        if (obj1.freq > obj2.freq){
            self.firstLike.text = obj1.type;
            self.secondLike.text = obj2.type;
            self.thirdLike.hidden = true;
            self.thirdLikeTitle.hidden = true;
            
        }else{
            self.firstLike.text = obj2.type;
            self.secondLike.text = obj1.type;
            self.thirdLike.hidden = true;
            self.thirdLikeTitle.hidden = true;
        }
        
    }else {
        [userLikeTemp sortUsingComparator:^NSComparisonResult(FBUserLikeFreq *obj1, FBUserLikeFreq *obj2){
            return obj2.freq - obj1.freq;
        }];
        FBUserLikeFreq *obj1 = userLikeTemp[0];
        FBUserLikeFreq *obj2 = userLikeTemp[1];
        FBUserLikeFreq *obj3 = userLikeTemp[2];
        
        self.firstLike.text = obj1.type;
        self.secondLike.text = obj2.type;
        self.thirdLike.text = obj3.type;
    }
//    NSLog(@"setFriendLike Done !!!!!!!!!!!!!!!!!!!!!!");
    
}

-(NSArray *)getFriendDetailData:(NSString *)aUID{
    NSLog(@"getFriendData");
    NSArray *result;
    NSString *query = [NSString stringWithFormat:
    @"SELECT uid, name, pic_square, birthday_date, pic_cover FROM user WHERE uid = %@", aUID];
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
//                                  NSLog(@"Result: %@", result);
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

-(NSInteger)compareTime:(NSString *)aDate{
//    NSLog(@"compareTime : %@", aDate);
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd"];
    
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"US/Pacific"]];
    
    NSString *melbourneTime = [dateFormatter stringFromDate:date];
    
    NSDate *startDate = [dateFormatter dateFromString:melbourneTime];
    NSDate *endDate = [dateFormatter dateFromString:aDate];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    NSLog(@"Current Time : %@", melbourneTime);
    NSLog(@"User Birthday : %@", aDate);
    NSLog(@"Day Diff : %ld", (long)[components day]);
//    NSInteger timeDiff = [components day];
    return [components day];

}

-(NSString *)formatBD:(NSString *)aDate{
//    NSLog(@"formatBD : %@",aDate);
    
    NSArray* components = [aDate componentsSeparatedByString:@"/"];
//    NSString* month = [components objectAtIndex:0];
//    NSString* day = [components objectAtIndex:1];
    NSString *birthday = [NSString stringWithFormat:@"%@-%@",[components objectAtIndex:0],[components objectAtIndex:1]];
//    NSLog(@"formatBD MyDate : %@",birthday);

    return birthday;
}
@end
