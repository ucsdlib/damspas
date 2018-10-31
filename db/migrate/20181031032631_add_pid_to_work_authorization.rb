class AddPidToWorkAuthorization < ActiveRecord::Migration
  def change
    add_column :work_authorizations, :work_pid, :string
  end
end
