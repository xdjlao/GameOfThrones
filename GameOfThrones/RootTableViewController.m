//
//  RootTableViewController.m
//  GameOfThrones
//
//  Created by Jerry on 1/26/16.
//  Copyright © 2016 Jerry Lao. All rights reserved.
//

#import "RootTableViewController.h"
#import "CharacterTableViewCell.h"
#import "Character.h"
#import "AppDelegate.h"
#import "AddCharacterViewController.h"
#import "DetailViewController.h"

@interface RootTableViewController ()

@property NSArray *characterWithImages;

@end

@implementation RootTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.characterWithImages = @[@"petyrbaelish", @"aryastark", @"tyrionlannister"];
    self.house = @[@"House Baratheon", @"House Lannister", @"House Stark", @"House Targaryen", @"House Martell", @"House Bolton"];
    self.hair = @[@"Black", @"Brown", @"Blonde", @"Red", @"White"];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.moc = appDelegate.managedObjectContext;
    self.charactersArray = [NSMutableArray new];
    
    if ([self loadCharacters]) {
        NSArray *gender = @[@"Male", @"Female"];
        
        NSString *contents = [[NSBundle mainBundle] pathForResource:@"gameofthrones" ofType:@"plist"];
        NSMutableArray *setCharacters = [NSMutableArray arrayWithContentsOfFile: contents];
        for (NSDictionary *character in setCharacters) {
            
            Character *newCharacter = [NSEntityDescription insertNewObjectForEntityForName:@"Character"
                                                                    inManagedObjectContext:self.moc];
            newCharacter.name = character[@"character"];
            newCharacter.actor = character[@"actor"];
            newCharacter.gender = [gender objectAtIndex:arc4random_uniform(gender.count)];
            newCharacter.hairColor = [self.hair objectAtIndex:arc4random_uniform(self.hair.count)];
            newCharacter.house = [self.house objectAtIndex:arc4random_uniform(self.house.count)];
            newCharacter.age = [NSNumber numberWithInt:arc4random_uniform(100)];
            
            NSError *error;
            
            
            if (![self.moc save:&error]) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                [self.charactersArray addObject:newCharacter];
            }
            
        }
        [self loadCharacters];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadCharacters];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.charactersArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CharacterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    Character *currentCharacter = [self.charactersArray objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = currentCharacter.name;
    NSString *lowerCaseNoSpaceString = [[currentCharacter.name stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
    if ([self.characterWithImages containsObject:lowerCaseNoSpaceString]) {
        UIImage *characterImage = [UIImage imageNamed:lowerCaseNoSpaceString];
        cell.characterImageView.image = characterImage;
    } else {
        if ([currentCharacter.gender isEqualToString:@"Male"]) {
            UIImage *characterImage = [UIImage imageNamed:@"male"];
            cell.characterImageView.image = characterImage;
        } else {
            UIImage *characterImage = [UIImage imageNamed:@"female"];
            cell.characterImageView.image = characterImage;
        }
        
    }
    
    NSString *lowerCaseNoSpaceStringHouse = [[currentCharacter.house stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
    UIImage *houseImage = [UIImage imageNamed:lowerCaseNoSpaceStringHouse];
    cell.houseImageView.image = houseImage;
    
    return cell;
}

- (BOOL)loadCharacters {
    [self.charactersArray removeAllObjects];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Character"];
    
    NSSortDescriptor *sortName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSSortDescriptor *sortedAge = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES];
    request.sortDescriptors = @[sortName, sortedAge];
    
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age >= %@", withAge];
    //    request.predicate = predicate;
    
    NSError *error;
    
    NSArray *responseArray = [self.moc executeFetchRequest:request error:&error];
    
    if (responseArray.count > 0) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            [self.charactersArray addObjectsFromArray:responseArray];
            [self.tableView reloadData];
        }
        return NO;
    } else {
        return YES;
    }
}

- (void)deleteFromDatabase:(NSManagedObject *)object {
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Character"];
//    fetchRequest.predicate = [NSPredicate predicateWithFormat:<#(nonnull NSString *), ...#>]
    [self.moc deleteObject:object];
    NSError *error;
    
    if (![self.moc save:&error]) {
        NSLog(@"Error: %@", error.localizedDescription);
    }
}

#pragma mark - delegates

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSManagedObject *toDelete = [self.charactersArray objectAtIndex:indexPath.row];
        [self.charactersArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self deleteFromDatabase:toDelete];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"White Walkers";
}
/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier  isEqual: @"Add"]) {
        AddCharacterViewController *destination = segue.destinationViewController;
        destination.rootViewController = self;
    } else if ([segue.identifier isEqual: @"Detail"]) {
        DetailViewController *destination = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        destination.character = [self.charactersArray objectAtIndex:indexPath.row];
    }
    
}

@end
