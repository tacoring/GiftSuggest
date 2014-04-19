//
//  FBUserLikeFreq.h
//  GiftForFriend
//
//  Created by Chang-Che Lu on 4/18/14.
//  Copyright (c) 2014 Chang-Che Lu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBUserLikeFreq : NSObject

@property (nonatomic, retain, readonly) NSString* type;
@property (nonatomic) int freq;


- (id) initWithUserLike: (NSString*) theType andFreq:(int) theFreq ;

@end
