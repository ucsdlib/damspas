class CreateWorkAuthorizations < ActiveRecord::Migration
  def change
    create_table :work_authorizations do |t|
      t.string :work_title
      t.references :user

      t.timestamps null: false
    end
  end
end
