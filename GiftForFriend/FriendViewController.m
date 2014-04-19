//
//  FriendViewController.m
//  GiftForFriend
//
//  Created by Chang-Che Lu on 3/27/14.
//  Copyright (c) 2014 Chang-Che Lu. All rights reserved.
//

#import "FriendViewController.h"
#import "FriendDetailViewController.h"
#import "ViewController.h"


@interface FriendViewController ()
@property (strong, nonatomic) UIToolbar *toolbar;
@property (strong, nonatomic) UILabel *friendName;
@property (strong, nonatomic) NSString *selectedID;
@end

@implementation FriendViewController


#pragma mark - Helper methods

-(void)setFriendData:(NSArray *)friendData{
//    NSLog(@"setFriendData");
     self.userData = friendData;
    [self.tableView reloadData];
}

-(NSArray *)getFriendData{
    NSLog(@"getFriendData : %@",[self getCurrentMonthDay]);
    // Query to fetch the active user's friends, limit to 25.
    NSLog(@"getFriendData");
    NSArray *result;
    NSString *query = [NSString stringWithFormat:
    @"SELECT uid, name, pic_square,birthday_date FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me()) AND birthday_date != \"\""
    @"AND birthday_date > '%@' ORDER BY birthday_date ASC", [self getCurrentMonthDay]];
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
                                  [self setFriendData:friendInfo];
                              }
                          }];

    NSLog(@"getFriendData Done");
    return result;
}
/*
 * Method triggered by a Done button that dismisses this controller
 */
- (void)doneButtonPressed:(id)sender
{
    // Dismiss view controller
//    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
//    [self presentViewController:vc animated:NO completion:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
    NSLog(@"doneButtonPressed");

}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    
    //get userData
    self.userData = [self getFriendData];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
//    NSLog(@"numberOfSectionsInTableView");
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSLog(@"numberOfRowsInSection : %lu", (unsigned long)[self.userData count]);
    return [self.userData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"cellForRowAtIndexPath");
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = self.userData[indexPath.row][@"name"];
    cell.detailTextLabel.text = self.userData[indexPath.row][@"birthday_date"];
    UIImage *image = [UIImage imageWithData:
                      [NSData dataWithContentsOfURL:
                       [NSURL URLWithString:
                        self.userData[indexPath.row][@"pic_square"]]]];
    
    cell.imageView.image = image;
    
    return cell;
}

#pragma mark - Table view delegate
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return self.toolbar;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return self.toolbar.frame.size.height;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    self.selectedID = self.userData[indexPath.row][@"uid"];
    NSLog(@"selected id : %@", self.selectedID);
    [self performSegueWithIdentifier:@"goToDetail" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    NSLog(@"prepareForSegue: %@", segue.identifier);
//    [segue FriendDetailViewController];
    NSLog(@"prepareForSegue");
    NSLog(@"prepareForSegue: %@", segue.identifier);
    FriendDetailViewController *destinVC = segue.destinationViewController;
    destinVC.userID = self.selectedID;
    
}

-(NSString*)getCurrentMonthDay{
    NSLog(@"getCurrentMonthDay");
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    //    self.TimeLabel.text = dateString;
    
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"US/Pacific"]];
    //    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"America/New_York"]];
    
    NSString *melbourneTime = [dateFormatter stringFromDate:date];
    NSLog(@"getCurrentMonthDay : %@", melbourneTime);
    
    return melbourneTime;
}

@end
