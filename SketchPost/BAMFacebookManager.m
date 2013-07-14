//
//  BAMFacebookManager.m
//  SketchPost
//
//  Created by Sedat Kilinc on 06.03.13.
//  Copyright (c) 2013 adrodev GmbH. All rights reserved.
/*  All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * Neither the name of the <organization> nor the
 names of its contributors may be used to endorse or promote products
 derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

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
                
            } else {
                NSLog(@"error.localizedDescription %@", error.localizedDescription);
            }
        }];
    }
}

int (^MyBlock)(int) = ^(int num) {
    return num * 3;
};

int (^CompletionHandler)(NSArray*,NSError*) = ^(NSArray *arr, NSError *err) {
    return 1;
};

typedef NSUInteger(^MyCompletionHandler)(NSArray*,NSInteger);

MyCompletionHandler cHandler = ^(NSArray *arr, NSInteger xx) {
    NSLog(@"arr %@, xx %d", arr, xx);
    xx = 20;
    return arr.count;
};

-(void)doStuff:(void (^)(NSArray *array, bool done))handler {
    handler([NSArray arrayWithObject:@"fsfdf"], true);
    
}

-(void)foobar {
    int a = MyBlock(3);
    NSLog(@"%d", a);
    [self blablubb:^int(int num) {
        NSLog(@"num %d", num);
        return 10;
    }];
    __block NSArray *ggg;
    [self fuzzy:@"dings" withInt:12 completionHandler:^(NSArray *array, int x) {
        NSLog(@"watch %@ & %d", array, x);
        ggg = array;
    }];
    NSInteger xx = 2;
    NSUInteger ret;
    ret = cHandler(ggg, xx);
    NSLog(@"xx %d, ret %d", xx, ret);
    
//    [self bussy:^NSUInteger(NSArray *, NSInteger) {
//        NSLog(@"");
//    }];
}

-(void)blablubb:(int (^)(int num))xxx {
    int x = xxx(3);
    NSLog(@"x = %d", x);
}

-(void)fuzzy:(NSString *)szBums withInt:(NSInteger)intZahl completionHandler:(void(^)(NSArray *array, int x))onComplete {
    NSLog(@"szBums %@", szBums);
    NSLog(@"intZahl %d", intZahl);
    NSArray *arr = [NSArray arrayWithObjects:@"eins", @"zwei", @"drei", nil];
    int i = arr.count;
    onComplete(arr, i);
}

-(void)dizzy:(void (^)(NSArray *arr, NSError *err))ccc {
    
}

-(void)bussy:(MyCompletionHandler)x {
    NSArray *arr = [NSArray arrayWithObjects:@"eins", @"zwei", @"drei", nil];
    int i = arr.count;
    NSUInteger bla = x(arr, i);
    NSLog(@"bla %d", bla);
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

-(void)facebookViewControllerCancelWasPressed:(id)sender {
    if ([_delegate respondsToSelector:@selector(friendspickerCancelWasPressed:)]) {
        [_delegate friendspickerCancelWasPressed:sender];
    }
}

-(void)facebookViewControllerDoneWasPressed:(id)sender {
    if ([_delegate respondsToSelector:@selector(friendspickerDoneWasPressed:)]) {
        [_delegate friendspickerDoneWasPressed:sender];
    }
}

#pragma mark -

-(void)uploadImage:(UIImage *)image {
    [self uploadImage:image delegate:nil];
}

-(void)uploadImage:(UIImage *)image delegate:(id<BAMFacebookManagerDelegate>)delegate {
    if(delegate)
        _delegate = delegate;
    FBRequestConnection *rCon = [[FBRequestConnection alloc] init];
    
    FBRequest *req1 = [FBRequest requestForUploadPhoto:image];
    
    [rCon addRequest:req1 completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSLog(@"connection %@, result %@, error %@", connection.urlResponse, result, error.localizedDescription);
    } batchEntryName:@"photopost"];
    
    FBRequest *req2 = [FBRequest requestForGraphPath:@"{result=photopost:$.id}"];
    [rCon addRequest:req2 completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error && result) {
            _currentSource = [result objectForKey:@"source"];
            NSString *picture = [result objectForKey:@"picture"];
            NSString *link = [result objectForKey:@"link"];
            NSLog(@"_currentSource %@", _currentSource);
            NSLog(@"result %@", result);
//            [self publishMessage:@"Watch this!" withSource:_currentSource withPicture:picture withLink:link toUser:nil];
            [self publishMessage:@"Watch this!" withSource:nil withPicture:picture withLink:link toUser:nil];
        }
    }];
    
//    [FBRequest re]
    [rCon start];
}
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


-(void)publishMessage:(NSString *)message withSource:(NSString *)source withPicture:(NSString *)pic withLink:(NSString *)link toUser:(NSString *)user {
    /*
    NSDictionary * facebookParams = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     link,                             @"link",
                                     pic,                            @"picture",
                                     @"sedat",                             @"name",
                                     message, @"message",
                                     source, @"source",
                                     nil];
    */
    NSMutableDictionary *fbParams = [[NSMutableDictionary alloc] init];
    if(message) [fbParams setValue:message forKey:@"message"];
    if(source)  [fbParams setValue:source forKey:@"source"];
    if(pic)  [fbParams setValue:pic forKey:@"picture"];
    if(link)  [fbParams setValue:link forKey:@"link"];
    [fbParams setValue:@"sedat" forKey:@"name"];
    [fbParams setValue:@"SketchPost-App" forKey:@"caption"];
    NSString *szGraphPath = @"me/feed";
    if (_selectedFriends && _selectedFriends.count) {
        
        
        for (FBGraphObject<FBGraphUser> *objUser in _selectedFriends) {
            szGraphPath = [NSString stringWithFormat:@"%@/friends", objUser.id];
        }
    }
    NSLog(@"facebookParams %@", fbParams);
    [FBRequestConnection startWithGraphPath:szGraphPath parameters:fbParams HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSLog(@"connection %@, result %@, error %@", connection.urlResponse, result, error.localizedDescription);
        [_delegate fbRequestDidFinishWithResult:result error:error];
        if(!error)
            [self showMessage:@"\nErfolgreich\n\ngepostet"];
        else
            [self showMessage:@"Sketch\nkonnte nicht\ngepostet werden"];
    }];
    
}

-(void)showMessage:(NSString *)message {
    _av = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [_av show];
}

- (void)didPresentAlertView:(UIAlertView *)alertView {
    
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(closeMessage:) userInfo:nil repeats:NO];
    
}

-(void)closeMessage:(NSTimer *)t {
    [t invalidate];
    t = nil;
    [_av dismissWithClickedButtonIndex:0 animated:YES];
    [_av removeFromSuperview];
}

-(FBAccessTokenData *)accessToken {
    
    FBAccessTokenData *accessTokekData = [[FBSession activeSession] accessTokenData];
    return accessTokekData;
}
#pragma mark -
-(void)dealloc {
    _friendsPickerController.delegate = nil;
    _delegate = nil;
}

@end
