//
//  UIView+MKAnnotationView.h
//  Mapshomework01
//
//  Created by Torris on 5/11/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <MapKit/MKAnnotationView.h>

@class MKAnnotationView;

@interface UIView (MKAnnotationView)

- (MKAnnotationView*) superAnnotationView;

@end
