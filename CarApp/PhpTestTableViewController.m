//
//  PhpTestTableViewController.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-4-5.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "PhpTestTableViewController.h"

@interface PhpTestTableViewController ()

@end

@implementation PhpTestTableViewController

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"_cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"_cell"];
    }
    switch (indexPath.row) {
        case 0:
            [cell.textLabel setText:@"检测手机号"];
            break;
        case 1:
            [cell.textLabel setText:@"检测用户名"];
            break;
        case 2:
            [cell.textLabel setText:@"获取验证码"];
            break;
        case 3:
            [cell.textLabel setText:@"注册用户"];
            break;
        case 4:
            [cell.textLabel setText:@"登入用户"];
            break;
        case 5:
            [cell.textLabel setText:@"获取用户详情"];
            break;
        case 6:
            [cell.textLabel setText:@"检测手机号"];
            break;
        default:
            break;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
            [APIClient networkCheckPhone:@"15280553669" success:^(Respone *respone) {
                [UIAlertView showAlertViewWithTitle:@"respone" message:[respone description] cancelTitle:@"知道了"];
            } failure:^(NSError *error) {
                
            }];
            break;
        case 1:
            [APIClient networkCheckUserName:@"伟刚" success:^(Respone *respone) {
                [UIAlertView showAlertViewWithTitle:@"respone" message:[respone description] cancelTitle:@"知道了"];
            } failure:^(NSError *error) {
                
            }];
            break;
        case 2:
            [APIClient networkGetauthcodeWithPhone:@"15280553669" success:^(Respone *respone) {
                [UIAlertView showAlertViewWithTitle:@"respone" message:[respone description] cancelTitle:@"知道了"];
            } failure:^(NSError *error) {
                
            }];
            break;
        case 3:
            [APIClient networkUserRegistWithPhone:@"15280553669" password:@"123456789" authcode:@"796226" smsid:@"11633281" success:^(Respone *respone) {
                [UIAlertView showAlertViewWithTitle:@"respone" message:[respone description] cancelTitle:@"知道了"];
            } failure:^(NSError *error) {
                
            }];
            break;
        case 4:
            [APIClient networkUserLoginWithPhone:@"15280553669" password:@"123456789" success:^(Respone *respone) {
                [UIAlertView showAlertViewWithTitle:@"respone" message:[respone description] cancelTitle:@"知道了"];
            } failure:^(NSError *error) {
                
            }];
            break;
        case 5:
            [APIClient networkGetUserInfoWithuid:3 success:^(Respone *respone) {
                [UIAlertView showAlertViewWithTitle:@"respone" message:[respone description] cancelTitle:@"知道了"];
            } failure:^(NSError *error) {
                
            }];
            break;
        case 6:
            
            break;
        default:
            break;
    }
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
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
