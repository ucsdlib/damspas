class AddAeonIDToWorkAuthorizations < ActiveRecord::Migration
  def change
    add_column :work_authorizations, :aeon_id, :integer
  end
end
