class Page < ActiveRecord::Base
  validates_format_of :code, with: /\A([a-z0-9_])+\z/i
  validates :code, presence: true, uniqueness: true
  validates :title, presence: true
end
