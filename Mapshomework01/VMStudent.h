//
//  VMStudent.h
//  TableSearchHomework01
//
//  Created by Torris on 4/28/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>



@interface VMStudent : NSObject <MKAnnotation>

@property (copy,nonatomic) NSString* title;
@property (copy,nonatomic) NSString* subtitle;
@property (assign,nonatomic) CLLocationCoordinate2D coordinate;

@property (strong,nonatomic) NSString* genderType;
@property (strong,nonatomic) UIImage* studentPhoto;

@end

