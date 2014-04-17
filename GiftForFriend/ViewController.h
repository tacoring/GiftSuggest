//
//  ViewController.h
//  GiftForFriend
//
//  Created by Chang-Che Lu on 3/12/14.
//  Copyright (c) 2014 Chang-Che Lu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "FriendViewController.h"

@interface ViewController : UIViewController <FBLoginViewDelegate>
@property (strong, nonatomic) NSString *testString;
@end
