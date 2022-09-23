# Part6 Rails上でデータベース検索

+ [Part6 Rails上でデータベース検索](https://mseeeen.msen.jp/ruby-on-rails6/) <br>

## ActiveRecordでデータベース検索

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

  def delete
    obj = Person.find(params[:id])
    obj.destroy
    redirect_to '/people/index'
  end

  # 追加
  def find
    @msg = 'please type search word...'
    @people = Array.new
    if request.post? then
      @people.push(Person.find(params[:find]))
    end
    # ここまで
  end

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
  get 'people/find' # 追加
  post 'people/find', to: 'people#find' # 追加
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

+ `$ touch app/views/people/find.html.erb`を実行<br>

+ `app/views/people/find.html.erb`を編集<br>

```html:find.html.erb
<h1 class="display-4 text-primary">People#Find</h1>
<p><%= @msg %></p>
<%= form_with model: @person do |form| %>
<div class="form-group">
  <label for="find">Find</label>
  <%= form.text_field("find", {class: "form-control"}) %>
</div>
<%= form.submit("Click", {class: "btn btn-primary"}) %>
<% end %>

<table class="table">
  <tr>
    <th>Id</th>
    <th>Name</th>
    <th>Age</th>
  </tr>
  <% @people.each do |obj| %>
  <td><%= obj.id %></td>
  <td><%= obj.name %></td>
  <td><%= obj.age %></td>
  <% end %>
</table>
```

## ActiveRecord のメソッドの一部

```
SQL を使ってできることは ActiveRecord でほぼ全てできます。
もちろん独自の SQL 文を使用するための `find_by_sql` メソッドも存在します。

今回はデータを取得するメソッドの一部を紹介します。
ここで紹介したメソッド以外にも一番最初に取得したレコードを返す `first` や 多数のレコードに対して反復処理を行う `find_each` が存在します。
```

## find

```
主キーと一致するレコードを取得します。

`app/controller/people_controller.rb` に追加した `find` メソッド内の `Person.find(params[:find])` が ActiveRecord の `find` メソッドです。

例えば、主キーが id だとすると、 2 で検索すれば、それの検索結果が表示されます。
```

## find_by

```
find_by は与えられた条件にマッチするレコード群のうち、最初のレコードのみを返します。

まず、 `app/controller/people_controller.rb` を `find_by` を使ったコードに書き換えます。

下記のコードでは 'name' を検索条件としています。
```

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

  def delete
    obj = Person.find(params[:id])
    obj.destroy
    redirect_to '/people/index'
  end

  def find
    @msg = 'please type search word...'
    @people = Array.new
    if request.post? then
      @people.push(Person.find_by(name: params[:find])) # 編集
    end
  end

  private

  def person_params
    params.require(:person).permit(:name, :age)
  end
end
```

## where

```
`where` は返されるレコードを制限するための条件を指定します。 SQL 文で言う `WHERE` に相当します。

単に `where` メソッドのみで使えば、指定した条件に一致するレコード群を返してくれます。
```

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

  def delete
    obj = Person.find(params[:id])
    obj.destroy
    redirect_to '/people/index'
  end

  def find
    @msg = 'please type search word...'
    @people = Array.new
    if request.post? then
      @people = Person.where(name: params[:find]) # 編集
    end
  end

  private

  def person_params
    params.require(:person).permit(:name, :age)
  end
end
```

## `where`で使える条件式

### `where`で使える条件式とコード例

|検索条件|コード例|
|:---:|:---|
|文字列のみ|Person.where("name = Jiro"), <br> Person.where("id <= #{params[:id]}")|
|プレースホルダーを使用した条件|Person.where("name = ?", params[:find]), <br> Person.where("name = ? AND id = ?", params[:find], params[:id]), <br> Person.where("name = :name AND id = :id", {name: params[:find], id: params[:id]})|
|ハッシュを使用した条件|Person.where(name: params[:find])|
|NOT 条件|Person.where.not(name: params[:find])|
|OR 条件|Person.where(name: params[:find]).or(Person.where(id: params[:id]))|
|サブセット条件|Person.where(id: [1,3,5])|
|範囲条件|Person.where(created_at: (Time.now.midnight - 1.day)..Time.now.midnight)|

## 文字列のみ

```
`where` の条件式は文字列だけで書くことも可能です。

ただし、条件で使用する数値が変動する可能性がある場合、 2つ目のコード例のように変数をそのまま埋め込んでしまうと SQL インジェクションの脆弱性が発生する可能性があります。

そのため、渡される変数をサニタイズするために、プレースホルダーを使用した条件式か、ハッシュを使用した条件式を使用することが推奨されています。
```

## プレースホルダーを使用した条件

```
最初の引数は文字列で表された条件として受け取ります。その後に続く引数は、文字列内にある `?` と置き換えられます。

`?` をパラメータで置き換える代わりに、 3つ目のコード例のように条件中でキー / 値のハッシュを渡すことができます。

ここで渡されたハッシュは、条件中の対応するキー / 値の部分に置き換えられます。
```

+ Railsガイドでは[配列で表された条件](https://railsguides.jp/active_record_querying.html#%E9%85%8D%E5%88%97%E3%81%A7%E8%A1%A8%E3%81%95%E3%82%8C%E3%81%9F%E6%9D%A1%E4%BB%B6)と表示されています。<br>

## ハッシュを使用した条件

```
上述の find メソッドの中ではハッシュを使用した条件で記述していますが、
ハッシュによる条件は、等値、範囲、サブセットのチェックでのみ使用できます。
```

### 参考サイト

+ (Active Record クエリインターフェイス - Railsガイド)[https://railsguides.jp/active_record_querying.html] <br>
