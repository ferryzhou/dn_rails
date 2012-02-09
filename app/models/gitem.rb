class Gitem < ActiveRecord::Base
  belongs_to :clusters
  belongs_to :word
end
