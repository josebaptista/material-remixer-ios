//
//  RMXOverlayView.m
//  Pods
//
//  Created by Andres Ugarte on 9/20/16.
//
//

#import "RMXOverlayView.h"

#import "RMXOverlayNavigationBar.h"

static CGFloat kDefaultOptionsViewHeight = 260.0f;
static CGFloat kToolbarHeight = 44.0f;

@implementation RMXOverlayView

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    _panelHeight = kDefaultOptionsViewHeight;
    
    _panelContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_panelContainerView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.contentInset = UIEdgeInsetsMake(-36, 0, kToolbarHeight, 0);
    _tableView.allowsSelection = NO;
    [_panelContainerView addSubview:_tableView];
    
    // Top navigation bar.
    _navigationBar = [[RMXOverlayNavigationBar alloc] initWithFrame:CGRectZero];
    [_panelContainerView addSubview:_navigationBar];
    
    // Bottom toolbar.
    _bottomToolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    _bottomToolbar.clipsToBounds = YES;
    _bottomToolbar.barTintColor = _tableView.backgroundColor;
    _tableView.tableFooterView = _bottomToolbar;
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  CGSize boundsSize = self.bounds.size;
  _panelContainerView.frame = CGRectMake(0,
                                         boundsSize.height - _panelHeight,
                                         boundsSize.width,
                                         _panelHeight);
  
  [UIView setAnimationsEnabled:NO];
  _tableView.frame = CGRectMake(0, RMXOverlayNavbarHeight,
                                boundsSize.width, _panelHeight - RMXOverlayNavbarHeight);
  [UIView setAnimationsEnabled:YES];
  
  _navigationBar.frame = CGRectMake(0, 0, boundsSize.width, RMXOverlayNavbarHeight);
  CGRect frame = _bottomToolbar.frame;
  frame.size = CGSizeMake(boundsSize.width, kToolbarHeight);
  _bottomToolbar.frame = frame;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
  if ([self.delegate respondsToSelector:@selector(touchStartedAtPoint:withEvent:)]) {
    [self.delegate touchStartedAtPoint:point withEvent:event];
  }
  CGPoint adjustedPoint = [_panelContainerView convertPoint:point fromView:self];
  BOOL pointInsidePanel = [_panelContainerView pointInside:adjustedPoint withEvent:event];
  if (!pointInsidePanel &&
      [self.delegate respondsToSelector:@selector(shouldCapturePointOutsidePanel:)]) {
    return [self.delegate shouldCapturePointOutsidePanel:point];
  }
  return pointInsidePanel;
}

- (void)showAtDefaultHeight {
  _panelHeight = kDefaultOptionsViewHeight;
  [self setNeedsLayout];
}

- (void)showMinimized {
  _panelHeight = RMXOverlayNavbarHeight;
  [self setNeedsLayout];
}

- (void)showMaximized {
  _panelHeight = self.bounds.size.height;
  [self setNeedsLayout];
}

- (void)hidePanel {
  _panelHeight = 0;
  [self setNeedsLayout];
}

@end

