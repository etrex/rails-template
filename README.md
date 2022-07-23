# 簡介

此 rails template 設計可快速滿足以下需求：

- 官方網站
- 基本的管理後台
- 有前後台的登入系統
- 串接 LINE 聊天機器人

使用的指令：

```
-f
-T
-d postgresql
-m https://raw.githubusercontent.com/etrex/rails-template/main/template.rb
```


```
rails new blog21 -f -T -d postgresql -m https://raw.githubusercontent.com/etrex/rails-template/main/template.rb
```


# 試用

1. 建立專案

```
rails new blog21 -f -T -d postgresql -m https://raw.githubusercontent.com/etrex/rails-template/main/template.rb
```

2. 設定環境變數

3. rails s

4. 開啟 ngrok 以獲得可串接 LINE Messaging API 以及 LINE Login 的 https + 臨時 domain

5. 查看前台、後台、以及 LINE Bot

6. 關掉 server，使用 scaffold 建立一組資源：

```
rails g scaffold todos title desc
rails db:migrate
rails generate administrate:dashboard Todo
```

在 rails routes 的 admin 下新增一條 resources :todos

7. 再次查看前台、後台、以及 LINE Bot

# 安裝套件

- Dotenv
- Devise
- Kamigo
- RSpec
- Pundit
- Administrate
  - administrate-field-image
  - administrate-field-enum
  - administrate-field-nested_has_many
  - administrate-field-belongs_to_search
  - administrate_exportable
- Rubocop
- Brakeman
- bundler-audit
- Rollbar
- Hotwire
- annotate
