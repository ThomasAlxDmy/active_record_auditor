require "active_record_auditor/version"
require "active_record_auditor/extensions/active_record"
require 'active_record'

module ActiveRecordAuditor
  def self.build_audit_table(table)
    time = Time.now
    new_table_name = "#{table}_#{time.month}_#{time.year}"
    ActiveRecord::Base.connection.execute("CREATE TABLE #{new_table_name} like #{table}")
    ActiveRecord::Base.connection.execute("SHOW INDEX FROM #{new_table_name}").to_a.uniq{|index| index[2]}.each do |index|
      ActiveRecord::Base.connection.execute("ALTER TABLE #{new_table_name} DROP INDEX #{index[2]};") unless index[2] == 'PRIMARY'
    end
    ActiveRecord::Base.connection.execute("DESCRIBE #{new_table_name}").to_a.uniq{|index| index[0]}.each do |col|
      ActiveRecord::Base.connection.execute("ALTER TABLE #{new_table_name} MODIFY COLUMN #{col[0]} #{col[1]};") if col[2] == "YES"
    end
    ActiveRecord::Migration.add_column new_table_name.to_sym, :__username, :string
    ActiveRecord::Migration.add_column new_table_name.to_sym, :__deleted, :boolean, default: false
    ActiveRecord::Migration.add_column new_table_name.to_sym, :__canonical_id, :integer, null: false
    ActiveRecord::Migration.add_column new_table_name.to_sym, :__version, :integer, null: false
    ActiveRecord::Migration.add_column new_table_name.to_sym, :__created_at, :datetime, null: false
    ActiveRecord::Migration.add_index new_table_name.to_sym, [:__canonical_id, :__version], unique: true
  end

  def self.load_tasks
    load "active_record_auditor/tasks/setup.rake"
  end
end