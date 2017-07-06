//
//  VMMeeting.m
//  Mapshomework01
//
//  Created by Torris on 5/10/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

#import "VMMeeting.h"

@implementation VMMeeting

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.meetingPhoto = [UIImage imageNamed:@"meeting.png"];
        
    }
    return self;
}


@end
