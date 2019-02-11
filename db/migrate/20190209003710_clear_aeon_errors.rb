class ClearAeonErrors < ActiveRecord::Migration
  def change
    WorkAuthorization.find_each do |wa|
      wa.clear_error
    end
  end
end
