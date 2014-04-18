//
//  FriendDetailViewController.h
//  GiftForFriend
//
//  Created by Chang-Che Lu on 3/27/14.
//  Copyright (c) 2014 Chang-Che Lu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FriendDetailViewController : UIViewController
@property (strong, nonatomic) UILabel *friendName;
@property (strong, nonatomic) NSArray *userData;
@property (strong, nonatomic) NSArray *userLike;
@property (strong, nonatomic) NSString *userID;
@end
