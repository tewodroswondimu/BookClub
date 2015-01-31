//
//  AddBookViewController.h
//  BookClub
//
//  Created by Tewodros Wondimu on 1/29/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface AddBookViewController : UIViewController

@property NSManagedObjectContext *context;
@property Person *person; 

@end
