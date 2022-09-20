## 新規プロジェクト作成

+ `$ rails _6.1.7_ new rails_crud --database=mysql`を実行<br>

+ `$ rails webpacker:install`を実行<br>

+ `$ bunlde install`を実行<br>

+ `$ rails db:create`を実行<br>

## Controllerの作成

+ `rails g controller start`を実行<br>

+ `app/controllers/start_controller.rb`を編集<br>

```rb:start_controller.rb
class StartController < ApplicationController

  def hello()
    render:plain => ('Hello World!')
  end
end
```

## routes の設定

+ `config/routes.rb`を編集<br>

```rb:routes.rb
Rails.application.routes.draw do
  get 'hello' => 'start#hello'
end
```

+ http://localhost:3000/hello にアクセスしてみる<br>

+ `Gemfile`の最下段に `gem 'net-smtp' を追加<br>

+ `$ bundle install`を実行<br>
