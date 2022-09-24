# Part7: バリデーションチェックを自動で行う方法

[Part7 バリデーションチェックを自動で行う方法](https://mseeeen.msen.jp/ruby-on-rails7/) <br>

## バリデーションチェック

+ `app/models/person.rb`を編集<br>

```rb:person.rb
class Person < ApplicationRecord
  validates :name, presence: true
end
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
      # 編集
      if Person.create(person_params).valid?
        redirect_to '/people/index'
      else
        @msg = "Name が入力されていません"
        render 'add'
      end
      # ここまで
    end
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
      @people = Person.where(name: params[:find])
    end
  end

  private

  def person_params
    params.require(:person).permit(:name, :age)
  end
end
```

+ localhost:3000/people/add にアクセスして、何も入力せずにSaveしてみる<br>

+ 上記コードの説明<br>

```
Person.create を実行すると、モデル内に記述された validates のないように基づいて、データベースにオブジェクトを保存するか決定します。

オブジェクトが保存されたか否かは valid? プロパティで取得できます。

valid? プロパティが true なら、オブジェクト保存後、people/index に画面を遷移します。

false なら、オブジェクトを保存せず、 @msg にエラーメッセージを表示させています。
```

## バリデーションヘルパー

### acceptance

+ チェックボックスにチェックが入っているかを確認します。<br>

+ `例`(Model)<br>

```rb:sample.rb
class Person < ApplicationRecord
  validates :check, acceptance: true
end
```

* View テンプレートで生成されたチェックボックスのオプションがバリデーションチェックの対象になります。<br>
そのため、データベース上に対応するカラムを作る必要はありません。<br>

+ `例`(View)<br>

```html:sample.html.erb
<%= f.check_box :check %>
```

### confirmation

+ 2つのテキストフィールドで受け取る内容が完全に一致する必要がある場合に使います。<br>

+ 例えば、`name`を確認したい場合はモデルのバリデーションに `confirmation` を設定したうえで、<br>
Viewテンプレートに `_confirmation` がついた項目を用意します。<br>

+ `例`(Model)<br>

```rb:sample.rb
class Person < ApplicationRecord
  validates :name, confirmation: true
end
```

+ `例(View)`<br>

```html:sample.html.erb
<%= text_field :person, :name %>
<%= text_field :person :name_confirmation %>
```

* このチェックは、`name_confirmation` が `nil` 出ない場合のみ行われます。<br>

* 確認を必須にするには、後術する `presence` を使って、確認用の項目についたの存在チェックも追加してください。<br>

### length

+ 入力値の長さに基づいて、バリデーションチェックを行うヘルパーです。<br>

+ `例`(Model)<br>

```rb:sample.rb
class Person < ApplicationRecord
  validates :name, length: { minimum: 2 }
end
```

以下のオプションが存在します。<br>

+ `minimum` : 入力された文字列の長さの下限を設定します。<br>

+ `maximum` : 入力された文字列の長さの上限を設定します。<br>

+ `in` または `within` : 入力された文字列の長さが、与えられた区間以内であるかを確認します。<br>

+ `id` : 入力された文字列の長さが設定された値と等しいかえお確認します。<br>

### numericality

+ 入力値が数値がどうかをチェックするヘルパーです。<br>

+ 整数のみがどうかをチェックしたい場合は `true`の代わりに `{ only_integer: true }` を記述しましょう。<br>

+ `only_integer` が `true` でない場合の値の型は `Float` として扱われます。<br>

+ `例`(Model)<br>

```rb:sample.rb
class Person < ApplicationRecord
  validates :age, numericality: true
end
```

### presence

+ 指定された属性が「空でない」こと（`nil` でない) を確認します。<br>

+ `例`(Model)<br>

```rb:sample.rb
class Person < ApplicationRecord
  validates :name, presence: true
end
```

### absence

+ `presence` とは逆に、指定された属性が 「空である」こと（`nil` である）を確認します。<br>

+ `例`(Model)<br>

```rb:sample.rb
class Person < ApplicationRecord
  validates :name, absence: true
end
```

### uniqueness

+ このヘルパーは、データベースにオブジェクトを保存する前に、保存する値がデータベース上のレコードの重複していないことをチェックします。<br>

+ `例`(Model)<br>

```rb:sample.rb
class Person < ApplicationRecord
  validates :name, uniqueness: true
end
```

### カスタムバリデーション

+ 既存のバリデーションヘルバーでは足りない場合、自分でバリデーションを作ることもできます。<br>

+ カスタムバリデーションを作る場合は `ActiveModel::Validator` を継承したクラスを作ります。<br>

+ これらのクラスには `validate` メソッドを実装する必要があります。<br>

+ `validate` メソッドはレコードを１つ引数に取り、それに対してバリデーションを実行します。<br>

+ カスタムバリデーションは `validates_with` メソッドを使って呼び出します。<br>

* `例`(Validator)<br>

```rb:sample.rb
class MyValidator < ActiveModel::Validator
  def validate(record)
    unless record.name.starts_with? 'X'
      record.errors[:name] << '名前は X で始まる必要があります'
    end
  end
end

class Person < ApplicationRecord
  include ActiveModel::Validatations
  validates_with MyValidator
end
```

## バリデーションエラー

+ Active Record では、バリデーションが失敗するたびに、オブジェクトの `errors` コレクションにエラーメッセージが追加されます。<br>

+ 試しに直打ちのエラーメッセージではなく、`erros` コレクションのエラーメッセージを表示させてみましょう。<br>

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
    @errors = Hash.new # 追加
  end

  # 編集
  def create
    if request.post?
      person = Person.create(person_params)
      if person.valid?
        redirect_to '/people/index'
      else
        @errorMessages = person.errors
        render 'add'
      end
    end
  end
  # ここまで

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
      @people = Person.where(name: params[:find])
    end
  end

  private

  def person_params
    params.require(:person).permit(:name, :age)
  end
end
```

+ `app/views/people/add.html.erb`を編集<br>

```html:add.html.erb
<h1 class="display-4 text-primary"><a href="/people/index" style="text-decoration: none">People#add</a></h1>
<p><%= @msg %></p>
<!-- 追加 -->
<% if @errorMessages %>
<% @errorMessages.values.each do |error| %>
  <p><%= error %></p>
<% end %>
<% end%>
<!-- ここまで -->
<%= form_with model: Peerson.new, url: people_add_path do |form| %> <!-- 編集 -->
<div class="form-group">
  <label for="name">Name</label>
  <%= form.text_field :name, class: "form-control" %>
</div>
<div class="form-group">
  <label for="age">Age</label>
  <%= form.text_field :age, class: "form-control" %>
</div>
<%= form.submit "登録", class: "btn btn-primary" %>
<% end %>
```

+ `app/models/person.rb`を編集<br>

```rb:person.rb
class Person < ApplicationRecord
  validates :name, presence: {message: "Name が入力されていません"}
  validates :age, presence: {message: "Age が入力されていません"}
  validates :age, numericality: {only_integer: true, message: "数値ではありません"}
end
```

+ localhost:3000/people/add で試してみる<br>

### 参考サイト

+ [Active Record バリデーション - Railsガイド](https://railsguides.jp/active_record_validations.html) <br>
