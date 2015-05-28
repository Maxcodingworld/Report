module ActiveRecordExtension

  extend ActiveSupport::Concern

  # add your static(class) methods here
  module ClassMethods
    def pluck_details(pluck_values=[])
      self.connection.select_all(select(pluck_values).arel)
    end
  end
end

# include the extension
ActiveRecord::Base.send(:include, ActiveRecordExtension)