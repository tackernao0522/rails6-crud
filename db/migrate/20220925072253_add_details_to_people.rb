class AddDetailsToPeople < ActiveRecord::Migration[6.1]
  def change
    add_column :people, :student_id, :integer
  end
end
