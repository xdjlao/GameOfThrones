//
//  AddCharacterViewController.m
//  GameOfThrones
//
//  Created by Jerry on 1/26/16.
//  Copyright © 2016 Jerry Lao. All rights reserved.
//

#import "AddCharacterViewController.h"
#import "Character.h"

@interface AddCharacterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *houseTextField;
@property (weak, nonatomic) IBOutlet UITextField *actorTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *hairColorTextField;

@end

@implementation AddCharacterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)onDoneButtonClicked:(UIButton *)sender {
    [self addCharacter];
}

- (void)addCharacter {
    Character *newCharacter = [NSEntityDescription insertNewObjectForEntityForName:@"Character"
                                                            inManagedObjectContext:self.rootViewController.moc];
    newCharacter.name = self.nameTextField.text;
    newCharacter.actor = self.actorTextField.text;
    newCharacter.hairColor = self.hairColorTextField.text;
    newCharacter.age = [NSNumber numberWithInt:[self.ageTextField.text intValue]];
    newCharacter.house = self.houseTextField.text;
    newCharacter.gender = [self.genderSegmentedControl titleForSegmentAtIndex:[self.genderSegmentedControl selectedSegmentIndex]];
    
    NSError *error;
    
    if (![self.rootViewController.moc save:&error]) {
        NSLog(@"Error: %@", error.localizedDescription);
    } else {
        [self.rootViewController.charactersArray addObject:newCharacter];
    }
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
