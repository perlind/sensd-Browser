//
//  LogDetailTVC.m
//  sensd Browser
//
//  Created by Per Lindgren on 2014-03-02.
//  Copyright (c) 2014 Per Lindgren. All rights reserved.
//

#import "LogDetailTVC.h"

@interface LogDetailTVC ()

@property (nonatomic, strong, readwrite) LogRecord *logRecord;

@end


@implementation LogDetailTVC

@synthesize logRecord = _logRecord;

- (void) setLogRecord:(LogRecord *)record
{
    _logRecord = record;
}

#pragma mark - Table view data source
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // If we dont have a "logRecord" we have nothing to show so return 0 for all sections
    if (self.logRecord == nil)
        return 0;
    
    // Return the number of rows in the section.
    switch (section) {
        case 0: {
            // Section 0 is the timestamp, if any
            return [self.logRecord getTimeStampCount];
        }
            break;
            
        case 1:{
            // Section 1 is the sensor values
            return [self.logRecord getLogValueCount];
        }
            break;
            
        case 2:{
            // Section 2 is the relay info values
            return [self.logRecord getNodeInfoCount];
        }
            break;
            
        default:
            break;
    }
    
    // Otherwise return 0
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LogRecord";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //cell.accessoryType = UITableViewCellAccessoryNone;
    //cell.userInteractionEnabled = NO;
    
    // Configure the cell...
    switch (indexPath.section) {
        case 0: {
            // Section 0 is the timestamp, if any
            cell.textLabel.text = [self.logRecord getTimeStampKeyAtIndex:indexPath.row];
            cell.detailTextLabel.text = [self.logRecord getTimeStampDataAtIndex:indexPath.row];
            // GWGPS_LON and GWGPS_LAT, enable latitude/longitude lines to seque to a map view
            // showing where the server is located
            //if ([cell.textLabel.text isEqualToString:@"GWGPS_LAT"] || [cell.textLabel.text isEqualToString:@"GWGPS_LON"]) {
            //    cell.userInteractionEnabled = YES;
            //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            //}
        }
            break;
            
        case 1:{
            // Section 1 is the sensor values
            cell.textLabel.text = [self.logRecord getLogValueKeyAtIndex:indexPath.row];
            cell.detailTextLabel.text = [self.logRecord getLogValueDataAtIndex:indexPath.row];
        }
            break;
            
        case 2:{
            // Section 2 is the node info values
            cell.textLabel.text = [self.logRecord getNodeInfoKeyAtIndex:indexPath.row];
            cell.detailTextLabel.text = [self.logRecord getNodeInfoDataAtIndex:indexPath.row];
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    
    switch (section) {
        case 0:
            title = @"sensd server info";
            break;
            
        case 1:
            title = @"Sensor values";
            break;
            
        case 2:
            title = @"Relay info";
            break;
            
        default:
            break;
    }
    
    return title;
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
