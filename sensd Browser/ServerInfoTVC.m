//
//  ServerInfoTVC.m
//  Showoff
//
//  Created by Per Lindgren on 2013-12-15.
//  Copyright (c) 2013 Per Lindgren. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "ServerInfoTVC.h"

@interface ServerInfoTVC ()

@property (nonatomic, readwrite) BOOL creatingNewServerRecord;

@property (weak, nonatomic) IBOutlet UITextField    *description;
@property (weak, nonatomic) IBOutlet UITextField    *servername;
@property (weak, nonatomic) IBOutlet UITextField    *port;
@property (weak, nonatomic) IBOutlet UISwitch       *autoconnect;
@property (weak, nonatomic) IBOutlet UITextField    *maxLogRecords;
@property (weak, nonatomic) IBOutlet UIImageView    *connectionStatusView;
@property (weak, nonatomic) IBOutlet UILabel        *connectionStatusText;

@property (nonatomic, readwrite) UITextField        *activeTextField;

@end

// ShowMapRow is the "row" number in the static table view
// of the "show on map" item

#define ShowMapRow 6

@implementation ServerInfoTVC

@synthesize server = _server;

- (void)setServer:(Server *)newServer
{
    if (_server != newServer) {
        _server = newServer;
        _creatingNewServerRecord = FALSE;
        // Update the view.
        [self configureView];
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.tableView.dataSource = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.server == NULL) {
        self.creatingNewServerRecord = TRUE;
        NSLog(@"ServerInfoTVC:viewDidLoad: server == NULL");
    } else {
        self.creatingNewServerRecord = FALSE;
        NSLog(@"ServerInfoTVC:viewDidLoad: server != NULL");
    }
    
    [self registerForKeyboardNotifications];
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) updateServerRecordWithViewData:(Server *)serverRecord
{
    [serverRecord updateServerDescription:[self.description.text copy]];
    [serverRecord updateServerName:[self.servername.text copy]];
    [serverRecord updateServerPortNumber:[self.port.text integerValue]];
    [serverRecord updateLogMaxSize:[self.maxLogRecords.text integerValue]];
    [serverRecord updateConnectFlag:self.autoconnect.on];
}

- (Server *) getViewDataAsServerRecord
{
    Server *s = [[Server alloc] initWithServer:self.servername.text description:self.description.text atPortnumer:[self.port.text integerValue] maximumLogEntries:[self.maxLogRecords.text integerValue] connectOnStartup:self.autoconnect.on];
    
    return s;
}

- (void)configureView
{
    self.description.text = self.server.serverDescription;
    self.servername.text = self.server.serverName;
    self.port.text = [NSString stringWithFormat:@"%d", self.server.portNumber];
    self.autoconnect.on = self.server.autoConnect;
    self.maxLogRecords.text = [NSString stringWithFormat:@"%d", self.server.logList.maxNumberOfRecords];
    [self updateConnectionStatus];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"ServerInfoTVC:viewWillAppear");
    [self configureView];
    
    [self performSelector:@selector(updateConnectionStatus) withObject:nil afterDelay:2];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"ServerInfoTVC:viewWillDisappear");
    
    // Remove any pending performSelector:
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateConnectionStatus) object:nil];
}

- (void) updateConnectionStatus
{

    if (self.server) {

        switch (self.server.streamStatus) {
            case ServerStreamStatusClosed:
            case ServerStreamStatusOpenWithError:
                self.connectionStatusView.image = [UIImage imageNamed:@"NO_icon.png"];
                break;
            case ServerStreamStatusOpening:
                self.connectionStatusView.image = [UIImage imageNamed:@"QMark_icon.png"];
                break;
            case ServerStreamStatusOpen:
                self.connectionStatusView.image = [UIImage imageNamed:@"OK_icon.png"];
                break;
                
            default:
                break;
        }
        self.connectionStatusText.text = self.server.streamStatusString;    
    }
    
    //Re-que myself
    [self performSelector:@selector(updateConnectionStatus) withObject:nil afterDelay:2];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ((textField == self.description) || (textField == self.servername)
        || (textField == self.port)|| (textField == self.maxLogRecords)) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 6;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    // Configure the cell...
    if (indexPath.row == ShowMapRow) {
        if (self.hasServerCoordinates) {
            cell.userInteractionEnabled = YES;
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        } else{
            cell.userInteractionEnabled = NO;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}
*/

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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeTextField = nil;
}


// Call this method somewhere in your view controller setup code.

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeTextField.frame.origin) ) {
        [self.tableView scrollRectToVisible:self.activeTextField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"ServerInfoTVC: prepareForSegue:sender: with identifier %@", [segue identifier]);
    if ([[segue identifier] isEqualToString:@"Show Server on Map"]) {
        NSLog(@"ServerInfoTVC: prepareForSegue:Show Server on Map");
        if ([segue.destinationViewController respondsToSelector:@selector(setServer:)])
            [segue.destinationViewController performSelector:@selector(setServer:) withObject:self.server];
    }
    
}




@end
