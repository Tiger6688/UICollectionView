//
//  SVCollectionViewController.m
//  SVPullToRefreshDemo
//
//  Created by apple on 15/3/16.
//  Copyright (c) 2015年 Home. All rights reserved.
//

#import "SVCollectionViewController.h"
#import "RHGoodsCell.h"
#import "SVPullToRefresh.h"

@interface SVCollectionViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,RHGoodsCellDelegate>

@property (strong,nonatomic)UICollectionView *collectionView;
@property (assign,nonatomic)BOOL canDelete;
@property (nonatomic, strong)NSMutableArray *dataSource;

@end

@implementation SVCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initNavigation];
    [self initView];
}

-(void)initData
{
    _canDelete = NO;
    _dataSource = [NSMutableArray array];
    for(int i=0; i<10; i++)
        [self.dataSource addObject:[NSDate dateWithTimeIntervalSinceNow:20]];
}

- (void)initNavigation
{
    self.navigationItem.title = @"我的收藏";
    UIBarButtonItem *deleteBtnItem =[[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(refreshUI:)];
    self.navigationItem.rightBarButtonItem = deleteBtnItem;
}

-(void)initView
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize=CGSizeMake(100,100);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:flowLayout];
    //注册class
    //    [_collectionView registerClass:[RHGoodsCell class] forCellWithReuseIdentifier:[RHGoodsCell cellIdentifier]];
    //注册nib
    [_collectionView registerNib:[UINib nibWithNibName:@"RHGoodsCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:[RHGoodsCell cellIdentifier]];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.alwaysBounceVertical = YES;
    [self.view addSubview:_collectionView];
    
    //设置顶部导航栏的高度
    _collectionView.topNavigationBarHeight = 65;
    
    __weak SVCollectionViewController *weakSelf = self;
    // setup pull-to-refresh
    [_collectionView addPullToRefreshWithActionHandler:^{
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf.collectionView.pullToRefreshView stopAnimating];
        });
    }];
    
    //     setup infinite scrolling
    [_collectionView addInfiniteScrollingWithActionHandler:^{
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf.collectionView.infiniteScrollingView stopAnimating];
        });
    }];
    //    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, weakSelf.bounds.size.width, 50)];
    //    [weakSelf.collectionView.pullToRefreshView setCustomView:view forState:SVPullToRefreshStateAll];
    [_collectionView.pullToRefreshView setTitle:@"下拉刷新" forState:SVPullToRefreshStateStopped];
    [_collectionView.pullToRefreshView setTitle:@"松开即可刷新" forState:SVPullToRefreshStateTriggered];
    [_collectionView.pullToRefreshView setTitle:@"正在加载" forState:SVPullToRefreshStateLoading];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark method
- (void)refreshUI : (id)sender
{
    _canDelete = !_canDelete;
    [_collectionView reloadData];
    UIBarButtonItem *button = sender;
    if(_canDelete)
    {
        button.title = @"取消";
    }
    else
    {
        button.title = @"删除";
    }
}

#pragma mark -
#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RHGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[RHGoodsCell cellIdentifier] forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.delegate = self;
    cell.deleteBtn.tag = indexPath.row;
    if(cell.deleteBtn.hidden == _canDelete)
    {
        cell.deleteBtn.hidden =!_canDelete;
    
        CGFloat width = 100;
        CGFloat scale = (width - 10)/width;
        float fromValue = _canDelete?1:scale;
        float toValue = _canDelete?scale:1;
        CABasicAnimation *theAnimation;
        theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
        theAnimation.fromValue = [NSNumber numberWithFloat:fromValue];
        theAnimation.toValue = [NSNumber numberWithFloat:toValue];
        theAnimation.duration = 0.2f;
        theAnimation.repeatCount = 1;
        // 动画结束后不变回初始状态
        theAnimation.removedOnCompletion = NO;
        theAnimation.fillMode = kCAFillModeForwards;
        [cell.baseView.layer addAnimation:theAnimation forKey:@"animateTransform"];
    }
    //    [cell.deleteBtn addTarget:self action:<#(SEL)#> forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


#pragma mark -
#pragma mark RHGoodsCellDelegate
- (void)deleteAction:(id)sender
{
    UIButton *deleteBtn = sender;
    [_dataSource removeObjectAtIndex:deleteBtn.tag];
    [_collectionView reloadData];
}

@end
