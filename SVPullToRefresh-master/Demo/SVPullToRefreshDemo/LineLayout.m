

#import "LineLayout.h"


#define ITEM_SIZE 150.0

@implementation LineLayout

#define ACTIVE_DISTANCE 150
#define ZOOM_FACTOR 0.3

-(id)init
{
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake(ITEM_SIZE, ITEM_SIZE);
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.sectionInset = UIEdgeInsetsMake(0.0, 100, 0.0, 100);
        self.minimumLineSpacing = 50.0;
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes* attributes in array) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            CGFloat distance = CGRectGetMidY(visibleRect) - attributes.center.y;
            CGFloat normalizedDistance = distance / ACTIVE_DISTANCE;
            if (ABS(distance) < ACTIVE_DISTANCE) {
                CGFloat zoom = 1 + ZOOM_FACTOR*(1 - ABS(normalizedDistance));
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
                attributes.zIndex = 1;
            }
        }
    }
    return array;
}


- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat verticalCenter = proposedContentOffset.y + (CGRectGetHeight(self.collectionView.bounds) / 2.0);
    
    CGRect targetRect = CGRectMake(0.0, proposedContentOffset.y, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        CGFloat itemVerticalCenter = layoutAttributes.center.y;
        if (ABS(itemVerticalCenter - verticalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemVerticalCenter - verticalCenter;
        }
    }    
    return CGPointMake(proposedContentOffset.x, proposedContentOffset.y + offsetAdjustment);
}

@end