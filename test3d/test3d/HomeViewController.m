//
//  HomeViewController.m
//  test3d
//
//  Created by tianpengfei on 16/8/7.
//  Copyright © 2016年 tianpengfei. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController()

@property(strong,nonatomic)SCNNode *cameraHodlerNode;
@property(strong,nonatomic)SCNNode *cameraNode;

@property(nonatomic)BOOL isLeft;

@end

@implementation HomeViewController
@synthesize cameraNode;

-(void)viewDidLoad{

    [super viewDidLoad];
    
    [self.view addSubview:self.scnView];
    
    [self initScene];
}
-(void)initScene{

    _isLeft = true;
    
    // create a new scene
//    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/ship.scn"];
    
//    earth.scn
    
    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/earth.scn"];
    
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
    
    // create and add an ambient light to the scene
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor darkGrayColor];
    [scene.rootNode addChildNode:ambientLightNode];
    
    // retrieve the ship node
    SCNNode *ship = [scene.rootNode childNodeWithName:@"ship" recursively:YES];
    
    // animate the 3d object
    //    [ship runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    
    // set the scene to the view
    self.scnView.scene = scene;
    
    //    // allows the user to manipulate the camera
    //    scnView.allowsCameraControl = YES;
    //
    //    // show statistics such as fps and timing information
    //    scnView.showsStatistics = YES;
    
    // configure the view
    self.scnView.backgroundColor = [UIColor blackColor];
    
    // add a tap gesture recognizer
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    NSMutableArray *gestureRecognizers = [NSMutableArray array];
    [gestureRecognizers addObject:tapGesture];
    [gestureRecognizers addObjectsFromArray:self.scnView.gestureRecognizers];
    self.scnView.gestureRecognizers = gestureRecognizers;
    
    
    [self rotateCameraNode];

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
- (void) handleTap:(UIGestureRecognizer*)gestureRecognize{
    
    [self performSegueWithIdentifier:@"goToDetails" sender:nil];
}

- (BOOL)shouldAutorotate
{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    
    return UIInterfaceOrientationMaskPortrait;
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation == UIDeviceOrientationPortrait;
}

#pragma mark getter

-(SCNView *)scnView{

    if(!_scnView){
    
        float height = self.view.frame.size.width*300.0f/750.0f;
        _scnView = [[SCNView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height)];
    }

    return _scnView;
}

@end
