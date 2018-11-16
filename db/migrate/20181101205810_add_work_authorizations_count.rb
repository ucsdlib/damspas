class AddWorkAuthorizationsCount < ActiveRecord::Migration
  def change
    add_column :users, :work_authorizations_count, :integer, default: 0
  end
end
