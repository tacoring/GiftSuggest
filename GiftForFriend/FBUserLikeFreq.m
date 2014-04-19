//
//  FBUserLikeFreq.m
//  GiftForFriend
//
//  Created by Chang-Che Lu on 4/18/14.
//  Copyright (c) 2014 Chang-Che Lu. All rights reserved.
//

#import "FBUserLikeFreq.h"

@implementation FBUserLikeFreq
@synthesize type;
@synthesize freq;


- (id) initWithUserLike: (NSString*) theType andFreq:(int) theFreq{
    self = [super init];
    if (self){
        type = theType;
        freq = theFreq;
    }
    return self;
    
}

@end
