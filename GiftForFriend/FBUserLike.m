//
//  FBUserLike.m
//  GiftForFriend
//
//  Created by Chang-Che Lu on 4/18/14.
//  Copyright (c) 2014 Chang-Che Lu. All rights reserved.
//

#import "FBUserLike.h"

@implementation FBUserLike
@synthesize page_id;
@synthesize type;
@synthesize uid;

- (id) initWithUserLike: (NSString*) thePage_id andType:(NSString*) theType anduid: (NSString*) theUid{
    
    self = [super init];
    if (self){
        page_id = thePage_id;
        type = theType;
        uid = theUid;
    }
    return self;
}

@end
