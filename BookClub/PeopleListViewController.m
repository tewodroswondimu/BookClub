//
//  PeopleListViewController.m
//  BookClub
//
//  Created by Tewodros Wondimu on 1/29/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "PeopleListViewController.h"
#import "Person.h"

@interface PeopleListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PeopleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"People List";
    self.currentView = true;

    // Add a done button to the navigation bar
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonPressed:)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

// When done button is pressed dismiss the view
- (IBAction)doneButtonPressed:(UIBarButtonItem *)doneButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    return self.peopleArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    Person *person = [self.peopleArray objectAtIndex:indexPath.row];
    person.isFriend = [NSNumber numberWithBool:YES];
    [self.context save:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PeopleCell"];
    Person *person = [self.peopleArray objectAtIndex:indexPath.row];
    cell.textLabel.text = person.name;
    if ([person.isFriend boolValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
