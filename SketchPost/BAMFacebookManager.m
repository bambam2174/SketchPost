//
//  BAMFacebookManager.m
//  SketchPost
//
//  Created by Sedat Kilinc on 06.03.13.
//  Copyright (c) 2013 adrodev GmbH. All rights reserved.
//

#import "BAMFacebookManager.h"
#import "BAMAppDelegate.h"

static BAMFacebookManager *sharedMgrInstance = nil;

@interface BAMFacebookManager (private)

-(id)getUserInfoForKey:(NSString *)key;

@end

@implementation BAMFacebookManager

-(id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionStateChanged:) name:SCSessionStateChangedNotification object:nil];
    }
    return self;
}

#pragma mark - Returns static instance

+(BAMFacebookManager *)shared {
    if (!sharedMgrInstance) {
        sharedMgrInstance = [[[self class] alloc] init];
    }
    return sharedMgrInstance;
}

-(FBFriendPickerViewController *)friendsPickerController {
    _friendsPickerController = [[FBFriendPickerViewController alloc] initWithNibName:nil bundle:nil];
    _friendsPickerController.title = @"Freunde wählen";
    _friendsPickerController.delegate = self;
    [_friendsPickerController loadData];
    return _friendsPickerController;
}

#pragma mark - Fetch User Info

-(void)getUserDetails {
    NSMutableDictionary *dictUser = nil;
    if (FBSession.activeSession.isOpen) {
        dictUser = [[NSMutableDictionary alloc] init];
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                _user = (NSDictionary<FBGraphUser> *)result;
//                _bamUser = (NSDictionary<BAMUser> *)result;
                if ([_delegate respondsToSelector:@selector(userDetailsFetched:)])
                    [_delegate userDetailsFetched:_user];
                
            }
        }];
    }
}

#pragma mark - Fetch FBGraphUser values

-(id)getUserInfoForKey:(NSString *)key {
    if (_user && [_user objectForKey:key])
        return [_user objectForKey:key];
    else
        return nil;
}

-(NSString *)getUserBio {
    if (_user && [_user objectForKey:@"bio"]) 
        return [_user objectForKey:@"bio"];
    else
        return nil;
}

-(NSArray *)getUserEducation {
    if (_user && [_user objectForKey:@"education"])
        return [_user objectForKey:@"education"];
    else
        return nil;
}

-(NSArray *)getFavouriteAthletes {
    NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
    NSArray *arrDictAthletes = [self getUserInfoForKey:@"favorite_athletes"];
    for (NSDictionary *dictAthlete in arrDictAthletes) {
        [arrReturn addObject:[dictAthlete objectForKey:@"name"]];
    }
    return arrReturn;
}

-(NSArray *)getFavouriteTeams {
    NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
    NSArray *arrDictAthletes = [self getUserInfoForKey:@"favorite_teams"];
    for (NSDictionary *dictAthlete in arrDictAthletes) {
        [arrReturn addObject:[dictAthlete objectForKey:@"name"]];
    }
    return arrReturn;
}

#pragma mark - 

-(void)sessionStateChanged:(NSNotification *)notif {
    [self getUserDetails];
}

#pragma mark -

-(void)friendPickerViewControllerSelectionDidChange:(FBFriendPickerViewController *)friendPicker {
    _selectedFriends = friendPicker.selection;
    NSDictionary<FBGraphUser> *friend = [_selectedFriends objectAtIndex:_selectedFriends.count-1];
    NSLog(@"1st friend %@", friend);
    NSLog(@"\nfriend.id %@ \nfriend.first_name %@ \nfriend.name %@ \nfriend.url %@", friend.id, friend.first_name, friend.name, [[[friend objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]);
}

-(void)friendPickerViewController:(FBFriendPickerViewController *)friendPicker handleError:(NSError *)error {
    NSLog(@"error %@ \ndescription %@", error, error.localizedDescription);
    NSLog(@"friendPicker.selection %@", friendPicker.selection);
}

#pragma mark -
/*
-(NSArray *)favoriteTeams {
    NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
    NSArray *arrDictAthletes = [self getUserInfoForKey:@"favorite_teams"];
    for (NSDictionary *dictAthlete in arrDictAthletes) {
        [arrReturn addObject:[dictAthlete objectForKey:@"name"]];
    }
    return arrReturn;
}
*/
#pragma mark -
-(void)dealloc {
    _friendsPickerController.delegate = nil;
    _delegate = nil;
}

@end
