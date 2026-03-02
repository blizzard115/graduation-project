# Stylog - コーデ共有アプリ

ファッションコーディネートを投稿・共有できるRailsアプリケーション。
拡張性・保守性・セキュリティを意識して設計しました。

---

## 🌐 デモ

（デプロイURLを記載）

テストアカウント
- email: test@example.com
- password: password

---

## 🛠 技術スタック

| 種別 | 技術 |
|------|------|
| Backend | Ruby 3.3 / Rails 7.1 |
| DB | PostgreSQL 16 |
| 認証 | Devise / OmniAuth(Google) |
| 画像管理 | ActiveStorage |
| テスト | RSpec / FactoryBot |
| 静的解析 | RuboCop |
| CI | GitHub Actions |
| 環境構築 | Docker |

---

## 📌 実装機能

- ユーザー登録 / ログイン
- Google OAuthログイン
- 投稿（画像・テキスト・タグ）
- いいね機能
- コメント機能
- フォロー / アンフォロー機能
- タグ検索
- ユーザーページ（投稿一覧）

---

## 🏗 設計の工夫

### 1️⃣ 公開IDにUUIDを採用

内部ID（integer）と公開ID（uuid）を分離。

```ruby
def to_param
  uuid
end
```

### 2️⃣ フォロー機能の自己参照設計
```ruby
has_many :active_relationships,
         class_name: 'Relationship',
         foreign_key: :follower_id,
         dependent: :destroy

has_many :passive_relationships,
         class_name: 'Relationship',
         foreign_key: :followed_id,
         dependent: :destroy
```

### 3️⃣ N+1問題対策
```ruby
Post.includes(:user, :likes, :tags, image_attachment: :blob)
```

### 4️⃣ 責務分離
 - before_actionで共通処理整理
 - Strong Parameters徹底
 - モデルへロジックを集約

### 5️⃣ テスト設計
 - RSpec（request / system spec）
 - FactoryBot
 - Docker環境で実行
 - GitHub ActionsによるCI連携

### 🗄 データベース設計
## 画面遷移図
Figma：https://www.figma.com/design/MOaiD71mhWoOIQzpAOrrDl/%E5%8D%92%E6%A5%AD%E5%88%B6%E4%BD%9C?node-id=0-1&t=UyLnZ2JTuP0qgDMV-1

## ER図
https://i.gyazo.com/f0d1a4a58327cb92d29aaa3b37295d8a.png

---

### 🧪 テスト実行
```bash
docker compose exec web bundle exec rspec
```

### 🧹 静的解析
```bash
docker compose exec web bundle exec rubocop
```
