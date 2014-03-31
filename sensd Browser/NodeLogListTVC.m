//
//  NodeLogListTVC.m
//  sensd Browser
//
//  Created by Per Lindgren on 2014-03-02.
//  Copyright (c) 2014 Per Lindgren. All rights reserved.
//

#import "NodeLogListTVC.h"
#import "LogDetailTVC.h"

@interface NodeLogListTVC ()

@property (nonatomic, strong, readwrite) Node *node;

@end

@implementation NodeLogListTVC

@synthesize node = _node;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNode:(Node *)n
{
    _node = n;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.node.logList numberOfRecords];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Log Lines";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    LogRecord *lr = [self.node.logList recordAtIndex:indexPath.row];
    if (lr) {
        cell.textLabel.text = lr.description;
    } else
        cell.textLabel.text = [NSString stringWithFormat:@"ServerLogListTVC: Server log list item is missing (%d).", indexPath.row];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

 - (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     NSLog(@"NodeLogListTVC: prepareForSegue:sender: with identifier %@", [segue identifier]);
     if ([[segue identifier] isEqualToString:@"ShowLogLineDetails"]) {
         NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
         LogDetailTVC *logDetailViewController = [segue destinationViewController];
         //[logDetailViewController setLogRecord:[self.server.logList recordAtIndex:ip.row]];
         [logDetailViewController setLogRecord:[self.node.logList recordAtIndex:ip.row]];
     }
 }


@end
