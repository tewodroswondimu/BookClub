//
//  AddBookViewController.m
//  BookClub
//
//  Created by Tewodros Wondimu on 1/29/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "AddBookViewController.h"
#import "Book.h"

@interface AddBookViewController () 
@property (weak, nonatomic) IBOutlet UITextField *bookTitleTextField;
@property (weak, nonatomic) IBOutlet UITextField *authorTextField;

@end

@implementation AddBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveButtonTapped:(UIBarButtonItem *)sender
{
    Book *book = [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:self.context];
    book.title = self.bookTitleTextField.text;
    book.author = self.authorTextField.text;

    [self.person addRecommendedBooksObject:book];

    [self.context save:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelButtonTapped:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
