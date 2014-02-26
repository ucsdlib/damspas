class Page < ActiveRecord::Base
  validates_format_of :code, with: /([a-z0-9_])+/i
  validates :code, presence: true, uniqueness: true
  validates :title, presence: true
end
