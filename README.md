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
rails new blog18 -f -T -d postgresql -m https://raw.githubusercontent.com/etrex/rails-template/main/template.rb
```

for local testing
```
rails new blog12 -f -T -d postgresql -m ~/Documents/github/etrex/rails-template/template.rb
```

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
