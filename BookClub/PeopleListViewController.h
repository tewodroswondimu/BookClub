//
//  PeopleListViewController.h
//  BookClub
//
//  Created by Tewodros Wondimu on 1/29/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface PeopleListViewController : UIViewController

@property BOOL currentView;
@property NSArray *peopleArray; 

@property NSManagedObjectContext *context;

@end
