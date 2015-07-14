class AddInReportToWheretables < ActiveRecord::Migration
  def change
    add_column :wheretables, :in_report, :string
  end
end
