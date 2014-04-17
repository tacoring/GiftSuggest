//
//  FriendViewController.h
//  GiftForFriend
//
//  Created by Chang-Che Lu on 3/27/14.
//  Copyright (c) 2014 Chang-Che Lu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendDetailViewController.h"

//@class FriendViewController;
//
//@protocol FriendViewControllerDelegate <NSObject>
//
////- (void)addItemViewController:(FriendViewController *)controller didFinishEnteringItem:(NSString *)item;
////-(void)selectedValueIs:(NSString *)value;
//@end


@interface FriendViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *userData;
//@property (nonatomic, weak) id <FriendViewControllerDelegate> delegate;

@end
