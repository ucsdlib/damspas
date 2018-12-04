class WorkAuthorization < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  validates :work_pid, presence: true

  scope :in_error, ->{ where("error <> ''") }

  def update_error error_string
    update_attribute :error, error_string 
  end

  def clear_error 
    update_attribute :error, nil
  end

end
