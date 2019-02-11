# RecordMap
現在地を記録できるアプリ。

# 機能
- お気に入り（現在地記録）機能
- 削除・編集機能
- マップモード切り替え

# 技術
## ツール
- Xcode 10.1（Swift4.2）
- Ruby 2.3.3
- Bundler
- Carthage
- CocoaPods
- mergepbx

## ライブラリ
- SwiftGen
- SwiftLint
- Rx
- Realm
- SnapKit
- Reusable
- FloatingPanel
- Presentr

# セットアップ
1. `bundle install --path .bundle`
1. `carthage bootstrap --platform iOS --no-use-binaries`
1. `bundle exec pod install`
