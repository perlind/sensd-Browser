//
//  Server ListTVC.m
//  Showoff
//
//  Created by Per Lindgren on 2013-09-29.
//  Copyright (c) 2013 Per Lindgren. All rights reserved.
//

#import "ServerListTVC.h"
//#import "ShowoffServerViewController.h"
#import "ServerInfoTVC.h"
//#import "ServerLogListTVC.h"
//#import "ServerLogDetailViewController.h"


@interface ServerListTVC () <UITableViewDelegate>

@property (nonatomic, strong, readwrite) ServerList *servers;
@property (nonatomic, readwrite) NSInteger rowToEdit;


@end


@implementation ServerListTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) setupServersList
{
    // Dummy code while real storage of server list isn't implemented
    if (!self.servers) {
        self.servers = [[ServerList alloc] init];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    NSLog(@"ServerListTVC: awakeFromNib:");
    [self setupServersList]; // or should this be in awakeFromNib?
}

- (void) saveServerInfo
{
    // Save server list info in user defaults
    if (self.servers) {
        [self.servers saveServerInfo];
        
        //NSArray *array = [self.servers getServerListAsDictionary];
        //[[NSUserDefaults standardUserDefaults] setObject:array
        //                                          forKey:SERVERLISTUSERDEFAULTSKEY_v1];
        //[[NSUserDefaults standardUserDefaults] synchronize];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSLog(@"ServerListTVC: viewDidLoad:");
    self.rowToEdit = -1;
    [self setBarButtons];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"ServerListTVC:viewWillAppear");
//    [self.tableView reloadData];
    // Periodically check/redraw the table view, to update any changes in
    // connection status
    [self performSelector:@selector(checkForServerInfoUpdates) withObject:nil afterDelay:0];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"ServerListTVC:viewWillDisappear");

    // Remove any pending performSelector:
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkForServerInfoUpdates) object:nil];
}

- (void) checkForServerInfoUpdates
{
    // This is not as bad as it looks. reloadData only redraws what is
    // visible on the screen.
    [self.tableView reloadData];
    
    //Re-que myself
    [self performSelector:@selector(checkForServerInfoUpdates) withObject:nil afterDelay:2];
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
    return [self.servers numberOfServers];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Server List";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Server *s = [self.servers serverAtIndex:indexPath.row];
    if (s) {
        cell.textLabel.text = s.serverDescription;
        cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@:%d, %d record%@", s.serverName, s.portNumber, s.logList.numberOfRecords, s.logList.numberOfRecords > 1 ? @"s" : @""];
        cell.imageView.image = [self getImageForConnectionState:s.streamStatus];
        [cell.imageView sizeToFit];
        
        // Check if connection is lost and needs restarting
        if (s.autoConnect && !s.streamToServer) {
            [s openStreamToServer];
        }
    } else
        cell.textLabel.text = [NSString stringWithFormat:@"ServerListTVC: Server list item is missing (%d).", indexPath.row];
    
    return cell;
}

- (UIImage*)getImageForConnectionState:(NSInteger)connectionStatus
{
    UIImage *image;
    switch (connectionStatus) {
        case ServerStreamStatusClosed:
        case ServerStreamStatusOpenWithError:
            image = [UIImage imageNamed:@"NO_icon.png"];
            break;
        case ServerStreamStatusOpening:
            image = [UIImage imageNamed:@"QMark_icon.png"];
            break;
        case ServerStreamStatusOpen:
            image = [UIImage imageNamed:@"OK_icon.png"];
            break;
            
        default:
            break;
    }

    return image;
}


#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    NSLog(@"ServerListTVC: tableView:didSelectRowAtIndexPath: %d", indexPath.row);
    self.rowToEdit = indexPath.row;
    [self performSegueWithIdentifier:@"EditServerInfo" sender:self];
}


- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"ServerListTVC: tableView:accessoryButtonTappedForRowWithIndexPath:");
    self.rowToEdit = indexPath.row;
    [self performSegueWithIdentifier:@"EditServerInfo" sender:self];
}


- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.servers removeServerAtIndex:indexPath.row];
        [self.tableView reloadData];
        [self setBarButtons];
    }
}

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [self.servers moveServerFromIdex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}


- (IBAction) enterEditMode
{
    // Remove any pending performSelector:
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkForServerInfoUpdates) object:nil];

    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    [self.tableView setEditing:YES animated:YES];
    [self setBarButtons];
}


- (void) leaveEditMode
{
    [self.tableView setEditing:NO animated:YES];
    [self setBarButtons];

    // Restart updates
    [self performSelector:@selector(checkForServerInfoUpdates) withObject:nil afterDelay:0];
}


- (void) setBarButtons
{
    if (self.tableView.isEditing) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(leaveEditMode)];
    } else {
        if (self.servers.numberOfServers)
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(enterEditMode)];
        else
            self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"ServerListTVC: prepareForSegue:sender: with identifier %@", [segue identifier]);
    if ([[segue identifier] isEqualToString:@"EditServerInfo"]) {
        ServerInfoTVC *serverInfoTVC = [segue destinationViewController];

        // User click on detailDisclosureButton
        if (self.rowToEdit > -1) {
            serverInfoTVC.server = [self.servers serverAtIndex:self.rowToEdit];
        } // else serverViewController.server is not set, which implies that we're creating a new record
    } else if ([[segue identifier] isEqualToString:@"ShowServerLogs"]) {
//        NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
//        ServerLogListTVC *logViewController = [segue destinationViewController];
//        logViewController.server = [self.servers serverAtIndex:ip.row];
        NSLog(@"ServerListTVC: prepareForSegue:sender: with deprecated identifier %@", [segue identifier]);
    }
}


- (IBAction)done:(UIStoryboardSegue *)segue
{
     if ([[segue identifier] isEqualToString:@"ReturnInput"]) {
         ServerInfoTVC *serverInfoTVC = [segue sourceViewController];
         if (serverInfoTVC.creatingNewServerRecord) {
             Server *s = [serverInfoTVC getViewDataAsServerRecord];
             [self.servers addServer:s];
         } else {
             Server *s = [self.servers serverAtIndex:self.rowToEdit];
             [serverInfoTVC updateServerRecordWithViewData:s];
             // Save server list, even if we don't know if anything has changed
             [self.servers saveServerInfo];
         }
         [self.tableView reloadData];
         [self dismissViewControllerAnimated:YES completion:NULL];
    }
    NSLog(@"ServerListTVC:done: segue identifier = %@", [segue identifier]);
    self.rowToEdit = -1;
}

- (IBAction)cancel:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"CancelInput"]) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    NSLog(@"ServerListTVC:cancel:");
    self.rowToEdit = -1;
}



@end
