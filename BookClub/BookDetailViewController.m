//
//  BookDetailViewController.m
//  BookClub
//
//  Created by Tewodros Wondimu on 1/30/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "BookDetailViewController.h"
#import "Comment.h"

@interface BookDetailViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *bookTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookAuthorLabel;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;

@property NSArray *comments;

@property UIAlertController *commentAlert;

@end

@implementation BookDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.bookTitleLabel.text = self.book.title;
    self.bookAuthorLabel.text = self.book.author;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (!self.comments.count) {
        self.comments = [self.book.comments allObjects];
    }
    [self.commentTableView reloadData];
}

- (IBAction)onAddCommentButtonPressed:(UIBarButtonItem *)sender
{
    self.commentAlert = [UIAlertController alertControllerWithTitle:@"Add a comment" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self.commentAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        nil;
    }];
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextView *textField = self.commentAlert.textFields.firstObject;
        Comment *comment = [NSEntityDescription insertNewObjectForEntityForName:@"Comment" inManagedObjectContext:self.context];
        comment.comment = textField.text;
        [self.book addCommentsObject:comment];
        [self.context save:nil];

        // reload comments with the contents of the book comments and reload the tableview
        self.comments = [self.book.comments allObjects];
        [self.commentTableView reloadData];
    }];
    [self.commentAlert addAction:addAction];
    [self presentViewController:self.commentAlert animated:YES completion:nil];
}

#pragma mark TABLE VIEW

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    Comment *comment = [self.comments objectAtIndex:indexPath.row];

    cell.textLabel.text = comment.comment;
    cell.detailTextLabel.text = comment.book.title;

    return cell;
}

@end
