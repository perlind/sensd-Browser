//
//  NodeListTVC.m
//  sensd Browser
//
//  Created by Per Lindgren on 2014-03-02.
//  Copyright (c) 2014 Per Lindgren. All rights reserved.
//

#import "NodeListTVC.h"
#import "NodeLogListTVC.h"

@interface NodeListTVC ()

@property (nonatomic, strong, readwrite) NodeList *nodes;


@end

@implementation NodeListTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) setupNodeList
{
    // Dummy code while real storage of server list isn't implemented
    if (!self.nodes) {
        self.nodes = [[NodeList alloc] init];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    NSLog(@"NodeListTVC: awakeFromNib:");
    [self setupNodeList];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"NodeListTVC:viewWillAppear");

    //    [self.tableView reloadData];
    // Periodically check/redraw the table view, to update any changes in
    // connection status
    [self performSelector:@selector(checkForNodeListUpdates) withObject:nil afterDelay:2];
    
    // Set NodeList in tab bar controller
    sensdTabBarVC *tbc = [self getSensdTabBarVC:self];
    if (tbc) {
        [tbc setCurrentNodeList:self.nodes];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"NodeListTVC:viewWillDisappear");
    
    // Remove any pending performSelector:
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkForNodeListUpdates) object:nil];
}

- (id) getSensdTabBarVC:(UIViewController*)viewController
{
    if (viewController == nil)
        return nil;
    else {
        if ([viewController isKindOfClass:[sensdTabBarVC class]])
            return viewController;
        else
            return [self getSensdTabBarVC:viewController.parentViewController];
    }
}


- (void) checkForNodeListUpdates
{
    // This is not as bad as it looks. reloadData only redraws what is
    // visible on the screen.
    [self.tableView reloadData];
    
    //Re-que myself after 4 seconds
    [self performSelector:@selector(checkForNodeListUpdates) withObject:nil afterDelay:4];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the only section we have!
    return [self.nodes numberOfNodes];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NodeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Node *node = [self.nodes nodeAtIndex:indexPath.row];
    if (node) {
        if (node.nodeTXT)
            cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@ (%@)", node.nodeTXT, node.description];
        else
            cell.textLabel.text = node.description;
        cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@, %d record%@", node.fromServerInfo, node.logList.numberOfRecords, node.logList.numberOfRecords > 1 ? @"s" : @""];

    } else
        cell.textLabel.text = [NSString stringWithFormat:@"NodeListTVC: Node list item is missing (%d).", indexPath.row];
    
    return cell;
}



#pragma mark - Navigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"ServerLogListTVC: prepareForSegue:sender: with identifier %@", [segue identifier]);
    if ([[segue identifier] isEqualToString:@"ShowNodeLogs"]) {
        NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
        NodeLogListTVC *logListTVC = [segue destinationViewController];
        NSLog(@"row = %d", ip.row);
        logListTVC.node = [self.nodes nodeAtIndex:ip.row];
        //[logDetailViewController setLogRecord:[self.server.logList recordAtIndex:ip.row]];
        //[logDetailTVC setLogRecord:[self.nodes.logList recordAtIndex:ip.row]];
    }
    
}



@end
