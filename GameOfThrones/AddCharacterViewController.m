//
//  AddCharacterViewController.m
//  GameOfThrones
//
//  Created by Jerry on 1/26/16.
//  Copyright © 2016 Jerry Lao. All rights reserved.
//

#import "AddCharacterViewController.h"
#import "Character.h"

@interface AddCharacterViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *actorTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentedControl;
@property (weak, nonatomic) IBOutlet UIPickerView *housePickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *hairPickerView;

@end

@implementation AddCharacterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Add Character";
}

- (IBAction)onDoneButtonClicked:(UIButton *)sender {
    [self addCharacter];
    sender.enabled = NO;
    
    UINavigationController *navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:YES];
}

- (void)addCharacter {
    Character *newCharacter = [NSEntityDescription insertNewObjectForEntityForName:@"Character"
                                                            inManagedObjectContext:self.rootViewController.moc];
    newCharacter.name = self.nameTextField.text;
    newCharacter.actor = self.actorTextField.text;
    NSInteger hairRow = [self.hairPickerView selectedRowInComponent:0];
    newCharacter.hairColor = [self.rootViewController.hair objectAtIndex:hairRow];
    newCharacter.age = [NSNumber numberWithInt:[self.ageTextField.text intValue]];

    NSInteger houseRow = [self.housePickerView selectedRowInComponent:0];
    newCharacter.house = [self.rootViewController.house objectAtIndex:houseRow];
    newCharacter.gender = [self.genderSegmentedControl titleForSegmentAtIndex:[self.genderSegmentedControl selectedSegmentIndex]];
    
    NSError *error;
    
    if (![self.rootViewController.moc save:&error]) {
        NSLog(@"Error: %@", error.localizedDescription);
    } else {
        [self.rootViewController.charactersArray addObject:newCharacter];
    }
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView.tag == 1) {
        return self.rootViewController.hair.count;
    } else {
        return self.rootViewController.house.count;
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *textView = (UILabel *)view;
    if (!textView) {
        textView = [UILabel new];
        [textView setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    }
    if (pickerView.tag == 1) {
        textView.text = [self.rootViewController.hair objectAtIndex:row];
    } else {
        textView.text = [self.rootViewController.house objectAtIndex:row];
    }
    textView.textAlignment = NSTextAlignmentCenter;
    
    return textView;
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
