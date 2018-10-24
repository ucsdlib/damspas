class WorkAuthorization < ActiveRecord::Base
  belongs_to :user
  validates :work_title, presence: true
end
