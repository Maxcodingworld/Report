class EtlInfo < ActiveRecord::Base
  attr_accessible :last_etl_id, :table_name
end
