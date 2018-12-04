class AddErrorToWorkAuthorizations < ActiveRecord::Migration
  def change
    add_column :work_authorizations, :error, :string
  end
end
