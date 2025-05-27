class AddBodyAndRoleToMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :body, :text
    add_column :messages, :role, :string
  end
end
