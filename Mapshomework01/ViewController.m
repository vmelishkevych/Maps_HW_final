//
//  ViewController.m
//  Mapshomework01
//
//  Created by Torris on 5/9/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

#import "ViewController.h"
#import "VMStudent.h"
#import "VMStudentAnnotation.h"
#import "VMTableViewController.h"
#import "VMMeeting.h"
#import "UIView+MKAnnotationView.h"


#import <MapKit/MapKit.h>


typedef NS_ENUM (NSInteger, VMChanceLevel)  {
    
    VMChanceLevelLow,
    VMChanceLevelMiddle,
    VMChanceLevelHight
    
};




@interface ViewController ()

@property (strong,nonatomic) NSMutableArray* studentsArray;
@property (strong,nonatomic) CLGeocoder* geocoder;
@property (strong,nonatomic) MKDirections* directions;


@property (strong,nonatomic) NSMutableArray* smallCircleArray;
@property (strong,nonatomic) NSMutableArray* middleCircleArray;
@property (strong,nonatomic) NSMutableArray* largeCircleArray;

@property (assign,nonatomic) CLLocationDistance smallCircleRadius;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.studentsArray = [NSMutableArray array];
    
    self.smallCircleArray = [NSMutableArray array];
    self.middleCircleArray = [NSMutableArray array];
    self.largeCircleArray = [NSMutableArray array];
    
    self.smallCircleRadius = 5000.f;
    
    self.geocoder = [[CLGeocoder alloc] init];
    
    
    
    CLLocationCoordinate2D myLocation = CLLocationCoordinate2DMake(50.45466, 30.5238);
    
    MKCoordinateSpan mySpan = MKCoordinateSpanMake(0.2, 0.2);
    
    MKCoordinateRegion myRegion = MKCoordinateRegionMake(myLocation, mySpan);
    
    myRegion = [self.mapView regionThatFits:myRegion];
    
    [self.mapView setRegion:myRegion];

    

    
    UIBarButtonItem* showAllButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                  target:self
                                                                                  action:@selector(actionShowAll:)];
    
    
    UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                   target:self
                                                                                   action:@selector(actionAdd:)];
    
    
    UIBarButtonItem* meetingButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                                   target:self
                                                                                   action:@selector(actionOnMeeting:)];
    
    UIBarButtonItem* routeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                                                                                   target:self
                                                                                 action:@selector(actionRoute:)];

    
    
    
    self.navigationItem.rightBarButtonItems = @[showAllButton, addButton];
    
    self.navigationItem.leftBarButtonItems = @[meetingButton, routeButton];
    
    
    
    
}


- (void)dealloc

{
    if ([self.geocoder isGeocoding]) {
        
        [self.geocoder cancelGeocode];
    }
    
    if ([self.directions isCalculating]) {
        
        [self.directions cancel];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void) actionRoute:(UIBarButtonItem*) sender {
    

    
    if (self.mapView.overlays.count > 0 ) {
        
        for (id <MKOverlay> overlay in self.mapView.overlays) {
            
            if ([overlay isKindOfClass:[MKPolyline class]]) {
                
                [self.mapView removeOverlay:overlay];
                
            }
        }
    }
    
    
    NSArray* allStudentsArray = @[self.smallCircleArray, self.middleCircleArray, self.largeCircleArray];
    
    NSMutableArray* choosingStudentsArray = [NSMutableArray array];
    
    for (NSArray* currentArray in allStudentsArray) {
        
        if (currentArray.count > 0) {
            
            if ([currentArray isEqual:self.smallCircleArray]) {
                
                [choosingStudentsArray addObjectsFromArray:[self chooseStudentsFromArray:currentArray withChanceLevel:VMChanceLevelHight]];
                
                
            } else if ([currentArray isEqual:self.middleCircleArray]) {
                
                [choosingStudentsArray addObjectsFromArray:[self chooseStudentsFromArray:currentArray withChanceLevel:VMChanceLevelMiddle]];
                
            } else if ([currentArray isEqual:self.largeCircleArray]) {
                
                [choosingStudentsArray addObjectsFromArray:[self chooseStudentsFromArray:currentArray withChanceLevel:VMChanceLevelLow]];
                
            }
            
        }
        
        
    }
    
    for (VMStudent* student in choosingStudentsArray) {
        
        [self makeRouteForCoordinate:student.coordinate];
        
    }
    
    
}



- (void) actionInfo:(UIButton*) sender {
    
    MKAnnotationView* annotationView = [sender superAnnotationView];
    
    if (!annotationView) {
        return;
    }
    
    if ([annotationView.annotation isKindOfClass:[VMStudent class]]) {
        
        if ([self.geocoder isGeocoding]) {
            
            [self.geocoder cancelGeocode];
        }
        
        
        VMStudent* student = (VMStudent*)[annotationView annotation];
        
        CLLocation* location = [[CLLocation alloc] initWithLatitude:student.coordinate.latitude
                                                          longitude:student.coordinate.longitude];
        
        [self.geocoder reverseGeocodeLocation:location
                            completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                                
                                NSString* message = nil;
                                
                                if (!error && placemarks.count > 0) {
                                    
                                    CLPlacemark* placeMark = [placemarks firstObject];
                                    
                                    message = [NSString stringWithFormat:@"%@ %@, %@, %@, %@",
                                               placeMark.thoroughfare,
                                               placeMark.subThoroughfare,
                                               placeMark.locality,
                                               placeMark.administrativeArea,
                                               placeMark.country];
                                    
                                } else {
                                    
                                    message = @"Adress is not found";
                                    
                                }
                                
                                UINavigationController* nav = [self.storyboard instantiateViewControllerWithIdentifier:@"UINavigationController"];
                                
                                VMTableViewController* tableController = [nav.viewControllers firstObject];
                                
                                tableController.studentTitle = student.title;
                                tableController.studentBirthDate = student.subtitle;
                                tableController.studentGender = student.genderType;
                                tableController.studentAdress = message;
                                
                                [self showPopoverController:nav withAnchor:sender];
                                
                            }];
        
    }
    

    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
            
            [[UIApplication sharedApplication]  endIgnoringInteractionEvents];
        }
    });
  
}


- (void) actionOnMeeting:(UIBarButtonItem*) sender {

    BOOL isMeeting = NO;
    
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        
        if ([annotation isKindOfClass:[VMMeeting class]]) {
            
            isMeeting = YES;
            
            break;
        }
    }
    
    if (!isMeeting) {
        
        MKCoordinateRegion region = self.mapView.region;
        
        
        
        VMMeeting* meeting = [[VMMeeting alloc] init];
        
        meeting.coordinate = [self chooseCoordinateForRegion:region];
        
        [self.mapView addAnnotation:meeting];
        
        
        [self makeCircleOverlaysForCoordinate:meeting.coordinate withRadius:self.smallCircleRadius];
        
        [self countStudentsPerCirclesWithCenter:meeting.coordinate];
        
    }
    
}


- (void) actionAdd:(UIBarButtonItem*) sender {
    
    MKCoordinateRegion region = self.mapView.region;
    
    
    for (NSInteger i = 0; i < 10; i++) {
        
        VMStudent* student = [[VMStudent alloc] init];
        
        student.coordinate = [self chooseCoordinateForRegion:region];
        
       
        [self.studentsArray addObject:student];
        
        [self.mapView addAnnotation:student];
    }
    
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        
        if ([annotation isKindOfClass:[VMMeeting class]]) {
            
            [self countStudentsPerCirclesWithCenter:[(VMMeeting*)annotation coordinate]];
            
            break;
        }
        
    }
}


- (void) actionShowAll:(UIBarButtonItem*) sender {
    
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
    
}



#pragma mark - Help Methods

- (NSArray*) chooseStudentsFromArray:(NSArray*) sourceArray withChanceLevel:(VMChanceLevel) chanceLevel {
    
    NSMutableArray* destinationArray = [NSMutableArray array];
    
    NSInteger currentCount = sourceArray.count;
    
    switch (chanceLevel) {
            
        case VMChanceLevelLow:
            currentCount = sourceArray.count * 0.1;
            break;

        case VMChanceLevelMiddle:
            currentCount = sourceArray.count * 0.5;
            break;
     
        case VMChanceLevelHight:
            currentCount = sourceArray.count * 0.9;
            break;

        default:
            break;
    
    }
    
    if (currentCount) {
        
        while (destinationArray.count < currentCount) {
            
            VMStudent* student = [sourceArray objectAtIndex:arc4random() % sourceArray.count];
            
            [destinationArray addObject:student];
        }

        
    }
    
            return destinationArray;
    
}


- (void) makeRouteForCoordinate:(CLLocationCoordinate2D) coordinate {
    
    if ([self.directions isCalculating]) {
        
        [self.directions cancel];
    }
    
    
    CLLocationCoordinate2D center = self.mapView.region.center;
    
    
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        
        if ([annotation isKindOfClass:[VMMeeting class]]) {
            
            center = [(VMMeeting*)annotation coordinate];
            
            break;
        }
    }
    
    
    MKPlacemark* source = [[MKPlacemark alloc] initWithCoordinate:coordinate];
    
    MKPlacemark* destination = [[MKPlacemark alloc] initWithCoordinate:center];
    
    
    
    MKMapItem* sourceItem = [[MKMapItem alloc] initWithPlacemark:source];
    
    MKMapItem* destinationItem = [[MKMapItem alloc] initWithPlacemark:destination];
    
    
    MKDirectionsRequest* request = [[MKDirectionsRequest alloc] init];
    
    request.source = sourceItem;
    
    request.destination = destinationItem;
    
    request.transportType = MKDirectionsTransportTypeWalking;
    
    
    self.directions = [[MKDirections alloc] initWithRequest:request];
    
    [self.directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString* message = nil;
        
        if (error) {
            
            message = [error localizedDescription];
            
            [self showAlertWithTitle:@"Error" andMessage:message];
            
        } else if (response.routes.count == 0) {
            
            message = @"Route is not found";
            
            [self showAlertWithTitle:@"Warning:" andMessage:message];
 
            
        } else {
            
            MKRoute* route = [response.routes firstObject];
            
            [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
            
        }
    }];
    
    
}


- (void) countStudentsPerCirclesWithCenter:(CLLocationCoordinate2D) center {
    
    NSArray* array = @[self.smallCircleArray, self.middleCircleArray, self.largeCircleArray];
    
    for (NSMutableArray* mutArray in array) {
        
        [mutArray removeAllObjects];
    }
   

    
    MKMapPoint meetingPoint = MKMapPointForCoordinate(center);
    
    for (VMStudent* student in self.studentsArray) {
        
        MKMapPoint studentPoint = MKMapPointForCoordinate(student.coordinate);
        
        CLLocationDistance distance = MKMetersBetweenMapPoints(meetingPoint, studentPoint);
        
        if (distance <= self.smallCircleRadius) {
            
            [self.smallCircleArray addObject:student];
        }
        
        if (distance > self.smallCircleRadius && distance <= self.smallCircleRadius * 2) {
            
            [self.middleCircleArray addObject:student];
        }
        
        if (distance > self.smallCircleRadius * 2 && distance <= self.smallCircleRadius * 3) {
            
            [self.largeCircleArray addObject:student];
        }
    }
    
    self.smallCircleLabel.text  = [NSString stringWithFormat:@"%ld", self.smallCircleArray.count];
    self.middleCircleLabel.text = [NSString stringWithFormat:@"%ld", self.middleCircleArray.count];
    self.largeCircleLabel.text  = [NSString stringWithFormat:@"%ld", self.largeCircleArray.count];

    
    
    
}



- (void) makeCircleOverlaysForCoordinate:(CLLocationCoordinate2D) coordinate withRadius:(CLLocationDistance) radius {
    
    if (self.mapView.overlays.count > 0 ) {
        
        for (id <MKOverlay> overlay in self.mapView.overlays) {
            
            if ([overlay isKindOfClass:[MKCircle class]] || [overlay isKindOfClass:[MKPolyline class]]) {
                
                [self.mapView removeOverlay:overlay];
                
            }
        }
    }
    
    
    for (int i = 1; i < 4; i++) {
        
        MKCircle* circle = [MKCircle circleWithCenterCoordinate:coordinate
                                                         radius:i * radius];
        
        [self.mapView addOverlay:circle level:MKOverlayLevelAboveRoads];
        
    }

    
    
}



- (CLLocationCoordinate2D) chooseCoordinateForRegion:(MKCoordinateRegion) region {
    
    
    CLLocationCoordinate2D center = region.center;
    
    MKCoordinateSpan span = region.span;
    
    
    CLLocationDegrees latitude = center.latitude + [self randomDeltaForSpan:span.latitudeDelta];
    
    CLLocationDegrees longitude = center.longitude + [self randomDeltaForSpan:span.longitudeDelta];
    
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    return coordinate;
}


- (void) showAlertWithTitle:(NSString*) title andMessage:(NSString*) message {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                     }];
    
    [alert addAction:actionOk];
    
    [self presentViewController:alert
                       animated:YES completion:^{
                           
                       }];
    
    
    
    
}





- (void) showPopoverController:(UIViewController*) nav withAnchor:(UIView*) view {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        nav.preferredContentSize = CGSizeMake(400, 300);
        
        nav.modalPresentationStyle = UIModalPresentationPopover;
        
        [self presentViewController:nav animated:YES completion:nil];
        
        
        UIPopoverPresentationController* popover = nav.popoverPresentationController;
        
        popover.sourceView = view.superview;
        
        CGRect rect = CGRectMake(CGRectGetMinX(view.frame), CGRectGetMinY(view.frame), 22, 22);
        
        popover.sourceRect = rect;
        
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
        
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        [self presentViewController:nav animated:YES completion:nil];
        
        
    }
    
}


- (CLLocationDegrees) randomDeltaForSpan:(CLLocationDegrees) span {
    
    NSInteger deltaMax = (NSInteger)(span * 10000);
    
    NSInteger randomDelta = arc4random() % deltaMax - deltaMax / 2;
    
    CLLocationDegrees delta = ((double)randomDelta) / 10000.f;
    
    return delta;
    
}




#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState {
    
    if (newState == MKAnnotationViewDragStateStarting) {
        
        CLLocationCoordinate2D coordinate = view.annotation.coordinate;
        
        CLLocationDistance radius = 0;
        
        [self makeCircleOverlaysForCoordinate:coordinate withRadius:radius];

    }
    
    
    if (newState == MKAnnotationViewDragStateEnding) {
        
        
        //[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            CLLocationCoordinate2D coordinate = view.annotation.coordinate;
            
            [self makeCircleOverlaysForCoordinate:coordinate withRadius:self.smallCircleRadius];
            
            [self countStudentsPerCirclesWithCenter:coordinate];
            
            /*
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
                
                [[UIApplication sharedApplication]  endIgnoringInteractionEvents];
                
            }
             */
        });
        
    }
}



- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    
    if ([overlay isKindOfClass:[MKCircle class]]) {
        
        MKCircleRenderer* renderer = [[MKCircleRenderer alloc] initWithCircle:overlay];
        
        renderer.lineWidth = 3.f;
        
        renderer.fillColor = [UIColor colorWithRed:0.3 green:0.5 blue:0.7 alpha:0.1];
        
        return renderer;
        
    }

    if ([overlay isKindOfClass:[MKPolyline class]]) {
        
        MKPolylineRenderer* renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        
        renderer.lineWidth = 3.f;
        
        renderer.strokeColor = [UIColor blueColor];
        
        return renderer;
        
    }

    return nil;
    
}


- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        
        return nil;
    
    } else if (([annotation isKindOfClass:[VMStudent class]])) {
        
        
        static NSString* studentIdentifier = @"studentIdentifier";

        MKPinAnnotationView* annotationView = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:studentIdentifier];
        
        
        if (!annotationView) {
            
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:studentIdentifier];
            
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:annotationView.bounds];
            imageView.image = [(VMStudent*)annotation studentPhoto];
            [annotationView addSubview:imageView];

            //annotationView.draggable = YES;
            annotationView.canShowCallout = YES;
           
            UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            
            
            [infoButton addTarget:self
                           action:@selector(actionInfo:)
                 forControlEvents:UIControlEventTouchUpInside];
            
             
            annotationView.rightCalloutAccessoryView = infoButton;
            
            
        } else {
          
            [[annotationView.subviews lastObject] removeFromSuperview];
            
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:annotationView.bounds];
            imageView.image = [(VMStudent*)annotation studentPhoto];
            [annotationView addSubview:imageView];

            annotationView.annotation = annotation;
    
        }
        
        return annotationView;
        
    } else if (([annotation isKindOfClass:[VMMeeting class]])) {
        
        
        static NSString* meetingIdentifier = @"meetingIdentifier";
        
        MKPinAnnotationView* annotationView = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:meetingIdentifier];
        
        
        if (!annotationView) {
            
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:meetingIdentifier];
            
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:annotationView.bounds];
            imageView.image = [(VMMeeting*)annotation meetingPhoto];
            [annotationView addSubview:imageView];
            
            annotationView.draggable = YES;
            //annotationView.canShowCallout = YES;
            
        } else {
            
            annotationView.annotation = annotation;
            
        }
        
        return annotationView;
    }
    
    
    
    else {
        
        
        static NSString* commonIdentifier = @"commonIdentifier";
        
        MKPinAnnotationView* annotationView = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:commonIdentifier];
        
        if (!annotationView) {
            
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:commonIdentifier];
            
            annotationView.pinTintColor = [UIColor blueColor];
            annotationView.animatesDrop = YES;
            annotationView.draggable = YES;
            
            
            UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            annotationView.rightCalloutAccessoryView = infoButton;

            
            
        } else {
            
            annotationView.annotation = annotation;
        }
        
        return annotationView;
        
    }
    
}


@end
