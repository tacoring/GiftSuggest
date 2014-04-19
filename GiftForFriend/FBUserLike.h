//
//  FBUserLike.h
//  GiftForFriend
//
//  Created by Chang-Che Lu on 4/18/14.
//  Copyright (c) 2014 Chang-Che Lu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBUserLike : NSObject

@property (nonatomic, retain, readonly) NSString* page_id;
@property (nonatomic, retain, readonly) NSString* type;
@property (nonatomic, retain, readonly) NSString* uid;

- (id) initWithUserLike: (NSString*) thePage_id andType:(NSString*) theType anduid: (NSString*) theUid;

@end
