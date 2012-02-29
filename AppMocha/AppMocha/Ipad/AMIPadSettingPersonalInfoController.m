//
//  AMIPadSettingPersonalInfoController.m
//  AppMocha
//
//  Created by Danny Deng on 12-2-22.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import "AMIPadSettingPersonalInfoController.h"
#import "AppBand.h"


@interface AMIPadSettingPersonalInfoController(Private)

- (void)sendSaveData;

@end

@implementation AMIPadSettingPersonalInfoController
@synthesize personalSettingTableView;

#pragma mark - View lifecycle

- (void)dealloc{
    [_agePickerView release];
    [_earnPickerView release];
    [_lblsex release];
    [_lblage release];
    [_lblEarn release];
    [_textFieldJob release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    BOOL isFemale = NO;
    
    [personalSettingTableView setDelegate:self];
    [personalSettingTableView setDataSource:self];
    _lblsex = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
    [_lblsex setBackgroundColor:[UIColor clearColor]];
    isFemale = [[[NSUserDefaults standardUserDefaults] objectForKey:@"MochaCity_Gender"] boolValue];
    if (isFemale) {
        [_lblsex setText:@"女"];
    }
    else {
        [_lblsex setText:@"男"];
    }
    
    _lblage = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
    [_lblage setBackgroundColor:[UIColor clearColor]];
    [_lblage setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"MochaCity_Age"]];
    if (!_lblage.text || ![_lblage.text length]) {
        [_lblage setText:@"20"];
    }
    
    _lblEarn = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 25)];
    [_lblEarn setBackgroundColor:[UIColor clearColor]];
    [_lblEarn setTextAlignment:UITextAlignmentRight];
    [_lblEarn setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"MochaCity_Salary"]];
    if (!_lblEarn.text || ![_lblEarn.text length]) {
        [_lblEarn setText:@"15500"];
        wan = 1;
        qian = 5;
        bai = 5;
    }
    else {
        wan = [_lblEarn.text intValue]/10000;
        qian = [_lblEarn.text intValue]/1000%10;
        bai = [_lblEarn.text intValue]/100%10;
    }
    
    _textFieldJob = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 25)];
    [_textFieldJob setTextAlignment:UITextAlignmentRight];
    [_textFieldJob setBackgroundColor:[UIColor clearColor]];
    [_textFieldJob setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"MochaCity_Job"]];
    [_textFieldJob setEnabled:NO];
    if (!_textFieldJob.text || ![_textFieldJob.text length]) {
        [_textFieldJob setText:@"销售"];
    }
    
    _agePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-100, self.view.frame.size.height+5, 200, 200)];
    [_agePickerView setDelegate:self];
    [_agePickerView setDataSource:self];
    [self.view addSubview:_agePickerView];
    [_agePickerView selectRow:[_lblage.text intValue] inComponent:0 animated:NO];
    
    _earnPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-100, self.view.frame.size.height+5, 200, 200)];
    [_earnPickerView setDelegate:self];
    [_earnPickerView setDataSource:self];
    [self.view addSubview:_earnPickerView];
    [_earnPickerView selectRow:wan inComponent:0 animated:NO];
    [_earnPickerView selectRow:qian inComponent:1 animated:NO];
    [_earnPickerView selectRow:bai inComponent:2 animated:NO];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(sendSaveData)];
    [self.navigationItem setRightBarButtonItem:saveButton];
    [saveButton release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentify = @"cell";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify] autorelease];
    }
    switch (indexPath.section) {
        case 0:
            [cell.textLabel setText:@"性别"];
            [cell setAccessoryView:_lblsex];
            break;
        case 1:
            [cell.textLabel setText:@"年龄"];
            [cell setAccessoryView:_lblage];
            break;
        case 2:
            [cell.textLabel setText:@"月收入"];
            [cell setAccessoryView:_lblEarn];
            break;
        case 3:
            [cell.textLabel setText:@"职业"];
            [cell setAccessoryView:_textFieldJob];
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0: {
            [UIView animateWithDuration:.2 animations:^{
                [_earnPickerView setFrame:CGRectMake(self.view.frame.size.width/2-100, self.view.frame.size.height+5, 200, 200)];
                [_agePickerView setFrame:CGRectMake(self.view.frame.size.width/2-100, self.view.frame.size.height+5, 200, 200)];
                [_textFieldJob resignFirstResponder];
                [_textFieldJob setEnabled:NO];
            }completion:^(BOOL finish)  {
                
            }];
            UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:@" 性别 " delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男", @"女", nil] autorelease];
            [actionSheet showInView:self.view];
            break;
        }
        case 1: {
            if (_agePickerView.frame.origin.y > self.view.frame.size.height) {
                [UIView animateWithDuration:.2 animations:^{
                    [_agePickerView setFrame:CGRectMake(self.view.frame.size.width/2-100, self.view.frame.size.height - 400, 200, 200)];
                    
                    [_earnPickerView setFrame:CGRectMake(self.view.frame.size.width/2-100, self.view.frame.size.height+5, 200, 200)];
                    [_textFieldJob resignFirstResponder];
                    [_textFieldJob setEnabled:NO];
                }completion:^(BOOL finish)  {
                    
                }];
            }
            else {
                [UIView animateWithDuration:.2 animations:^{
                    [_agePickerView setFrame:CGRectMake(self.view.frame.size.width/2-100, self.view.frame.size.height+5, 200, 200)];
                }completion:^(BOOL finish)  {
                    
                }];
            }
            break;
        }
        case 2:
            if (_earnPickerView.frame.origin.y > self.view.frame.size.height) {
                [UIView animateWithDuration:.2 animations:^{
                    [_earnPickerView setFrame:CGRectMake(self.view.frame.size.width/2-100, self.view.frame.size.height - 400, 200, 200)];
                    
                    [_agePickerView setFrame:CGRectMake(self.view.frame.size.width/2-100, self.view.frame.size.height+5, 200, 200)];
                    [_textFieldJob resignFirstResponder];
                    [_textFieldJob setEnabled:NO];
                }completion:^(BOOL finish)  {
                    
                }];
            }
            else {
                [UIView animateWithDuration:.2 animations:^{
                    [_earnPickerView setFrame:CGRectMake(self.view.frame.size.width/2-100, self.view.frame.size.height+5, 200, 200)];
                }completion:^(BOOL finish)  {
                    
                }];
            }
            break;
        case 3:
            [UIView animateWithDuration:.2 animations:^{
                [_earnPickerView setFrame:CGRectMake(self.view.frame.size.width/2-100, self.view.frame.size.height+5, 200, 200)];
                [_agePickerView setFrame:CGRectMake(self.view.frame.size.width/2-100, self.view.frame.size.height+5, 200, 200)];
            }completion:^(BOOL finish)  {
                
            }];
            [_textFieldJob setEnabled:YES];
            [_textFieldJob becomeFirstResponder];
            break;
        default:
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [_lblsex setText:@"男"];
            break;
        case 1:
            [_lblsex setText:@"女"];
            break;
        default:
            break;
    }
}

#pragma mark - UIPickerViewDelegate

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    if ([pickerView isEqual:_agePickerView]) {
//        return @"年龄";
//    }
//    else if ([pickerView isEqual:_earnPickerView]){
//        switch (component) {
//            case 0:
//                return @"万";
//                break;
//            case 1:
//                return @"千";
//                break;
//            case 2:
//                return @"百";
//                break;
//            default:
//                break;
//        }
//    }
//    return nil;
//}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView { 
    if ([pickerView isEqual:_agePickerView]) {
        return 1;
    }
    else if ([pickerView isEqual:_earnPickerView]){
        return 3;
    }

    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([pickerView isEqual:_agePickerView]) {
        return 150;
    }
    else if ([pickerView isEqual:_earnPickerView]){
        if (component == 0) {
            return 5;
        }
        else {
            return 10;
        }
    }
    
    return 150;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([pickerView isEqual:_agePickerView]) {
        return [NSString stringWithFormat:@"%i岁",row];
    }    
    else if ([pickerView isEqual:_earnPickerView]){
        switch (component) {
            case 0:
                return [NSString stringWithFormat:@"%i万",row];
                break;
            case 1:
                return [NSString stringWithFormat:@"%i千",row];
                break;
            case 2:
                return [NSString stringWithFormat:@"%i百",row];
                break;
            default:
                break;
        }
    }

    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    @synchronized ([AMIPadSettingPersonalInfoController class]) {
        if ([pickerView isEqual:_agePickerView]) {
            [_lblage setText:[NSString stringWithFormat:@"%i",row]];
        }
        else if ([pickerView isEqual:_earnPickerView]){
            wan = [pickerView selectedRowInComponent:0];
            qian = [pickerView selectedRowInComponent:1];
            bai = [pickerView selectedRowInComponent:2];
            [_lblEarn setText:[NSString stringWithFormat:@"%i",wan*10000+qian*1000+bai*100]];
        }
    }
}

#pragma mark - Private
- (void)sendSaveData {
    NSNumber *gender = [NSNumber numberWithBool:YES];
    NSString *age = @"";
    NSString *salary = @"";
    NSString *job = @"";
    
    if (_lblsex.text && ![_lblsex.text isEqualToString:@""]) {
        BOOL isMale = ![_lblsex.text isEqualToString:@"男"];
        gender = [NSNumber numberWithBool:isMale];
        [[NSUserDefaults standardUserDefaults] setObject:gender forKey:@"MochaCity_Gender"];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MochaCity_Gender"];
    }
    
    if (_lblage.text && ![_lblage.text isEqualToString:@""]) {
        age = _lblage.text;
        [[NSUserDefaults standardUserDefaults] setObject:age forKey:@"MochaCity_Age"];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MochaCity_Age"];
    }
    
    if (_lblEarn.text && ![_lblEarn.text isEqualToString:@""]) {
        salary = _lblEarn.text;
        [[NSUserDefaults standardUserDefaults] setObject:salary forKey:@"MochaCity_Salary"];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MochaCity_Salary"];
    }
    
    if (_textFieldJob.text && ![_textFieldJob.text isEqualToString:@""]) {
        job = _textFieldJob.text;
        [[NSUserDefaults standardUserDefaults] setObject:job forKey:@"MochaCity_Job"];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MochaCity_Job"];
    }
    
    [[AppBand shared] setTagsWithK1:[gender stringValue] k2:age k3:salary k4:job k5:nil];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
