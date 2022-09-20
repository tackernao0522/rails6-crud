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

## 02. クエリパラメータ

+ `app/controllers/start_controller.rb`を編集<br>

```rb:start_controller.rb
class StartController < ApplicationController

  def index()
    @title = "Hello Rails!:"
    @msg = params["msg"]
    render plain: @title + @msg
  end
end
```

+ `config/routes.rb`を編集<br>

```rb:routes.rb
Rails.application.routes.draw do
  get 'start/index' => 'start#index'
end
```

+ localhost:3000/start/index?msg=123 にアクセスしてみる<br>

## View と ERB テンプレート

+ `$ touch app/views/start/index.html.erb`を実行<br>

+ `app/views/start/index.html.erb`を編集<br>

```html:index.html.erb
<html>

<head>
  <title>studyRails</title>
</head>
<h1><%= @title %></h1>
<p><%= @msg %></p>

</html>
```

+ `app/controllers/start_controller.rb`を編集<br>

```rb:start_controller.rb
class StartController < ApplicationController

  def index()
    @title = "Hello Rails!:"
    @msg = params["msg"]
  end
end
```

+ http://localhost:3000/start/index?msg=123 にアクセスしてみる<br>

## フォームパラメータ

+ `app/views/start/index.html.erb`を編集<br>

```html:index.html.erb
<html>

<head>
  <title>studyRails</title>
</head>
<h1><%= @title %></h1>
<p><%= @msg %></p>
<!-- 追加 -->
<%= form_tag("index", method: "post") do %>
<%= label_tag(:input, "Input:") %>
<%= text_field_tag(:input) %>
<%= submit_tag("input") %>
<% end %>
<!-- ここまで -->

</html>
```

+ `app/controllers/start_controller.rb`を編集<br>

```rb:start_controller.rb
class StartController < ApplicationController

  def index()
    if request.post?
      @title = "Hello Rails!:"
      @msg = params[:input]
    else
      @title = "Hello Rails!:"
      @msg = "Not POST"
    end
  end
end
```

+ `config/routes.rb`を編集<br>

```rb:routes.rb
Rails.application.routes.draw do
  get 'start/index' => 'start#index'
  post 'start/index' => 'start#index'
end
```

+ http://localhost:3000/start/index にアクセスして inputを試してみる<br>
