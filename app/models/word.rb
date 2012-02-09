class Word < ActiveRecord::Base
  has_many :gitems
  has_many :clusters
end
