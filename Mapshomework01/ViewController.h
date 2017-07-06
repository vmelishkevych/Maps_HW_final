//
//  ViewController.h
//  Mapshomework01
//
//  Created by Torris on 5/9/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKMapView;

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@property (weak, nonatomic) IBOutlet UILabel *smallCircleLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleCircleLabel;
@property (weak, nonatomic) IBOutlet UILabel *largeCircleLabel;




@end

