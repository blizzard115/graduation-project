# Stylog - コーデ共有アプリ

ファッションコーディネートを画像付きで投稿・共有できるSNSアプリです。

日々のコーディネートを「写真1枚＋ひとこと」で気軽に記録でき、
他ユーザーのコーディネートを参考に新しいスタイルを発見できます。
ユーザーは投稿・いいね・コメント・フォローを通じてコーディネートを共有できます。

Railsの設計原則を意識し、拡張性・保守性・パフォーマンスを考慮して実装しました。

---

## 🌐 デモ

[Stylog デモサイト](https://graduation-project-mjhg.onrender.com)

テストアカウント
- email: test@example.com
- password: password

---

## 🛠 技術スタック

| 種別 | 技術 |
|------|------|
| Frontend | ERB / Bootstrap |
| Backend | Ruby 3.3 / Rails 7.1 |
| DB | PostgreSQL 16 |
| 認証 | Devise / OmniAuth(Google) |
| 画像管理 | ActiveStorage / Amazon S3 |
| テスト | RSpec / FactoryBot |
| 静的解析 | RuboCop |
| CI | GitHub Actions（RSpec自動実行） |
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

## 🚀 開発環境構築

```bash
git clone https://github.com/blizzard115/graduation-project.git
cd graduation-project

docker compose build
docker compose up
docker compose exec web bin/rails db:create db:migrate
```

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

### 6️⃣ 画像処理

ActiveStorage + MiniMagick を使用し
投稿画像は用途ごとに variant を生成しています。

- 一覧表示：軽量サムネイル
- 詳細表示：高解像度画像

画像サイズを最適化することでページ表示速度を改善しています。

### 7️⃣ セキュリティ対策

- Strong Parametersによるパラメータ制御
- 公開URLにUUIDを使用
- Deviseによる認証管理

## 🗄 データベース設計

### 画面遷移図
Figma
https://www.figma.com/design/MOaiD71mhWoOIQzpAOrrDl/%E5%8D%92%E6%A5%AD%E5%88%B6%E4%BD%9C?node-id=0-1&t=UyLnZ2JTuP0qgDMV-1

### ER図
![ER図](https://i.gyazo.com/f0d1a4a58327cb92d29aaa3b37295d8a.png)

---

### 🧪 テスト実行
```bash
docker compose exec web bundle exec rspec
```

### 🧹 静的解析
```bash
docker compose exec web bundle exec rubocop
```

## 📷 画面イメージ

### 投稿一覧
![posts](https://i.gyazo.com/9fb53d11db9ac47bc823a9ee90115ff1.jpg)

### 投稿詳細
![post-show](https://i.gyazo.com/6fbcd07279ca61d9ef891fd5cced70fe.jpg)

### ユーザーページ
![user](https://i.gyazo.com/ffa34b244887c46866e880e4d0371d09.jpg)
