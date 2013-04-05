//
//  BAMFacebookManager.h
//  SketchPost
//
//  Created by Sedat Kilinc on 06.03.13.
//  Copyright (c) 2013 adrodev GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

/*
@protocol BAMUser <FBGraphUser>

@property (readonly, nonatomic, getter = favoriteTeams) NSArray *favoriteTeams;

@end
*/

@protocol BAMFacebookManagerDelegate <NSObject>

-(void)userDetailsFetched:(NSDictionary<FBGraphUser> *)user;
-(void)friendspickerDoneWasPressed:(id)sender;
-(void)friendspickerCancelWasPressed:(id)sender;
-(void)fbRequestDidFinishWithResult:(id)result error:(NSError *)err;

@end

@interface BAMFacebookManager : NSObject <FBFriendPickerDelegate, UIAlertViewDelegate /*, BAMUser*/> {
    NSDictionary<FBGraphUser> *_user;
    FBFriendPickerViewController *_friendsPickerController;
    NSString *_currentSource;
    UIAlertView *_av;

}

@property (unsafe_unretained) id<BAMFacebookManagerDelegate> delegate;
@property (readonly) FBFriendPickerViewController *friendsPickerController;
@property (strong, nonatomic) NSArray *selectedFriends;

/*@property (strong, nonatomic) NSDictionary<BAMUser> *bamUser;*/

+(BAMFacebookManager *)shared;

-(void)getUserDetails;

-(NSString *)getUserBio;
-(NSArray *)getUserEducation;
-(NSArray *)getFavouriteAthletes;
-(NSArray *)getFavouriteTeams;
-(void)uploadImage:(UIImage *)image;
-(void)uploadImage:(UIImage *)image delegate:(id<BAMFacebookManagerDelegate>)delegate;
-(void)publishMessage:(NSString *)message withSource:(NSString *)source withPicture:(NSString *)pic withLink:(NSString *)link toUser:(NSString *)user;

@end
