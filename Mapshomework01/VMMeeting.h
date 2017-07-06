//
//  VMMeeting.h
//  Mapshomework01
//
//  Created by Torris on 5/10/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface VMMeeting : NSObject <MKAnnotation>

@property (assign,nonatomic) CLLocationCoordinate2D coordinate;

@property (strong,nonatomic) UIImage* meetingPhoto;



@end
