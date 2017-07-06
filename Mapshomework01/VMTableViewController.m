//
//  VMTableViewController.m
//  Mapshomework01
//
//  Created by Torris on 5/10/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

#import "VMTableViewController.h"

@interface VMTableViewController ()

@end

@implementation VMTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        [self.cancelBarButton setEnabled:NO];
    
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.titleLabel.text = self.studentTitle;
    self.birthDateLabel.text = self.studentBirthDate;
    self.genderLabel.text = self.studentGender;
    self.adressLabel.text = self.studentAdress;
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)actionCancelBarButton:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
