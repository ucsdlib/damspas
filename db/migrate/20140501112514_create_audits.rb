class CreateAudits < ActiveRecord::Migration
  def change
    drop_table :audits
    create_table :audits do |t|
      t.string :user
      t.string :action
      t.string :classname
      t.string :object

      t.timestamps
    end
  end
end
