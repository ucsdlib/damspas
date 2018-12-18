# frozen_string_literal: true

class WorkAuthorization < ActiveRecord::Base # rubocop:disable ApplicationRecord
  belongs_to :user, counter_cache: true
  validates :work_pid, presence: true

  scope :in_error, -> { where("error <> ''") }

  def update_error(error_string)
    # skip model validations because if there was
    # an error, we want to log it no matter what
    update_attribute(:error, error_string) # rubocop:disable SkipsModelValidations
  end

  def clear_error
    # skip model validations because if there was
    # an error, we want to log it no matter what
    update_attribute(:error, nil) # rubocop:disable SkipsModelValidations
  end
end
