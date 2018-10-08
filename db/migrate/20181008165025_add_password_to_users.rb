class AddPasswordToUsers < ActiveRecord::Migration
  def change
    add_column :users, :encrypted_password, :string
    add_column :users, :reset_password_sent_at, :datetime
    add_column :users, :reset_password_token, :string
  end
end
