class WorkAuthorization < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  validates :work_pid, presence: true
end
