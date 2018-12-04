# frozen_string_literal: true

class WorkAuthorization < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  validates :work_pid, presence: true

  scope :in_error, -> { where("error <> ''") }

  def update_error(error_string)
    update!(error: error_string)
  end

  def clear_error
    update!(error: nil)
  end
end
