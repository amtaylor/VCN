class UserCompany < ActiveRecord::Base
  belongs_to :user
  belongs_to :company
  scope :funded_recently, -> {where("created_at > ?", Time.now.at_midnight)}
end
