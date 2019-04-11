class BetterWorkAuthorizationErrors < ActiveRecord::Migration
  def change
    change_column :work_authorizations, :error, :text, :default => ''
  end
end
