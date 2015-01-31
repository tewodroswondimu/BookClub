//
//  ViewController.m
//  BookClub
//
//  Created by Tewodros Wondimu on 1/28/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendDetailViewController.h"
#import "PeopleListViewController.h"
#import "AppDelegate.h"
#import "Person.h"

@interface FriendsViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property NSMutableArray *peopleArray;
@property NSMutableArray *friendsArray;

@property NSManagedObjectContext *context;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property NSArray *searchFriendsArray;

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.context = delegate.managedObjectContext;

    self.searchBar.delegate = self;

    // Create a friends array to store an array of friends
    self.friendsArray = [NSMutableArray new];

    // Create a peoples array to store everyone
    self.peopleArray = [NSMutableArray new];

    // load all friends from core data
    self.peopleArray = [NSMutableArray arrayWithArray:[self loadEntityArrayWithEntityName:@"Person"]];

    // Check if there are any friends in core data
    if (self.peopleArray.count)
    {
        // Fills up all the friends array
        [self findAllFriends];
    }
    else
    {
        // Fills up all the people array and then the friends array
        NSString *url = @"http://s3.amazonaws.com/mobile-makers-assets/app/public/ckeditor_assets/attachments/18/friends.json";
        [self loadFriendsWithJSONWithURL:url];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self findAllFriends];
}

- (void)findAllFriends
{
    // Clear the friends array
    [self.friendsArray removeAllObjects];

    // Enumerate the people array and add the friends into the friends array
    for (Person *person in self.peopleArray) {
        // Check if the person is a friend
        if ([person.isFriend boolValue])
        {
            [self.friendsArray addObject:person];
        }
    }

    NSSortDescriptor *sortDescriptorByPersonRecommendedBooks = [[NSSortDescriptor alloc] initWithKey:@"recommendedBooks.@count" ascending:NO];
//    NSSortDescriptor *sortDescriptorByPersonRecommendedBooks = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptorByPersonRecommendedBooks];
    self.friendsArray = [[self.friendsArray sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];

    [self.tableView reloadData];
}

#pragma mark LOADS

// Load all the names from a JSON turn them into Person Objects and add them into the people array
- (void)loadFriendsWithJSONWithURL:(NSString *)url
{
    // Use the peoples array to populate the names of all the people you know
    [self.peopleArray removeAllObjects];

    // create a url with the json file
    NSURL *jsonUrl = [NSURL URLWithString:url];

    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:jsonUrl];

    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError)
        {
            // Creates a array of all the people you know
            NSArray *arrayOfAllPeopleFromJSON = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] mutableCopy];

            [self.peopleArray removeAllObjects];

            // For every name in the list of people create a friend with the name equal to that string and the isFriend set to false
            for (NSString *personName in arrayOfAllPeopleFromJSON) {

                // Create a new NSManagedObject for each person in the JSON
                Person *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.context];
                person.name = personName;
                [person setValue:[NSNumber numberWithBool:NO] forKey:@"isFriend"];
                [self.peopleArray addObject:person];

                [self.context save:nil];
            }
        }
        else if (connectionError)
        {
            // Display the connection error if it doesn't log in
            NSLog(@"%@", connectionError);
        }

        [self findAllFriends];
    }];
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
    if (self.searchBar.text.length != 0)
    {
        return self.searchFriendsArray.count;
    }
    else
    {
        return self.friendsArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendsCell"];
    //    cell.textLabel.text = [self.friendsArray objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    if (self.searchBar.text.length == 0) {
        Person *person = [self.friendsArray objectAtIndex:indexPath.row];
        cell.textLabel.text = person.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Number of books: %lu", person.recommendedBooks.count];
    }
    else {
        Person *person = [self.searchFriendsArray objectAtIndex:indexPath.row];
        cell.textLabel.text = person.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Number of books: %lu", person.recommendedBooks.count];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark ADD VIEW CONTROLLERS

- (IBAction)addFriendButtonTapped:(UIBarButtonItem *)sender
{
    //    FriendsViewController *fvc = [self.storyboard instantiateViewControllerWithIdentifier:[FriendsViewController description]];
    PeopleListViewController *pvc = [self.storyboard instantiateViewControllerWithIdentifier:[PeopleListViewController description]];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:pvc];
    [self presentViewController:nav animated:YES completion:nil];
    pvc.peopleArray = self.peopleArray;
    pvc.context = self.context; 
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return true;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"FriendDetail"]) {
        FriendDetailViewController *fdvc = [segue destinationViewController];
        fdvc.context = self.context;
        Person *person = self.friendsArray[self.tableView.indexPathForSelectedRow.row];
        fdvc.person = person;
    }
}

#pragma mark SEARCH

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchText];
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self.friendsArray filteredArrayUsingPredicate:predicate]];
    if (tempArray.count) {
        self.searchFriendsArray = tempArray;
    }
    [self.tableView reloadData];
}

#pragma mark MEMORY MANAGEMENT

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
