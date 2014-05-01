class CreateAudits < ActiveRecord::Migration
  def change
    create_table :audits do |t|
      t.string :user
      t.string :action
      t.string :classname
      t.string :object

      t.timestamps
    end
  end
end
