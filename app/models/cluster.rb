class Cluster < ActiveRecord::Base
  has_many :gitems
  belongs_to :word
end
