//
//  ViewController.m
//  DecomposedObjectiveC
//
//  Created by Adam Bell on 5/26/20.
//  Copyright © 2020 Adam Bell. All rights reserved.
//

#import "ViewController.h"

#import <Decomposed/Decomposed.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  CATransform3D transform = CATransform3DMakeScale(0.5, 2.0, 0.75);

  DEDecomposedCATransform3D *decomposed = [[DEDecomposedCATransform3D alloc] initWithTransform:transform];
  decomposed.translation = simd_make_double3(64.0, 44.0, 0.0);
  CATransform3D translatedTransform = [decomposed recomposed];
  NSLog(@"%@\n", NSStringFromCATransform3D(translatedTransform));

  DEDecomposedCATransform3D *otherDecomposed = [DEDecomposedCATransform3D decomposedTransformWithTransform:transform];
  otherDecomposed.translation = simd_make_double3(64.0, 44.0, 0.0);
  CATransform3D otherTranslatedTransform = [decomposed recomposed];
  NSLog(@"%@\n", NSStringFromCATransform3D(otherTranslatedTransform));

  self.view.layer.transformProxy.scale = CGPointMake(0.88, 0.88);
}

NSString *NSStringFromCATransform3D(CATransform3D transform)
{
  return [NSString stringWithFormat:@"CATransform3D = [ m11: %f, m12: %f, m13: %f, m14: %f, \n  m21: %f, m22: %f, m23: %f, m24: %f, \n  m31: %f, m32: %f, m33: %f, m34: %f, \n  m41: %f, m42: %f, m43: %f, m44: %f ]",
          transform.m11, transform.m12, transform.m13, transform.m14,
          transform.m21, transform.m22, transform.m23, transform.m24,
          transform.m31, transform.m32, transform.m33, transform.m34,
          transform.m41, transform.m42, transform.m43, transform.m44];
}

@end
