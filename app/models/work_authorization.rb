class WorkAuthorization < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  validates :work_title, presence: true
end
