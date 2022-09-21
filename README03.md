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
