class EtlAuthor < ActiveRecord::Base
  attr_accessible :name
  	belongs_to :etl_title
  
end
