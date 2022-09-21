## Part4 データベースを使う

https://mseeeen.msen.jp/ruby-on-rails4/ <br>

### Modelと用意する

+ `$ rails g model Person ageinteger name:string`を実行<br>

+ `db/seeds.rb`を編集<br>

```rb:seeds.rb
Person.create(name: 'Taro', age: 37)
Person.create(name: 'Jiro', age: 35)
```

+ `$ rails db:migrate`を実行<br>

+ `$ rails db:seed`を実行<br>

### Modelのデータを利用する

+ `$ rails g controller people index`を実行<br>

+ `app/controllers/people_controller.rb`を編集<br>

```rb:people_controller.rb
class PeopleController < ApplicationController
  layout 'start'

  def index
    @header = 'studyRails'
    @footer = 'link'
    @msg = 'Person Data'
    @data = Person.all
  end
end
```

+ `app/views/people/index.html.erb`を編集<br>

```html:index.html.erb
<h1 class="display-4 text-primary">People#index</h1>
<p><%= @msg %></p>
<table class="table">
  <tr>
    <th>Id</th>
    <th>Name</th>
  </tr>
  <% @data.each do |obj| %>
  <tr>
    <td><%= obj.id %></td>
    <td><%= obj.name %></td>
  </tr>
  <% end %>
</table>
```

# Part5 CRUDを使う

+ [Part5 CRUDを使う](https://mseeeen.msen.jp/ruby-on-rails5/) <br>

## データの作成

+ `app/controllers/people_controller.rb`を編集<br>

```rb:people_controller.rb
class PeopleController < ApplicationController
  protect_from_forgery # 追加
  layout 'start'

  def index
    @header = 'studyRails'
    @footer = 'link'
    @msg = 'Person Data'
    @data = Person.all
    # render layout: 'start'
  end

  # 追加
  def add
    @msg = "add new data."
    @person = Person.new
  end

  def create
    if request.post?
      Person.create(person_params)
    end
    redirect_to '/people/index'
  end

  private

  def person_params
    params.require(:person).permit(:name, :age)
  end
  # ここまで
end
```

+ `config/routes.rb`を編集<br>

```rb:routes.rb
Rails.application.routes.draw do
  get 'people/index'
  get 'people/add' # 追加
  post 'people/add', to: 'people#create' # 追加
  get 'msgboard/index'
  post 'msgboard/index'
  get 'start/index' => 'start#index'
  post 'start/index' => 'start#index'
end
```

+ `$ touch app/views/people/add.html.erb`を実行<br>

+ `app/views/people/add.html.erb`を編集<br>

```html:add.html.erb
<h1 class="display-4 text-primary">People#add</h1>
<p><%= @msg %></p>
<%= form_with model: @person, url: people_add_path do |form| %>
<div class="form-group">
  <label for="name">Name</label>
  <%= form.text_field :name, class: "form-control" %>
</div>
<div class="form-group">
  <label for="age">Age</label>
  <%= form.text_field :age, class: "form-control" %>
</div>
<%= form.submit class: "btn btn-primary" %>
<% end %>
```

+ http://localhost:3000/people/add にアクセスして登録してみる<br>

## データの参照

+ `app/controllers/people_controller.rb`を編集<br>

```rb:people_controller.rb
class PeopleController < ApplicationController
  protect_from_forgery
  layout 'start'

  def index
    @header = 'studyRails'
    @footer = 'link'
    @msg = 'Person Data'
    @data = Person.all
    # render layout: 'start'
  end

  def add
    @msg = "add new data."
    @person = Person.new
  end

  def create
    if request.post?
      Person.create(person_params)
    end
    redirect_to '/people/index'
  end

  # 追加
  def show
    @msg = "Indexed data."
    @data = Person.find(params[:id])
  end
  # ここまで

  private

  def person_params
    params.require(:person).permit(:name, :age)
  end
end
```

+ `config/routes.rb`を編集<br>

```rb:routes.rb
Rails.application.routes.draw do
  get 'people/index'
  get 'people/add'
  post 'people/add', to: 'people#create'
  get 'people/:id', to: 'people#show' # 追加
  get 'msgboard/index'
  post 'msgboard/index'
  get 'start/index' => 'start#index'
  post 'start/index' => 'start#index'
end
```

+ `$ touch app/views/people/show.html.erb`を実行<br>

+ `app/views/people/show.html.erb`を編集<br>

```html:show.html.erb
<h1 class="display-4 text-primary">People#show</h1>
<p><%= @msg %></p>
<table class="table">
  <tr>
    <th>Id</th>
    <td><%= @data.id %></td>
  </tr>
  <tr>
    <th>Name</th>
    <td><%= @data.name %></td>
  </tr>
  <tr>
    <th>Age</th>
    <td><%= @data.age %></td>
  </tr>
</table>
```

+ `app/views/people/index.html.erb`を編集<br>

```html:index.html.erb
<h1 class="display-4 text-primary">People#index</h1>
<p><%= @msg %></p>
<table class="table">
  <tr>
    <th>Id</th>
    <th>Name</th>
  </tr>
  <% @data.each do |obj| %>
  <tr>
    <td><%= obj.id %></td>
    <td><a href="/people/<%= obj.id %>"><%= obj.name %></td> <!-- 編集 -->
  </tr>
  <% end %>
</table>
```

## データの更新

+ `app/controllers/people_controller.rb`を編集<br>

```rb:people_controller.rb
class PeopleController < ApplicationController
  protect_from_forgery
  layout 'start'

  def index
    @header = 'studyRails'
    @footer = 'link'
    @msg = 'Person Data'
    @data = Person.all
    # render layout: 'start'
  end

  def add
    @msg = "add new data."
    @person = Person.new
  end

  def create
    if request.post?
      Person.create(person_params)
    end
    redirect_to '/people/index'
  end

  def show
    @msg = "Indexed data."
    @data = Person.find(params[:id])
  end

  # 追加
  def edit
    @msg = "edit data.[id = " + params[:id] + "]"
    @person = Person.find(params[:id])
  end

  def update
    obj = Person.find(params[:id])
    obj.update(person_params)
    redirect_to '/people/index'
  end
  # ここまで

  private

  def person_params
    params.require(:person).permit(:name, :age)
  end
end
```

+ `config/routes.rb`を編集<br>

```rb:routes.rb
Rails.application.routes.draw do
  get 'people/index'
  get 'people/add'
  post 'people/add', to: 'people#create'
  get 'people/:id', to: 'people#show'
  get 'people/edit/:id', to: 'people#edit' ## 追加
  patch 'people/edit/:id', to: 'people#update' ## 追加
  get 'msgboard/index'
  post 'msgboard/index'
  get 'start/index' => 'start#index'
  post 'start/index' => 'start#index'
end
```

+ `app/views/people/index.html.erb`を編集<br>

```html:index.html.erb
<h1 class="display-4 text-primary">People#index</h1>
<p><%= @msg %></p>
<table class="table">
  <tr>
    <th>Id</th>
    <th>Name</th>
    <th></th> <!-- 追加 -->
  </tr>
  <% @data.each do |obj| %>
  <tr>
    <td><%= obj.id %></td>
    <td><a href="/people/<%= obj.id %>"><%= obj.name %></td>
    <td><a href="/people/edit/<%= obj.id %>">Edit</a></td> <!-- 編集 -->
  </tr>
  <% end %>
</table>
```

+ `$ touch app/views/people/edit.html.erb`を実行<br>

+ `app/views/people/edit.html.erb`を編集<br>

```html:edit.html.erb
<h1 class="display-4 text-primary"><a href="/people/index" style="text-decoration: none">People#edit</a></h1>
<p><%= @msg %></p>
<%= form_with model: @person, url: '' do |form| %>
<div class="form-group">
  <label for="name">Name</label>
  <%= form.text_field :name, class: "form-control" %>
</div>
<div class="form-group">
  <label for="age">Age</label>
  <%= form.text_field :age, class: "form-control" %>
</div>
<%= form.submit class: "btn btn-primary" %>
<% end %>
```

+ 編集できるかテストしてみる<br>

## データの削除

+ `app/controllers/people_controller.rb`を編集<br>

```rb:people_controller.rb
class PeopleController < ApplicationController
  protect_from_forgery
  layout 'start'

  def index
    @header = 'studyRails'
    @footer = 'link'
    @msg = 'Person Data'
    @data = Person.all
    # render layout: 'start'
  end

  def add
    @msg = "add new data."
    @person = Person.new
  end

  def create
    if request.post?
      Person.create(person_params)
    end
    redirect_to '/people/index'
  end

  def show
    @msg = "Indexed data."
    @data = Person.find(params[:id])
  end

  def edit
    @msg = "edit data.[id = " + params[:id] + "]"
    @person = Person.find(params[:id])
  end

  def update
    obj = Person.find(params[:id])
    obj.update(person_params)
    redirect_to '/people/index'
  end

  # 追加
  def delete
    obj = Person.find(params[:id])
    obj.destroy
    redirect_to '/people/index'
  end
  # ここまで

  private

  def person_params
    params.require(:person).permit(:name, :age)
  end
end
```

+ `config/routes.rb`を編集<br>

```rb:routes.rb
Rails.application.routes.draw do
  get 'people/index'
  get 'people/add'
  post 'people/add', to: 'people#create'
  get 'people/:id', to: 'people#show'
  get 'people/edit/:id', to: 'people#edit'
  patch 'people/edit/:id', to: 'people#update'
  delete 'people/delete/:id', to: 'people#delete' # 追加
  get 'msgboard/index'
  post 'msgboard/index'
  get 'start/index' => 'start#index'
  post 'start/index' => 'start#index'
end
```

+ `app/views/people/index.html.erb`を編集<br>

```html:index.html.erb
<h1 class="display-4 text-primary">People#index</h1>
<p><%= @msg %></p>
<table class="table">
  <tr>
    <th>Id</th>
    <th>Name</th>
    <th></th>
  </tr>
  <% @data.each do |obj| %>
  <tr>
    <td><%= obj.id %></td>
    <td><a href="/people/<%= obj.id %>"><%= obj.name %></td>
    <td><a href="/people/edit/<%= obj.id %>">Edit</a>
    <!-- 追加 -->
    <%= link_to("Delete", "/people/delete/#{obj.id}", method: :delete, data: { confirm: "このデータを削除しますか？" }) %>
    <!-- ここまで -->
    </td>
  </tr>
  <% end %>
</table>
```
