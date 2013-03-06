//
//  ADDRAWViewController.m
//  DrawAppClient
//
//  Created by Sedat Kilinc on 06.03.12.
//  Copyright (c) 2012 Internship. All rights reserved.
//

#define FONT_SIZE 12
#define CANVAS_PDDNG 4.0f

#import "SADDRAWViewController.h"

@interface SADDRAWViewController ()

//@property (retain, nonatomic) UIImage *bild;
//-(void)navButton_Clicked:(id)sender;
-(void)openPicStuff;
//-(void)slider_EventValueChanged:(id)sender;
//-(void)btnUndo_Clicked:(id)sender;
//-(void)btnRedo_Clicked:(id)sender;
//-(void)btnColor_Clicked:(id)sender;
//-(void)btnColor_Done:(id)sender;
-(void)slider_dragged:(id)sender;
-(void)setupCanvas;
-(void)drawHistory;
-(void)textButton_Clicked:(id)sender;
-(void)drawString:(NSString *)value atPoint:(CGPoint)punkt;
-(void)navBtnBack_Clicked:(id)sender;
-(void)navBtnSave_Clicked:(id)sender;
-(void)segmentControlEvent:(id)sender;
//-(void)btnColor_Picked:(id)sender;
-(UIImage *)rotate:(UIImage *)src withDegrees:(double)degrees;
-(void)setUpTopNavBar;
-(void)setupBottomBar;
static inline double radians (double degrees);

@end

@implementation SADDRAWViewController

@synthesize delegatex = _delegatex;
@synthesize m_PopoverController = _m_PopoverController;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Constructor Destructor

-(id)init {
//    LOG_METHOD
    self = [super init];
    if (self) {
        

        
        _arrPaths = [[NSMutableArray alloc] init];
        dictPaths = [[NSMutableDictionary alloc] init];
        pc = 0;
        //        lastPC = 0;
        red = 1.0;
        green = 0.0;
        blue = 0.0;
        alpha = 1.0;
        drawText = NO;
        overlayFont = nil;
        colorPickerVisible = NO;
        canvas2Top = NO;
        vOffset = 0.0;

        _viewActive = false;
        _alreadyTurned = false;
        _locked = false;
        _attachmentCount = 0;
        _attachmentCountAll = 0;
        _currentAttachmentType = @"Sketch";
        _toolBarVisible = false;
        _isFirstCall = YES;
    }
    return self;
}

-(void)dealloc {
//    [picker release];
//    [_arrPaths release];
//    [dictPaths release];
//    [colorPicker release];
//    if (overlayFont)
//        [overlayFont release];
//    if (bild)
//        [bild release];
//    [textButton release];
//    [_bottomBar release];
//    if (tfOverlayText) 
//        [tfOverlayText release];
//    if(_m_PopoverController)
//        [_m_PopoverController release];
//    _delegatex = nil;
//    if (_currentAttachmentIcon)
//        [_currentAttachmentIcon release];
//    [_toolButtons release];

    [super dealloc];
}


#pragma mark - View lifecycle

-(void)loadView {
    [super loadView];
//    
//    _noteView = [[ExhibitionLeadDetailNoteView alloc] init];
//    self.view = _noteView;


    [self setupCanvas];
    [self handleTopBar];
//    [self setUpTopNavBar];
    [self setupBottomBar];

    self.view.clipsToBounds = TRUE;
}





- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    tmpImgVw = nil;
    _lblAnzeige = nil;
    _lblTopAnzeige = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    //    [super viewDidAppear:animated];
    if (_isFirstCall) {
        [self showStartingSelection];
        _isFirstCall = NO;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


- (void) controllerGetDeselected
{
//    self.stepChecked = TRUE;
}





- (void) updateBadgeCount
{
//    if(_attachmentCountAll)
//        self.stepBadge = [NSString stringWithFormat:@"%d",_attachmentCountAll];
//    else
//        self.stepBadge = nil;
}

#pragma mark -

- (void) reset
{
//    self.stepChecked = FALSE;
    
//    _attachmentCount = 0;
//    _attachmentCountAll = 0;
    _currentAttachmentType = nil;
//    _arrAttachments = [NSArray new];
    
//    [self updateStepItemView];
//    [self updateBadgeCount];

    
    tmpImgVw.image = nil;
    if (bild)
        [bild release];
    bild = nil;
    if(_tvNote)
        _tvNote.hidden = YES;
    pc = 0;
}


- (BOOL) isValid
{
    [self saveLastAttachment];
    return TRUE;
}

-(void)setDelegatex:(id<SADDRAWViewControllerDelegate>)delegatex {
    _delegatex = delegatex;
//    self.leadDelegate = (id<LeadCreationViewControllerDelegate>)delegatex;
}
//
//-(void)attachmentIcon_Clicked:(UIButton *)sender {
//    _locked = true;
//    if (_tvNote && !_tvNote.hidden) {
//        [_tvNote resignFirstResponder];
//    }
//    [self saveLastAttachment];
//    
//    _currentAttachmentType = sender.titleLabel.text;
//    if ([_currentAttachmentType isEqualToString:@"Text"]) {
//        [self setupTextView];
//        _currentAttachmentIcon.selected = false;
//        
//        _currentAttachmentIcon = sender;
//        sender.selected = true;
//        return;
//    }
//    NSLog(@"sender.tag %d", sender.tag);
////    NSDictionary *dictLeads = [self.leadDelegate getCurrentLeads];
////    NSArray *arrLeadIDs = [self.leadDelegate getCurrentLeadIDs];
////    ExhibitionLeadDataModel *nextLead;
//    
//    _currentAttachmentIcon.selected = false;
//
//    _currentAttachmentIcon = sender;
//    sender.selected = true;
//
//    NSInteger attachmentIndex = sender.tag - 5000;
//    if (arrLeadIDs.count) {
//        NSString *leadID = [arrLeadIDs objectAtIndex:0];
//        nextLead = [dictLeads objectForKey:leadID];
////        if ([_currentAttachmentType isEqualToString:@"Text"]) {
////            
////        }
////        else
//        _arrAttachments = [nextLead getAttachments];
//        ExhibitionLeadImageAttachmentDataModel *attachModel = [_arrAttachments objectAtIndex:attachmentIndex];
//        tmpImgVw.image = attachModel.image;
//    }
//}

- (void)saveLastAttachment {
    BOOL done = NO;
    if (_attachmentCountAll > 4 || (!tmpImgVw.image && _tvNote.hidden))
        return;
    if(pc > 0) {
        [self saveCurrentImage];
        done = YES;
    }
//    if(_tvNote && !_tvNote.hidden && ![_tvNote.text isEqualToString:@""]) {
//        NSLog(@"_tvNote.text %@, _tvNote.hidden %@", _tvNote.text, (_tvNote.hidden)?@"yes":@"no");
//        NSDictionary *dictLeads = [self.leadDelegate getCurrentLeads];
//        NSArray *arrLeadIDs = [self.leadDelegate getCurrentLeadIDs];
//        for (NSString *leadID in arrLeadIDs) {
//            ExhibitionLeadDataModel *tmpModel = [dictLeads objectForKey:leadID];
//            tmpModel.note = _tvNote.text;
//            [tmpModel save];
//        }
//        done = YES;
//    }
//    if(done)
//        [self addAttachmentIconWithTitle:_currentAttachmentType];
    [self reset];
    [self updateBadgeCount];
}

-(void)btnAddAttachment_Clicked:(id)sender {
    _locked = true;
    if (_tvNote && !_tvNote.hidden) {
        [_tvNote resignFirstResponder];
    }
    UIButton *btnSender = (UIButton *)sender;
    NSArray *arrSelections = [NSArray arrayWithObjects:@"Sketch", @"Image", @"Text", nil];
    [self saveLastAttachment];
    
    if (_attachmentCountAll < 5 )
        [self showPopoverForButton:btnSender withContent:arrSelections];

    [self updateBadgeCount];
//    if (btnSender.tag == 2222) {
//        [btnSender removeFromSuperview];
//    }
}

-(void)addAttachmentIconWithTitle:(NSString *)title {
    if (_currentAttachmentIcon) {
        _currentAttachmentIcon.selected = false;
        //MAKE_FRAME_VISIBLE_GRAY(_currentAttachmentIcon)
        //_currentAttachmentIcon.titleLabel.font = [UIFont systemFontOfSize:11.];
    }
    
    UIButton *btnAttachment = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-71.5-_attachmentCountAll*71.5, 5, 70, 70)];
    btnAttachment.layer.cornerRadius = 10.0f;
    btnAttachment.layer.borderColor = [UIColor darkGrayColor].CGColor;
    [btnAttachment setTitle:title forState:UIControlStateNormal];
    [btnAttachment setTitleColor:[UIColor colorWithRed:138./255. green:138./255. blue:138./255. alpha:1.0] forState:UIControlStateNormal];
    [btnAttachment setTitleColor:[UIColor colorWithRed:0./255. green:145./255. blue:220./255. alpha:1.0] forState:UIControlStateSelected];
    
    btnAttachment.titleEdgeInsets = UIEdgeInsetsMake(btnAttachment.frame.size.height-21, 0, 0, 0);
    [btnAttachment addTarget:self action:@selector(attachmentIcon_Clicked:) forControlEvents:UIControlEventTouchUpInside];
//    [btnAttachment addTarget:self action:@selector(contactIcon_Swiped:) forControlEvents:UIControlEventTouchDragExit];
    if (![_currentAttachmentType isEqualToString:@"Text"]) {
        btnAttachment.tag = 5000 + _attachmentCount;
        _attachmentCount++;
    } else {
        btnAttachment.tag = -1;
    }
    _attachmentCountAll++;
    
/*
    [btnAttachment setBackgroundImage:[UIImage imageNamed:@"exhibition_note_xl.png"] forState:UIControlStateNormal];
    [btnAttachment setBackgroundImage:[UIImage imageNamed:@"exhibition_note_xl.png"] forState:UIControlStateSelected];
    [btnAttachment setBackgroundImage:[UIImage imageNamed:@"exhibition_note_xl.png"] forState:UIControlStateHighlighted];
*/
    [self.noteView.topBar addSubview:btnAttachment];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5,10,btnAttachment.frame.size.width-2*5,btnAttachment.frame.size.height-20-10)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"exhibition_note_xl.png"];
    [btnAttachment addSubview:imageView];
    [imageView release];
    
//    if (_currentAttachmentIcon)
//        [_currentAttachmentIcon release];
//    _currentAttachmentIcon = nil;
    _currentAttachmentIcon = btnAttachment;
//    [_currentAttachmentIcon retain];
    btnAttachment.selected = true;
    btnAttachment.titleLabel.font = [UIFont boldSystemFontOfSize:11.];

    
    btnAttachment.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        _btnAddAttachment.frame = CGRectOffset(_btnAddAttachment.frame, -71.5, 0);
        
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.2 animations:^{
            btnAttachment.alpha = 1;
        }];
        
    }];
    [btnAttachment release];
}



#pragma mark - Receiving AbstractViewResizerProtocol

/*
-(void)resizeForIdentifier:(NSString*)identifier {
    [self removeTopBarViewSubviews];
    if([identifier isEqualToString:kLeadCreateIdentifierBusinesscard] ||
       [identifier isEqualToString:kLeadCreateIdentifierCatalogues]) 
    {
        _viewActive = NO;
        [self.view setFrame:CGRectMake(0,kLeadCreateSizeViewHeight - 2 * kLeadCreateSizeClosedTabHeight,660,kLeadCreateSizeClosedTabHeight)];   
        [_topNavBar setAlpha:.0f];
        attachmentButton.alpha = 0;
        return;
    }
    if([identifier isEqualToString:kLeadCreateIdentifierAttachment]) {
        _viewActive = YES;
        int y = kLeadCreateSizeViewOffset + kLeadCreateSizeClosedTabHeight * kLeadCreateIndexAttachment;
        [self.view setFrame:CGRectMake(0,y,660,kLeadCreateSizeViewHeight - 1 * kLeadCreateSizeClosedTabHeight - y)];    
        [_topNavBar setAlpha:1.0f];
        attachmentButton.alpha = 1;
        return;
    }
    if([identifier isEqualToString:kLeadCreateIdentifierTask]) {
        _viewActive = YES;
        [self.view setFrame:CGRectMake(0,kLeadCreateSizeViewOffset + kLeadCreateSizeClosedTabHeight * kLeadCreateIndexAttachment,660,kLeadCreateSizeClosedTabHeight)];    
        [_topNavBar setAlpha:0];
        attachmentButton.alpha = 0;
        return;
    }
    _viewActive = NO;
    [self.view setFrame:CGRectMake(0,500,660,240)];
    [self removeTopBarViewSubviews];
    [_topNavBar setAlpha:.0f];
    attachmentButton.alpha = 0;
}
*/


#pragma mark - UI Elements

- (void)handleTopBar {
    //    [self removeTopBarViewSubviews];
    _btnAddAttachment = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _btnAddAttachment.frame = CGRectOffset(_btnAddAttachment.frame, _noteView.frame.size.width-60, 40);
    _btnAddAttachment.bounds = CGRectMake(0, 0, 70, 70);
    //[_btnAddAttachment setBackgroundColor:[UIColor colorWithRed:0./255 green:145./255. blue:220./255. alpha:.4]];
    //_btnAddAttachment.layer.cornerRadius = 15.0f;
    //_btnAddAttachment.layer.borderColor = [UIColor colorWithRed:0./255 green:145./255. blue:220./255. alpha:1.0].CGColor;
    //[_btnAddAttachment setTitle:@"+" forState:UIControlStateNormal];
    //[_btnAddAttachment.titleLabel setBackgroundColor:[UIColor colorWithRed:95./255. green:95./255. blue:95./255. alpha:1.0]];
    [_btnAddAttachment setTitle:@"Add" forState:UIControlStateNormal];
    _btnAddAttachment.titleLabel.font = [UIFont boldSystemFontOfSize:11.];
    [_btnAddAttachment setTitleColor:[UIColor colorWithRed:138./255. green:138./255. blue:138./255. alpha:1.0] forState:UIControlStateNormal];
    [_btnAddAttachment setTitleColor:[UIColor colorWithRed:0./255. green:145./255. blue:220./255. alpha:1.0] forState:UIControlStateSelected];
    _btnAddAttachment.titleEdgeInsets = UIEdgeInsetsMake(_btnAddAttachment.frame.size.height-20, 0, 0, 0);
    [_btnAddAttachment setBackgroundImage:[UIImage imageNamed:@"exhibition_contact_add.png"] forState:UIControlStateNormal];
    [_btnAddAttachment setBackgroundImage:[UIImage imageNamed:@"exhibition_contact_add.png"] forState:UIControlStateSelected];
    [_btnAddAttachment setBackgroundImage:[UIImage imageNamed:@"exhibition_contact_add.png"] forState:UIControlStateHighlighted];
    [_btnAddAttachment addTarget:self action:@selector(btnAddAttachment_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [_noteView addSubview:_btnAddAttachment];
}

-(void)setUpTopNavBar {
//    _topNavBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
//    [_topNavBar setBackgroundColor:[UIColor whiteColor]];
//    [_topNavBar setAlpha:0.0];
    /*
    UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 60, 40)];
    [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(navBtnBack_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [_topNavBar addSubview:btnCancel];
    [btnCancel release];
    */
    
    _toolButtons = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Linie", @"Bild laden", @"A", @"Tools", nil]];
    _toolButtons.tag = 2000;
    _toolButtons.frame = CGRectMake(/*_noteView.topBar.frame.size.width/2+*/(_noteView.topBar.frame.size.width/2-30)/2 - 185/2, 100, 285, 40);
    _toolButtons.segmentedControlStyle = UISegmentedControlStyleBar;
    _toolButtons.selectedSegmentIndex = 0;
    [_toolButtons addTarget:self action:@selector(segmentControlEvent:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_toolButtons];
    
    /*
    UIButton *btnSave = [[UIButton alloc] initWithFrame:CGRectMake(410, 0, 60, 40)];
    [btnSave setTitle:@"Save" forState:UIControlStateNormal];
    [btnSave addTarget:self action:@selector(navBtnSave_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [_topNavBar addSubview:btnSave];
    [btnSave release];
    */
//    [self.view addSubview:_topNavBar];
//    [_topNavBar release];
}

-(void)setupBottomBar {
    _bottomBar = [[UIView alloc] initWithFrame:CGRectMake(4 , self.view.frame.size.height-54, 700, 42)];
//    _bottomBar.image = [UIImage imageNamed:@"exhibition_note_toolbar.png"];
    //    _bottomBar.layer.cornerRadius = 10.f;
    [_bottomBar setBackgroundColor:[UIColor whiteColor]];
//    [_bottomBar setAlpha:1.0];
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake((_bottomBar.frame.size.width-130)/2, (_bottomBar.frame.size.height-30)/2, 130, 30)];
    [slider setMinimumValue:0.0];
    [slider setMaximumValue:20.0];
    slider.value = 5.0;
    _radius = slider.value;
    [slider addTarget:self action:@selector(slider_EventValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_bottomBar addSubview:slider];
    [slider release];
    // Colorpicker
    btnColor = [UIButton buttonWithType:UIButtonTypeCustom];
    btnColor.layer.cornerRadius = 6.0f;
    [btnColor setFrame:CGRectMake(self.view.frame.size.width-75, 1, 40, 40)];
    [btnColor setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:.5]];
    [btnColor addTarget:self action:@selector(btnColor_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBar addSubview:btnColor];
    
    UIButton *btnUndo = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnUndo setFrame:CGRectMake(20, 4, 34, 34)];
    [btnUndo addTarget:self action:@selector(btnUndo_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    btnUndo.layer.cornerRadius = 6.0f;
    [btnUndo setBackgroundImage:[UIImage imageNamed:@"button_lead_undo.png"] forState:UIControlStateNormal];
    [_bottomBar addSubview:btnUndo];

    // Redo-Button
    UIButton *btnRedo = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRedo setFrame:CGRectOffset(btnUndo.frame, 47, 0)];
    [btnRedo addTarget:self action:@selector(btnRedo_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    btnRedo.layer.cornerRadius = 6.0f;
    [btnRedo setBackgroundImage:[UIImage imageNamed:@"button_lead_redo.png"] forState:UIControlStateNormal];
    [_bottomBar addSubview:btnRedo];

    
    UIButton *btnLetters = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLetters setFrame:CGRectOffset(btnRedo.frame, 424, 0)];
    [btnLetters addTarget:self action:@selector(btnLetters_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    btnLetters.layer.cornerRadius = 6.0f;
    [btnLetters setBackgroundImage:[UIImage imageNamed:@"button_lead_note.png"] forState:UIControlStateNormal];
    [_bottomBar addSubview:btnLetters];
    
    UIButton *btnPictures = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnPictures setFrame:CGRectOffset(btnLetters.frame, 47, 0)];
    [btnPictures addTarget:self action:@selector(btnPictures_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    btnPictures.layer.cornerRadius = 6.0f;
    [btnPictures setBackgroundImage:[UIImage imageNamed:@"button_lead_pic.png"] forState:UIControlStateNormal];
    [_bottomBar addSubview:btnPictures];
    
    UIButton *btnLines = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLines setFrame:CGRectOffset(btnPictures.frame, 47, 0)];
    [btnLines addTarget:self action:@selector(btnLines_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    btnLines.layer.cornerRadius = 6.0f;
    [btnLines setBackgroundImage:[UIImage imageNamed:@"button_lead_paint.png"] forState:UIControlStateNormal];
    [_bottomBar addSubview:btnLines];
    
    [self.view addSubview:_bottomBar];
//    MAKE_FRAME_VISIBLE_GREEN(btnUndo)
//    MAKE_FRAME_VISIBLE_RED(btnRedo)
//    MAKE_FRAME_VISIBLE_RED(btnLetters)
//    MAKE_FRAME_VISIBLE_RED(btnPictures)
//    MAKE_FRAME_VISIBLE_RED(btnLines)
//    MAKE_FRAME_VISIBLE_GRAY(_bottomBar)
    _bottomBar.hidden = YES;
}

-(void)setupCanvas {
    _canvasContainer = [[UIView alloc] initWithFrame:CGRectMake(CANVAS_PDDNG+1, _noteView.topBar.frame.size.height-1+CANVAS_PDDNG, _noteView.bounds.size.width-2*CANVAS_PDDNG-1, _noteView.bounds.size.height-_noteView.topBar.frame.size.height-2*CANVAS_PDDNG)];
//    tmpImgVw = [[UIImageView alloc] initWithFrame:CGRectMake(CANVAS_PDDNG+1, _noteView.topBar.frame.size.height-1+CANVAS_PDDNG, _noteView.bounds.size.width-2*CANVAS_PDDNG-1, _noteView.bounds.size.height-_noteView.topBar.frame.size.height-2*CANVAS_PDDNG)];
    tmpImgVw = [[UIImageView alloc] initWithFrame:_canvasContainer.bounds];
    [tmpImgVw setClipsToBounds:YES];
    tmpImgVw.contentMode = UIViewContentModeScaleAspectFill;
    [tmpImgVw setBackgroundColor:[UIColor clearColor]];
    tmpImgVw.layer.cornerRadius = 5.0f;
    [_canvasContainer addSubview:tmpImgVw];
    [self.view addSubview:_canvasContainer];
    _locked = true;
    [_noteView bringSubviewToFront:_noteView.topBar];
}

#pragma mark - Public Methods

-(void)saveCurrentImage {
    if(tmpImgVw.image) {
        [self navBtnSave_Clicked:nil];
    }
}

#pragma mark - UI Element Events

- (void) onAttachmentButtonPressed
{
    [self openPicStuff];
}

-(void)openPicStuff {
//    LOG_METHOD
    
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    /*
    UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:@"Bildquelle" delegate:self cancelButtonTitle:@"Abbruch" destructiveButtonTitle:nil otherButtonTitles:@"Kamera", @"Album", @"Gespeicherte", nil];
    actSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actSheet showInView:self.view];
    [actSheet release];
     */
     
    
    // @issue SMS-1271 .. direkt cam statt menü
    [self actionSheet:nil clickedButtonAtIndex:0];
    
}

-(void)navBtnBack_Clicked:(id)sender {
//    LOG_METHOD
    if([_delegatex respondsToSelector:@selector(OnSketchADDRAWViewControllerCancel:)])
        [_delegatex OnSketchADDRAWViewControllerCancel:self];
}

-(void)navBtnSave_Clicked:(id)sender {
//    LOG_METHOD
    if([_delegatex respondsToSelector:@selector(OnSketchADDRAWViewController:saveImage:)])
        [_delegatex OnSketchADDRAWViewController:self saveImage:tmpImgVw.image];
}

-(void)slider_EventValueChanged:(UISlider *)sender {
    _radius = sender.value;
    [_lblAnzeige setText:[NSString stringWithFormat:@"%.1f", _radius]];
}

-(void)slider_dragged:(id)sender {
    NSLog(@"hi");
}

-(void)segmentControlEvent:(id)sender {
//    LOG_METHOD
    UISegmentedControl *tmp = (UISegmentedControl *)sender;
    NSLog(@"index %d", tmp.selectedSegmentIndex);
    
    switch (tmp.selectedSegmentIndex) {
        case 0:
            drawText = NO;
            break;
        case 1:
            [self openPicStuff];
            [tmp setSelectedSegmentIndex:0];
            drawText = NO;
            break;
        case 2:
            [self textButton_Clicked:sender];
            break;
        case 3:
            _toolBarVisible = (_toolBarVisible)?false:true;
            [self showToolbar:_toolBarVisible];
            tmp.selectedSegmentIndex = 0;
            break;
        default:
            break;
    }
}

-(void)showToolbar:(BOOL)visible {
    NSLog(@"_toolBarVisible %d", _toolBarVisible);
    NSInteger vektor = (visible) ? -1 : 1;
    [UIView animateWithDuration:.6 animations:^{
        _bottomBar.frame = CGRectOffset(_bottomBar.frame, vektor*(_bottomBar.frame.size.width+10), 0);
    }];
    
}

-(void)btnUndo_Clicked:(id)sender {
//    LOG_METHOD
    //NSLog(@"dictPaths count = %d, pic counter = %d", [dictPaths count], pc);
    
    pc--;
    if (pc < 0) {
        tmpImgVw.image = nil;
        pc = -1;
    } else {
        //        NSMutableArray *tmpPaths = [NSMutableArray arrayWithArray:_arrPaths];
        [self drawHistory];
    }
}

-(void)btnRedo_Clicked:(id)sender {
    if (pc == [dictPaths count]) {
        return;
    } else {
        pc++;
        
        [self drawHistory];
    }
}

-(void)btnLetters_Clicked:(UIButton *)sender {
    drawText = YES;
}

-(void)btnLines_Clicked:(UIButton *)sender {
    drawText = NO;
}

-(void)btnPictures_Clicked:(UIButton *)sender {
    [self openPicStuff];
}

-(void)btnColor_Clicked:(id)sender {
//    LOG_METHOD

    if (!colorPickerVisible) {
        UIView *colorContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width*4/5, 44)];
        UIButton *btnRed = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, colorContainer.frame.size.width/4, 44)];
        btnRed.tag = 9100;
        [btnRed setBackgroundColor:[UIColor redColor]];
        [btnRed addTarget:self action:@selector(btnColor_Picked:) forControlEvents:UIControlEventTouchUpInside];
        [colorContainer addSubview:btnRed];
        [btnRed release];
        UIButton *btnGreen = [[UIButton alloc] initWithFrame:CGRectOffset(btnRed.frame, colorContainer.frame.size.width/4, 0)];
        btnGreen.tag = 9010;
        [btnGreen setBackgroundColor:[UIColor greenColor]];
        [btnGreen addTarget:self action:@selector(btnColor_Picked:) forControlEvents:UIControlEventTouchUpInside];
        [colorContainer addSubview:btnGreen];
        [btnGreen release];
        UIButton *btnBlue = [[UIButton alloc] initWithFrame:CGRectOffset(btnGreen.frame, colorContainer.frame.size.width/4, 0)];
        btnBlue.tag = 9001;
        [btnBlue setBackgroundColor:[UIColor blueColor]];
        [btnBlue addTarget:self action:@selector(btnColor_Picked:) forControlEvents:UIControlEventTouchUpInside];
        [colorContainer addSubview:btnBlue];
        [btnBlue release];
        UIButton *btnBlack = [[UIButton alloc] initWithFrame:CGRectOffset(btnBlue.frame, colorContainer.frame.size.width/4, 0)];
        btnBlack.tag = 9000;
        [btnBlack setBackgroundColor:[UIColor blackColor]];
        [btnBlack addTarget:self action:@selector(btnColor_Picked:) forControlEvents:UIControlEventTouchUpInside];
        [colorContainer addSubview:btnBlack];
        [btnBlack release];
        [self.view addSubview:colorContainer];
        [colorContainer setBackgroundColor:[UIColor yellowColor]];
        [colorContainer release];
        colorPickerVisible = YES;
    }
}

-(void)btnColor_Picked:(UIButton *)sender {
    switch (sender.tag) {
        case 9100:
            red = 1.0;
            green = 0.0;
            blue = 0.0;
            break;
        case 9010:
            red = 0.0;
            green = 1.0;
            blue = 0.0;
            break; 
        case 9001:
            red = 0.0;
            green = 0.0;
            blue = 1.0;
            break;   
        default:
            red = 0.0;
            green = 0.0;
            blue = 0.0;
            break;
    }
    [sender.superview removeFromSuperview];
    colorPickerVisible = NO;
}


-(void)drawHistory {
    //NSLog(@"PC = %d", pc);
    CGMutablePathRef p;
    CGFloat lRed;
    CGFloat lGreen;
    CGFloat lBlue;
    CGFloat lAlpha;
    CGFloat lRadius;
    NSString *lText;
    CGPoint lPoint;
    
    if(bild)
        [tmpImgVw setImage:bild];
    
    UIGraphicsBeginImageContext(tmpImgVw.frame.size);
    
    [tmpImgVw.image drawInRect:tmpImgVw.bounds];
    for (int i = 0; i < pc; i++) {
        //            p = (CGMutablePathRef)[tmpPaths objectAtIndex:i];
        NSArray *pObj = [dictPaths objectForKey:[NSString stringWithFormat:@"%d", i]];
        lRed = [[pObj objectAtIndex:1] floatValue];
        lGreen = [[pObj objectAtIndex:2] floatValue];
        lBlue = [[pObj objectAtIndex:3] floatValue];
        lAlpha = [[pObj objectAtIndex:4] floatValue];
        lRadius = [[pObj objectAtIndex:5] floatValue];
        if ([[pObj objectAtIndex:0] isKindOfClass:[NSString class]]) {
            lText = [pObj objectAtIndex:0];
            lPoint = CGPointMake([[[pObj objectAtIndex:6] objectAtIndex:0] floatValue], [[[pObj objectAtIndex:6] objectAtIndex:1] floatValue]);
            [[UIColor colorWithRed:lRed green:lGreen blue:lBlue alpha:lAlpha] set];
            [lText drawAtPoint:lPoint withFont:overlayFont];
        } else {
            p = (CGMutablePathRef)[pObj objectAtIndex:0];
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), lRed, lGreen, lBlue, lAlpha);
            CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), lRadius);
            CGContextAddPath(UIGraphicsGetCurrentContext(), p);
            CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathStroke);
        }
        
        
        
    }
    tmpImgVw.image = UIGraphicsGetImageFromCurrentImageContext();
    //        [tmpPaths removeLastObject];
    
    UIGraphicsEndImageContext();
}

-(void)textButton_Clicked:(id)sender {
    //    [sender setBackgroundColor:[UIColor blueColor]];
    drawText = YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (canvas2Top) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
//        tmpImgVw.frame = self.view.bounds;
        _canvasContainer.frame = CGRectOffset(_canvasContainer.frame, 0, -vOffset);
        [UIView commitAnimations];
        canvas2Top = NO;
        vOffset = 0.0;
    }
    overlayText = textField.text;
    [self drawString:textField.text atPoint:lastPoint];
    NSNumber *nRed = [NSNumber numberWithFloat:red];
    NSNumber *nGreen = [NSNumber numberWithFloat:green];
    NSNumber *nBlue = [NSNumber numberWithFloat:blue];
    NSNumber *nAlpha = [NSNumber numberWithFloat:alpha];
    NSNumber *nRadius = [NSNumber numberWithFloat:_radius];
    NSNumber *lX = [NSNumber numberWithFloat:lastPoint.x];
    NSNumber *lY = [NSNumber numberWithFloat:lastPoint.y];
    NSArray *point = [NSArray arrayWithObjects:lX, lY, nil];
    NSArray *pathObject = [NSArray arrayWithObjects:textField.text, nRed, nGreen, nBlue, nAlpha, nRadius, point, nil];
    [dictPaths setObject:pathObject forKey:[NSString stringWithFormat:@"%d", pc]];
    [textField removeFromSuperview];
    [textButton setBackgroundColor:[UIColor clearColor]];
    [tfOverlayText release];
    tfOverlayText = nil;
    overlayText = @"";
    pc++;
    _toolButtons.selectedSegmentIndex = 0;
    drawText = NO;
    return NO;
}

-(void)drawString:(NSString *)value atPoint:(CGPoint)punkt  {
    UIGraphicsBeginImageContext(tmpImgVw.frame.size);
    [tmpImgVw.image drawInRect:tmpImgVw.bounds];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), _radius);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, alpha);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    
    //    [[UIColor blackColor] set];
    //    [chartColor set];
    //    CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1, -1);
    //    CGSize size = [value sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE]];
    //    if (m<0)
    //        m -= size.height;
    //    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), -size.width/2, -2*punkt.y+m);            
    //    punkt.y -= 3;
    //    punkt.y *= 0.9;
    [[UIColor colorWithRed:red green:green blue:blue alpha:alpha] set];
    [value drawAtPoint:punkt withFont:overlayFont];
    tmpImgVw.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

-(void)setupTextView {
    if(!_tvNote) {
        _tvNote = [[UITextView alloc] initWithFrame:_canvasContainer.frame];
        _tvNote.font = [UIFont fontWithName:@".HelveticaNeueUI-Bold" size:18];
        [_tvNote setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_noteView addSubview:_tvNote];
    }
    [_contentController disableRowAt:2];
//    _tvNote.text = @"";
//    [_tvNote clearsContextBeforeDrawing];
    _tvNote.hidden = NO;
    
    [_tvNote becomeFirstResponder];
}

-(void)showStartingSelection {
//    UIButton *btnFoo = [[UIButton alloc] initWithFrame:CGRectMake(self.noteView.topBar.frame.size.width- 75, 10, 70, 70)];
//    btnFoo.alpha = 0.0f;
//    btnFoo.tag = 2222;
//    [self.noteView.topBar addSubview:btnFoo];
    [self btnAddAttachment_Clicked:_btnAddAttachment];
}

#pragma mark - PopoverContentViewControllerDelegate



-(void)itemSelected:(NSString *)szItem atRow:(NSInteger)row {
    switch (row) {
        case 0:
            [self unlockDrawing];
            _bottomBar.hidden = NO;
            _currentAttachmentType = @"Sketch";
            [self addAttachmentIconWithTitle:_currentAttachmentType];
            break;
        case 1:
            [self openPicStuff];
            _bottomBar.hidden = YES;
            _currentAttachmentType = @"Image";
            break;
        case 2:
            [self setupTextView];
            _bottomBar.hidden = YES;
            _currentAttachmentType = @"Text";
            [self addAttachmentIconWithTitle:_currentAttachmentType];
            break;
        default:
            break;
    }
    
    [self dismissCurrentPopoverController];
    
}

#pragma mark - ActionSheet Events

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"ActionSheetButtonIndex %d", buttonIndex);
    switch (buttonIndex) {
        case 0:
            NSLog(@"Kamera");
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;

            break;
        case 1:
            NSLog(@"Album");
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            break;
        case 2:
            NSLog(@"Gespeicherte");
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            picker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
            picker.allowsEditing = NO;
            
            
            break;
        default:
            NSLog(@"Cancel");
            break;
    }
    if (picker.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum || picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        _m_PopoverController = [[UIPopoverController alloc] initWithContentViewController:picker];
        _m_PopoverController.delegate = self;
        [_m_PopoverController presentPopoverFromRect:attachmentButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    } else {
        [self presentModalViewController:picker animated:YES];
        picker.view.frame = CGRectOffset(picker.view.frame, 0, -25);
    }
}

#pragma mark - Touch Events

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    if (_locked)
        return;
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:tmpImgVw];
    _lblTopAnzeige.text = [NSString stringWithFormat:@"%d", [touch tapCount]];
    mouseSwiped = NO;
    lastPoint = p;
    //    lastPoint.y -= 15;
//    lastPoint.y *= 0.9;
    path = CGPathCreateMutable();
    
}

-(BOOL)isLocked {
//    BOOL locked = true;
    /*
    if (!_calledBefore) {
        _calledBefore = true;
        return _calledBefore;
    }
    NSLog(@"self.view.frame %@", NSStringFromCGRect(self.view.frame));
    if (self.view.frame.size.width == 660 && self.view.frame.size.height == 700) {
        locked = false;
    }
    */
//    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(unlockDrawing) userInfo:nil repeats:NO];
    return _locked;
}

-(void)unlockDrawing {
    _locked = false;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_locked)
        return;
    
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:tmpImgVw];
    _lblTopAnzeige.text = [NSString stringWithFormat:@"%.0f/%.0f", currentPoint.x, currentPoint.y];

    if (!drawText) {
        UIGraphicsBeginImageContext(tmpImgVw.frame.size);

        
        [tmpImgVw.image drawInRect:tmpImgVw.bounds];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), _radius);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, alpha);
        CGContextBeginPath(UIGraphicsGetCurrentContext());
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        
        CGPathMoveToPoint(path, NULL,lastPoint.x, lastPoint.y);
        
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        
        CGPathAddLineToPoint(path, NULL, currentPoint.x, currentPoint.y);
        
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        
        tmpImgVw.image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        lastPoint = currentPoint;
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_locked)
        return;
    _lblTopAnzeige.text = @"";
    UITouch *touch = [touches anyObject];
    
    if ([touch tapCount] == 2) {

        [self reset];
        return;
    }
    
    if (!drawText) {
        if(!mouseSwiped) {
            UIGraphicsBeginImageContext(tmpImgVw.frame.size);
            [tmpImgVw.image drawInRect:tmpImgVw.bounds];
            CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), _radius);
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, alpha);
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
            
            CGPathMoveToPoint(path, NULL,lastPoint.x, lastPoint.y);
            
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
            
            CGPathAddLineToPoint(path, NULL, lastPoint.x, lastPoint.y);
            
            CGContextStrokePath(UIGraphicsGetCurrentContext());
            //CGContextFlush(UIGraphicsGetCurrentContext());
            tmpImgVw.image = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
        }
        
        //        [_arrPaths addObject:(id)path];
        NSNumber *nRed = [NSNumber numberWithFloat:red];
        NSNumber *nGreen = [NSNumber numberWithFloat:green];
        NSNumber *nBlue = [NSNumber numberWithFloat:blue];
        NSNumber *nAlpha = [NSNumber numberWithFloat:alpha];
        NSNumber *nRadius = [NSNumber numberWithFloat:_radius];
        NSArray *pathObject = [NSArray arrayWithObjects:(id)path, nRed, nGreen, nBlue, nAlpha, nRadius, nil];
        [dictPaths setObject:pathObject forKey:[NSString stringWithFormat:@"%d", pc]];
        CGPathRelease(path);
        path = CGPathCreateMutable();
        
        pc++;
        
    } else {
        if (tfOverlayText) {
            
            [tfOverlayText removeFromSuperview];
            [tfOverlayText release];
            tfOverlayText = nil;
        }
        
        tfOverlayText = [[UITextField alloc] initWithFrame:CGRectMake(lastPoint.x, lastPoint.y, 150, _radius*4.0)];
        [tfOverlayText setBackgroundColor:[UIColor clearColor]];
        tfOverlayText.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        tfOverlayText.delegate = self;
        [tfOverlayText setBorderStyle:UITextBorderStyleLine];
        [tfOverlayText setFont:[UIFont systemFontOfSize:_radius*3.0]];
        [tmpImgVw addSubview:tfOverlayText];
        [tfOverlayText becomeFirstResponder];
        overlayFont = tfOverlayText.font;
        [overlayFont retain];
        if (lastPoint.y > 600.0 && !canvas2Top) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            vOffset = 600.0-lastPoint.y;
            _canvasContainer.frame = CGRectOffset(_canvasContainer.frame, 0, vOffset);
            
            [UIView commitAnimations];
            canvas2Top = YES;
        }
    }
    
    
    //    lastPC++;
    
    for (int j=pc; j<[dictPaths count]; j++) {
        [dictPaths removeObjectForKey:[NSString stringWithFormat:@"%d", j]];
    }
    //NSLog(@"dictPaths : %@", dictPaths);
    
}

#pragma mark - UIImagePicker Events

-(void)imagePickerController:(UIImagePickerController *)lpicker 
       didFinishPickingImage:(UIImage *)image 
                 editingInfo:(NSDictionary *)editingInfo {
    NSLog(@"editingInfo %@", editingInfo);
    if (image != nil) {
        
        if (bild) {
            [bild release];
        }
        bild = [image retain];
        [tmpImgVw setImage:image];
        
        [dictPaths removeAllObjects];
        pc = 1;
        if ([_currentAttachmentType isEqualToString:@"Text"])
            [self saveLastAttachment];
    }
    [self dismissModalViewControllerAnimated:YES];
    if (_m_PopoverController && _m_PopoverController.isPopoverVisible) {
        [_m_PopoverController dismissPopoverAnimated:YES];
    }
    if ([_currentAttachmentType isEqualToString:@"Image"])
        [self addAttachmentIconWithTitle:@"Image"];
}

static inline double radians (double degrees) {return degrees * M_PI/180;}

-(UIImage *)rotate:(UIImage *)src withDegrees:(double)degrees
{
    UIImage *retImage;
    UIGraphicsBeginImageContext(src.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextRotateCTM (context, radians(degrees));
    
    //    [src drawAtPoint:CGPointMake(0, 0)];
    CGContextDrawImage(context, tmpImgVw.frame, src.CGImage);
    
    retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [retImage autorelease];
//    CGContextRelease(context);
    return retImage;
}
//
//-(ExhibitionLeadAttachmentType)getCurrentAttachmenType {
//    if([_currentAttachmentType isEqualToString:@"Sketch"])
//        return ExhibitionLeadAttachmentTypeSketch;
//    if([_currentAttachmentType isEqualToString:@"Image"])
//        return ExhibitionLeadAttachmentTypeImage;
//    if([_currentAttachmentType isEqualToString:@"Text"])
//        return ExhibitionLeadAttachmentTypeNote;
//    return ExhibitionLeadAttachmentTypeUnkown;
//}

@end

//#endif