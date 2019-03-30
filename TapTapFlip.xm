//
//  TapTapFlip.xm
//  TapTapFlip
//
//  Created by Juan Carlos Perez <carlos@jcarlosperez.me> on 02/01/2015.
//  Copyright © 2018 CP Digital Darkroom <tweaks@cpdigitaldarkroom.support>. All rights reserved.
//

#import "TapTapFlip.h"


UITapGestureRecognizer *tapGesture;
UIView *previewContainerView;
int cameraMode;

%hook CAMViewfinderViewController
- (void)loadView {
    %orig;

    CAMPreviewViewController *previewController = self._previewViewController;
    tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flipCamera:)] autorelease];
    tapGesture.numberOfTapsRequired = 2;
    tapGesture.numberOfTouchesRequired = 1;
    [previewController.view addGestureRecognizer:tapGesture];
}

%new
- (void)flipCamera:(UITapGestureRecognizer *)sender {

    CAMBottomBar *bBar = self._bottomBar;
    CAMModeDial *dial = bBar.modeDial;
    int currentMode = dial.selectedMode;

    /* Camera Mode Dial Modes - Disable flipping on non-supported modes
    * 0 = Photo
    * 1 = Video
    * 2 = Slo-Mo / Flip not supported stock
    * 3 = Pano / Flip not supported stock
    * 4 = Square
    * 5 = Time-Lapse
    * 6 = Portrait /iOS 11 does support flip
    */

    if([self flipSupportedForMode:currentMode]) {
            CAMFlipButton *flipButton = self._bottomBar.flipButton;
            [flipButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }
}

%new
- (BOOL)flipSupportedForMode:(int)currentMode {
    switch (currentMode) {
        case 0:
        case 1:
        case 4:
        case 5:
            return YES;
        case 6: {
           return YES;
            break;
        }
        default:
            return NO;
    }
}
%end
