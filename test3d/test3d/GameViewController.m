//
//  GameViewController.m
//  test3d
//
//  Created by tianpengfei on 16/8/5.
//  Copyright (c) 2016年 tianpengfei. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController()<UIActionSheetDelegate>

@property(strong,nonatomic)SCNNode *cameraHodlerNode;
@property(strong,nonatomic)SCNNode *cameraNode;

@property(nonatomic)BOOL isLeft;

@end

@implementation GameViewController
@synthesize cameraNode;

- (void)viewDidLoad
{
    [super viewDidLoad];

    _isLeft = true;
    
    // create a new scene
    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/ship.scn"];

    self.cameraHodlerNode = [SCNNode node];
    
    // create and add a camera to the scene
    cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    
    [self.cameraHodlerNode addChildNode:cameraNode];
    [scene.rootNode addChildNode:self.cameraHodlerNode];
    
    // place the camera
    cameraNode.position = SCNVector3Make(20, 5, 20);
    
    cameraNode.eulerAngles = SCNVector3Make(0,M_PI/4, 0);
    
    // create and add a light to the scene
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    lightNode.position = SCNVector3Make(0, 10, 10);
    [scene.rootNode addChildNode:lightNode];
    lightNode.name = @"OmniLight";
    
    // create and add an ambient light to the scene
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor darkGrayColor];
    [scene.rootNode addChildNode:ambientLightNode];
    
    ambientLightNode.name = @"ambientLight";
    
    // retrieve the ship node
    SCNNode *ship = [scene.rootNode childNodeWithName:@"ship" recursively:YES];
    
    // animate the 3d object
//    [ship runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    
    // retrieve the SCNView
    SCNView *scnView = (SCNView *)self.view;
    
    // set the scene to the view
    scnView.scene = scene;
    
//    // allows the user to manipulate the camera
//    scnView.allowsCameraControl = YES;
//        
//    // show statistics such as fps and timing information
//    scnView.showsStatistics = YES;

    // configure the view
    scnView.backgroundColor = [UIColor blackColor];
    
    // add a tap gesture recognizer
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    NSMutableArray *gestureRecognizers = [NSMutableArray array];
    [gestureRecognizers addObject:tapGesture];
    [gestureRecognizers addObjectsFromArray:scnView.gestureRecognizers];
    scnView.gestureRecognizers = gestureRecognizers;
    
    
    [self rotateCameraNode];

}

- (void) handleTap:(UIGestureRecognizer*)gestureRecognize
{
//    // retrieve the SCNView
//    SCNView *scnView = (SCNView *)self.view;
//    
//    // check what nodes are tapped
//    CGPoint p = [gestureRecognize locationInView:scnView];
//    NSArray *hitResults = [scnView hitTest:p options:nil];
//    
//    // check that we clicked on at least one object
//    if([hitResults count] > 0){
//        // retrieved the first clicked object
//        SCNHitTestResult *result = [hitResults objectAtIndex:0];
//        
//        // get its material
//        SCNMaterial *material = result.node.geometry.firstMaterial;
//        
//        // highlight it
//        [SCNTransaction begin];
//        [SCNTransaction setAnimationDuration:0.5];
//        
//        // on completion - unhighlight
//        [SCNTransaction setCompletionBlock:^{
//            [SCNTransaction begin];
//            [SCNTransaction setAnimationDuration:0.5];
//            
//            material.emission.contents = [UIColor blackColor];
//            
//            [SCNTransaction commit];
//        }];
//        
//        material.emission.contents = [UIColor redColor];
//        
//        [SCNTransaction commit];
//    }
    
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出" otherButtonTitles:@"模拟灯光", nil];
    [actionSheet showInView:self.view];
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    switch (buttonIndex) {
        case 0:
            
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            
            break;
        case 1:
            
            [self addLight];
            
            break;
        case 2:
            
            break;
        default:
            break;
    }
}

-(void)rotateCameraNode{

    // animate the 3d object
//        [self.cameraHodlerNode runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:2]]];
    
    float delay = 8.0f;
    
    [self.cameraHodlerNode runAction:[SCNAction rotateByX:0
                                                        y:_isLeft?-2:2
                                   z:0
                            duration:delay]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        _isLeft = !_isLeft;
        [self rotateCameraNode];
    });
    
}
-(void)addLight{
    
    SCNScene *scene = [(SCNView *)self.view scene];
    
    SCNNode *omniLightNode = [scene.rootNode childNodeWithName:@"OmniLight" recursively:YES];
    omniLightNode.hidden = !omniLightNode.hidden;
//    [omniLightNode removeFromParentNode];
    
    SCNNode *ambientLightNode = [scene.rootNode childNodeWithName:@"ambientLight" recursively:YES];
    ambientLightNode.light.color = [UIColor colorWithWhite:0.2 alpha:1.0];
//     ambientLightNode.light.color = [UIColor blackColor];
    
    SCNNode *spotLightNode = [scene.rootNode childNodeWithName:@"spot" recursively:YES];
    spotLightNode.hidden = !spotLightNode.hidden;
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    
    return UIInterfaceOrientationMaskLandscapeRight|UIInterfaceOrientationMaskLandscapeLeft;
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation != UIDeviceOrientationPortraitUpsideDown;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark Action


#pragma mark getter

@end
