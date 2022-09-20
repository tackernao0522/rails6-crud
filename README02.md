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

## Part3 Bootstrap5の適用

+ [Bootstrap5.0.x](https://getbootstrap.com/docs/5.0/getting-started/introduction/) <br>

+ `app/views/start/index.html.erb`を編集<br>

```html:index.html.erb
<html>

<head>
  <title>studyRails</title>
  <!-- 追加 -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
    integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
  <!-- ここまで -->
</head>
<h1><%= @title %></h1>
<p><%= @msg %></p>
<%= form_tag("index", method: "post") do %>
<%= label_tag(:input, "Input:") %>
<!-- 編集 -->
<%= text_field_tag(:input, "", {class: "form-control"}) %>
<%= submit_tag("send", {class: "btn btn-primary"}) %>
<!-- ここまで -->
<% end %>

</html>
```

+ http://localhost:3000/start/index にアクセスしてみる<br>

## 共通レイアウトの設定

+ `$ touch app/views/layouts/start.html.erb`を実行<br>

+ `app/views/layouts/start.html.erb`を編集<br>

```html:start.html.erb
<!DOCTYPE html>
<html lang="ja">

<head>
  <title><%= @title %></title>
  <%= csrf_meta_tags %>
  <%= csp_meta_tag %>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
    integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
  <%= stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>
  <%= javascript_pack_tag 'application', 'data-turbolinks-track': 'reload' %>
</head>

<body class="container text-body">
  <%= render template: 'layouts/start_header' %>
  <%= yield %>
  <%= render template: 'layouts/start_footer' %>
</body>

</html>
```

+ `$ touch app/views/layouts/{start_header.html.erb,start_footer.html.erb}`を実行<br>

+ `app/views/layouts/start_header.html.erb`を編集<br>

```html:start_header.html.erb
<h1 class="display-4 text-center mt-1 mb-4 text-primary">
  <%= @header %>
</h1>
```

+ `app/views/layouts/start_footer.html.erb`を編集<br>

```html:start_footer.html.erb
<div class="mt-5 text-right small text-dark border-bottom border-dark">
  <%= @footer %>
</div>
```

+ `app/controllers/start_controller.rb`を編集<br>

```rb:start_controller.rb
class StartController < ApplicationController

  def index()
    # 編集
    @title = "Hello Rails!:"
    @header = "studyRails"
    @footer = "link"
    if request.post?
      @msg = params[:input]
    else
      @msg = "Not POST"
    end
    # ここまで
  end
end
```

+ http://localhost:3000/start/index にアクセスしてみる<br>


## メッセージ投稿機能を作ってみる

+ `$ rails g controller msgboard index`を実行<br>

+ `$ touch app/views/layouts/msgboard.html.erb`を実行<br>

+ `app/views/layouts/msgboard.html.erb`を編集<br>

```html:msgboard.html.erb
<!DOCTYPE html>
<html lang="ja">

<head>
  <%= csrf_meta_tags %>
  <%= csp_meta_tag %>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
    integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
  <title>メッセージボード</title>
</head>

<body class="container text-body">
  <%= render template: 'layouts/start_header' %>
  <%= yield %>
  <%= render template: 'layouts/start_footer' %>
</body>

</html>
```

+ `app/views/msgboard/index.html.erb`を編集<br>

```html:index.html.erb
<%=  form_tag(controller: "msgboard", action: "index") do %>
<div class="form-group">
  <label for="name">名前</label>
  <%= text_field_tag("name", "", {class: "form-control"}) %>
</div>
<div class="form-group">
  <label for="mail">メール</label>
  <%= text_field_tag("mail", "", {class: "form-control"}) %>
</div>
<div class="form-group">
  <label for="msg">メッセージ</label>
  <%= text_field_tag("msg", "", {class: "form-control"}) %>
</div>
<%= submit_tag("Send", {class: "btn btn-primary"}) %>
<% end %>

<table class="table mt-4">
  <tr>
    <th style="width:50%">メッセージ</th>
    <th>名前</th>
    <th>メール</th>
  </tr>
  <% @msg_data.each do |key, obj| %>
  <tr>
    <td class="msg"><%= obj['msg'] %></td>
    <td class="name"><%= obj['name'] %></td>
    <td class="mail"><%= obj['mail'] %></td>
  </tr>
  <% end %>
</table>
```

+ `app/controllers/msgboard_controller.rb`を編集<br>

```rb:msgboard_controller.rb
class MsgboardController < ApplicationController
  layout 'msgboard'

  def initialize
    super
    begin
      @msg_data = JSON.parse(File.read("data.txt"))
    rescue => exception
      @msg_data = Hash.new
    end
    File.write("data.txt", @msg_data.to_json)
  end

  def index
    @header = 'メッセージボード'
    @footer = 'studyRails'
    if request.post? then
      obj = MyData.new(params['name'], params['email'], params['msg'])
      @msg_data[@msg_data.length] = obj
      data = @msg_data.to_json
      File.write("data.txt", data)
      @msg_data = JSON.parse(data)
    end
  end
end

class MyData
  attr_accessor :name
  attr_accessor :mail
  attr_accessor :msg

  def initialize(name, mail, msg)
    @name = name
    @mail = mail
    @msg = msg
  end
end
```

+ `config/routes.rb`を編集<br>

```rb:routes.rb
Rails.application.routes.draw do
  get 'msgboard/index'
  post 'msgboard/index' # 追加
  get 'start/index' => 'start#index'
  post 'start/index' => 'start#index'
end
```

+ http://localhost:3000/msgboard/index にアクセスしてみる<br>
