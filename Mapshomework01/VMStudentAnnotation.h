//
//  VMStudentAnnotation.h
//  Mapshomework01
//
//  Created by Torris on 5/9/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>


@interface VMStudentAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;



@end
