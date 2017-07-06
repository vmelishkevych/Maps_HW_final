//
//  VMTableViewController.h
//  Mapshomework01
//
//  Created by Torris on 5/10/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VMTableViewController : UITableViewController

@property (strong,nonatomic) NSString* studentTitle;
@property (strong,nonatomic) NSString* studentBirthDate;
@property (strong,nonatomic) NSString* studentGender;
@property (strong,nonatomic) NSString* studentAdress;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;



@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelBarButton;

- (IBAction)actionCancelBarButton:(UIBarButtonItem *)sender;



@end
