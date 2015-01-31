//
//  BookDetailViewController.h
//  BookClub
//
//  Created by Tewodros Wondimu on 1/30/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

@interface BookDetailViewController : UIViewController

@property Book *book;
@property NSManagedObjectContext *context;

@end
