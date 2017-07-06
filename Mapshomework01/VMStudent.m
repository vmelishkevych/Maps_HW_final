//
//  VMStudent.m
//  TableSearchHomework01
//
//  Created by Torris on 4/28/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

#import "VMStudent.h"
#import <MapKit/MapKit.h>



@implementation VMStudent




NSString* const genderMale = @"Male";
NSString* const genderFemale = @"Female";



NSString* femaleNames[] = {
    @"Lenore", @"Fredda", @"Katrice",
    @"Nellie", @"Vanetta", @"Rosanna",
    @"Eufemia", @"Britteny", @"Telma",
    @"Tracy", @"Tresa", @"Mireille",
    @"Elise", @"Savanna", @"Arvilla",
    @"Whitney", @"Tandra", @"Jenise",
    @"Elenor", @"Jessie"
};

NSString* maleNames[] = {
    @"Tran", @"Bud", @"Hildegard", @"Rupert",
    @"Billie", @"Taylor", @"Ben", @"Colton",
    @"Willard", @"Roman", @"Pierre", @"Floyd",
    @"Norbert", @"Brent"
};


NSString* lastNames[] = {
    
    @"Farrah", @"Laviolette", @"Heal", @"Sechrest", @"Roots",
    @"Homan", @"Starns", @"Oldham", @"Yocum", @"Mancia",
    @"Prill", @"Lush", @"Piedra", @"Castenada", @"Warnock",
    @"Vanderlinden", @"Simms", @"Gilroy", @"Brann", @"Bodden",
    @"Lenz", @"Gildersleeve", @"Wimbish", @"Bello", @"Beachy",
    @"Jurado", @"William", @"Beaupre", @"Dyal", @"Doiron",
    @"Plourde", @"Bator", @"Krause", @"Odriscoll", @"Corby",
    @"Waltman", @"Michaud", @"Kobayashi", @"Sherrick", @"Woolfolk",
    @"Holladay", @"Hornback", @"Moler", @"Bowles", @"Libbey",
    @"Spano", @"Folson", @"Arguelles", @"Burke", @"Rook"
};

int femaleNamesCount = 20;
int maleNamesCount = 14;
int lastNamesCount = 50;



- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.genderType = (arc4random() % 2) ? genderMale: genderFemale;
        
        NSString* lastName = lastNames[arc4random() % lastNamesCount];
        
        NSString* firstName = nil;
        
        if (self.genderType == genderMale) {
            
            self.studentPhoto = [UIImage imageNamed:@"male.png"];
            firstName = maleNames[arc4random() % maleNamesCount];
       
        } else {
            
            self.studentPhoto = [UIImage imageNamed:@"female.png"];
            firstName = femaleNames[arc4random() % femaleNamesCount];
            
        }
        
        self.title = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        
        

        NSTimeInterval interval = (double)(arc4random() % 283824000 + 504576000);
        
        NSDate* dateOfBirth = [NSDate dateWithTimeIntervalSinceNow:-interval];
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"dd MMMM yyyy"];

        self.subtitle = [formatter stringFromDate:dateOfBirth];
        
    }
    return self;
}


@end
