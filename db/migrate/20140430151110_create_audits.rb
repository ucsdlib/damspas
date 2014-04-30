class CreateAudits < ActiveRecord::Migration
  def change
    create_table :audits do |t|
      t.string :description
      t.string :user
      t.string :object

      t.timestamps
    end
  end
end
