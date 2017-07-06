//
//  UIView+MKAnnotationView.m
//  Mapshomework01
//
//  Created by Torris on 5/11/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

#import "UIView+MKAnnotationView.h"
#import <MapKit/MKAnnotationView.h>

@implementation UIView (MKAnnotationView)

- (MKAnnotationView*) superAnnotationView {
    
    if ([self isKindOfClass:[MKAnnotationView class]]) {
        
        return (MKAnnotationView*)self;
    }
    
    
    if (!self.superview) {
        
        return nil;
        
    }
        
        return [self.superview superAnnotationView];
        
}


@end
