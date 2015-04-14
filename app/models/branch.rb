class Branch < ActiveRecord::Base
  establish_connection "memp_#{::Rails.env}"
end