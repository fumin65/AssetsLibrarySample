//
//  TableViewController.m
//  AssetsLibrarySample
//
//
//

#import "TableViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define COLUMN_SIZE 4

@interface TableViewController () {
    // 列数
    int numberOfRow;
    ALAssetsLibrary *library;
    // Asset保持用
    NSMutableArray *assets;
}

@end

@implementation TableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
        return self;
}

// カメラロールの読み込み処理
- (void) loadCameraRoll {
    
    library = [[ALAssetsLibrary alloc] init];
    // アクセス先をカメラロールに設定する(ALAssetsGroupSavedPhotos)
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {

        // 写真のみ取得するように設定
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        // ブロックの中でAssetを取得する
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result && ![assets containsObject:result]) {
                [assets addObject:result];
            } else if(!result) {
                // 読み込みが終わったらテーブルを更新
                numberOfRow = ceil(assets.count / (double)COLUMN_SIZE);
                [self.tableView reloadData];
            }

        }];
        
    } failureBlock:^(NSError *error) {
        // TODO エラー処理
    }];
    
    
}

- (void)viewDidLoad
{
    
    numberOfRow = 0;
    assets = [NSMutableArray array];
    
    // カメラロール読み込み
    [self loadCameraRoll];
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return numberOfRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (assets.count == 0) {
        return cell;
    }
    
    for (int i = 0; i < COLUMN_SIZE; i++) {
        int index = indexPath.row * COLUMN_SIZE + i;
        if (index >= assets.count) {
            break;
        }
        ALAsset *asset = (ALAsset*) [assets objectAtIndex:index];
        UIImageView *imageView = (UIImageView*) [cell viewWithTag:(i + 1)];
        // Assetからサムネイルを取得。これだと高速
        imageView.image = [UIImage imageWithCGImage:[asset thumbnail]];
        NSLog(@"in%d", (i + 1));
    }
        
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
