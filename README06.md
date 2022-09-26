# Part8 Model 連携 (アソシエーション) を行う方法

+ [Part8 Model 連携 (アソシエーション) を行う方法](https://mseeeen.msen.jp/ruby-on-rails8/) <br>

## Model アソシエーション

+ `$ rails g model school name:string`を実行<br>

+ `$ rails g model student school_id:integer`を実行<br>

+ `$ rails g migration AddDetailsToPeople student_id:integer`を編集<br>

+ `$ rails db:reset`を実行<br>

+ `$ rails db:migrate`を実行<br>

+ `db/seeds.rb`を編集<br>

```rb:seeds.rb
Person.create(name:'Ichiro', age:15, student_id:1)
Person.create(name:'Taro', age:15, student_id:2)
Person.create(name:'Jiro', age:14, student_id:3)
School.create(name:'A')
School.create(name:'B')
Student.create(school_id:1)
Student.create(school_id:2)
Student.create(school_id:2)
```

+ `$ rails db:seed`を実行<br>

## アソシエーションの設定

+ `app/models/person.rb`を編集<br>

```rb:person.rb
class Person < ApplicationRecord
  validates :name, presence: {message: "Name が入力されていません"}
  validates :age, presence: {message: "Age が入力されていません"}
  validates :age, numericality: {only_integer: true, message: "数値ではありません"}

  belongs_to :student # 追加
end
```

+ `app/models/school.rb`を編集<br>

```rb:school.rb
class School < ApplicationRecord
  has_many :students
end
```

## Controler と View の記述

+ `$ rails g controller schools index show`を実行<br>

+ `$ rails g controller students index show`を実行<br>

+ `app/controllers/schools_controller.rb`を編集<br>

```rb:schools_controller.rb
class SchoolsController < ApplicationController
  protect_from_forgery
  layout 'start'

  def index
    @header = 'studyRails'
    @footer = 'link'
    @msg = 'School Data'
    @data = School.all
  end

  def show
    @msg = "Indexed data."
    @data = School.find(params[:id])
  end
end
```

+ `app/controllers/students_controller.rb`を編集<br>

```rb:students_controller.rb
class StudentsController < ApplicationController
  protect_from_forgery
  layout 'start'

  def index
    @header = 'studyRails'
    @footer = 'link'
    @msg = 'Student Data'
    @data = Student.all
  end

  def show
    @msg = "Indexed data."
    @data = Student.find(params[:id])
  end
end
```

+ `app/views/shools/index.html.erb`を編集<br>

```html:index.html.erb
<h1 class="display-4 text-primary">School#index</h1>
<p><%= @msg %></p>
<table class="table">
  <tr>
    <th>Id</th>
    <th>Name</th>
    <% @data.each do |obj| %>
  </tr>
  <tr>
    <td><%= obj.id %></td>
    <td><a href="/schools/<%= obj.id %>"><%= obj.name %></a></td>
  </tr>
  <% end %>
</table>
```

+ `app/views/shools/show.html.erb`を編集<br>

```html:show.html.erb
<h1 class="display-4 text-primary">Schools#show</h1>
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
  <% @data.students.each do |obj| %>
  <tr>
    <th>Student</th>
    <td><a href="/students/<%= obj.id %>"><%= obj.id %></a></td>
  </tr>
  <% end %>
</table>
```

+ `app/views/students/index.html.erb`を編集<br>

```html:index.html.erb
<h1 class="display-4 text-primary"><a href="/people/index" style="text-decoration: none;">Students#index</a></h1>
<p><%= @msg %></p>
<table class="table">
  <tr>
  <th>Id</th>
  <th>School Id</th>
  <th>Person Id</th>
  </tr>
  <% @data.each do |obj| %>
  <tr>
    <td><a href="/students/<%= obj.id %>"><%= obj.id %></a></td>
    <td><a href="/schools/<%= obj.school_id %>"><%= obj.school_id %></a></td>
    <td><a href="/people/<%= obj.person.id %>"><%= obj.person.id %></a></td>
  </tr>
  <% end %>
</table>
```

+ `app/views/schools/show.html.erb`を編集<br>

```html:show.html.erb
<h1 class="display-4 text-primary">Schools#show</h1>
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
  <% @data.students.each do |obj| %>
  <tr>
    <th>Student</th>
      <td><a href="/students/<%= obj.id %>"><%= obj.id %></a></td>
  </tr>
  <% end %>
</table>
```

+ `app/views/students/show.html.erb`を編集<br>

```html:show.html.erb
<h1 class="display-4 text-primary">Students#show</h1>
<p><%= @msg %></p>
<table class="table">
  <tr>
    <th>Id</th>
    <td><%= @data.id %></td>
  </tr>
  <tr>
    <th>School Id</th>
    <td><a href="/schools/<%= @data.school_id %>"><%= @data.school_id %></a></td>
  </tr>
  <tr>
    <th>Person Id</th>
    <td><a href="/people/<%= @data.person.id %>"><%= @data.person.id %></a></td>
  </tr>
</table>
```

+ `config/routes.rb`を編集<br>

```rb:routes.rb
Rails.application.routes.draw do
  # 編集
  get 'students/index'
  get 'students/:id', to: 'students#show'
  get 'schools/index'
  get 'schools/:id', to: 'schools#show'
  # ここまで
  get 'people/index'
  get 'people/add'
  post 'people/add', to: 'people#create'
  get 'people/find'
  post 'people/find', to: 'people#find'
  get 'people/:id', to: 'people#show'
  get 'people/edit/:id', to: 'people#edit'
  patch 'people/edit/:id', to: 'people#update'
  delete 'people/delete/:id', to: 'people#delete'
  get 'msgboard/index'
  post 'msgboard/index'
  get 'start/index' => 'start#index'
  post 'start/index' => 'start#index'
end
```

## アソシエーションの種類

## has_one

1 対 1 関係の Model に記述されます。<br>

上記の例では使っていませんが、`Person` の `belongs_to` の代わりに、<br>
`Student` に `has_one` を記述することで同じ関係にできます。<br>

これについては後程解説します。<br>

## has_many

1 対 多 関係で従属させる側の Model に記述されます。<br>

上述の例では、`Schools` が該当しています。<br>

## belongs_to

1 対 1 関係の Model に記述されます。<br>

`has_one` との違いは外部キーをどちらの Modelに置くかです。<br>

`has_one`は外部キーを記述した Model の外側に置きますが、belongs_to は記述した Model に置きます。<br>

上述の例では、 `Person` が該当しています。<br>

## has_many :through

多 対 多の関連付けをする場合に使われます。<br>
この関連付けは2つのモデルの間に第3のモデルが介在しています。<br>

## has_one :through

1 対 1 の関連付けをする際に使われます。<br>
通常の `has_many` と異なるのは第3のモデルが介在する点です。<br>

## has_and_belongs_to_to_many

多 対 多 の関連付けをする場合に使われます。<br>
`has_many :through`を異なり、第３のモデルが介在しません。<br>

+ 参考サイト: [Active Record の関連付け - Railsガイド](https://railsguides.jp/association_basics.html) <br>
