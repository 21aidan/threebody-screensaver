//
//  threebodyView.h
//  threebody
//
//  Created by Aidan Nash on 15/01/2025.
//

#import <Cocoa/Cocoa.h>

@interface threebodyView: NSObject

@property (nonatomic) CGPoint position;
@property (nonatomic) CGPoint velocity;
@property (nonatomic) CGFloat mass;
@property (nonatomic) CGFloat radius;
@property (nonatomic, strong) NSColor *color;

//methods
- (instancetype)initWithPosition:(CGPoint)position
                        velocity:(CGPoint)velocity
                            mass:(CGFloat)mass
                          radius:(CGFloat)radius
                           color:(NSColor *)color;

- (CGPoint)calculateForceFromBody:(threebodyView *)otherBody;

- (void)updateWithForce:(CGPoint)force timeStep:(CGFloat)dt;

@end
