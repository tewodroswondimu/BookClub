//
//  FriendDetailViewController.m
//  BookClub
//
//  Created by Tewodros Wondimu on 1/29/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "FriendDetailViewController.h"
#import "BookDetailViewController.h"
#import "AddBookViewController.h"
#import "Book.h"

@interface FriendDetailViewController () <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfBooksLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSArray *booksArray;

@end

@implementation FriendDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Assign the name label the person's name
    self.nameLabel.text = self.person.name;
    self.navigationController.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.booksArray.count)
    {
        self.booksArray = [self.person.recommendedBooks allObjects];
        self.numberOfBooksLabel.text = [NSString stringWithFormat:@"Number of Books: %lu", self.booksArray.count];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Load all elements of an entity
- (NSArray *)loadEntityArrayWithEntityName:(NSString *)entityName
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];

    NSArray *array = [self.context executeFetchRequest:request error:nil];

    //    [self.tableView reloadData];
    return array;
}

#pragma mark TABLE VIEW

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.booksArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendedBookCell"];
    Book *book = [self.booksArray objectAtIndex:indexPath.row];
    cell.textLabel.text = book.title;
    cell.detailTextLabel.text = book.author;

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddSegue"]) {
        AddBookViewController *abvc = [segue destinationViewController];
        abvc.context = self.context;
        abvc.person = self.person; 
    } else if ([segue.identifier isEqualToString:@"BookDetailSegue"])
    {
        BookDetailViewController *bdvc = [segue destinationViewController];
        bdvc.book = [self.booksArray objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        bdvc.context = self.context;
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.booksArray = [self.person.recommendedBooks allObjects];
}

@end
