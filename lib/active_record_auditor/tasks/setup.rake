require 'active_record'

namespace :db do
  namespace :audit do
    task :create_audit_tables do
      sql = ActiveRecord::Base.connection
      sql.tables.each do |table|
        next if table == "schema_migrations"
        time = Time.now
        sql.begin_db_transaction
        sql.execute("CREATE TABLE #{table}_#{time.month}_#{time.year} like #{table}")
        ActiveRecord::Migration.add_column table.to_sym, :username, :string
        ActiveRecord::Migration.add_column table.to_sym, :version, :integer, default: 0
        ActiveRecord::Migration.add_column table.to_sym, :deleted, :boolean
        ActiveRecord::Migration.add_column table.to_sym, :canonical_id, :integer
        indexes = sql.execute("SHOW INDEX FROM #{table}")
        indexes.each do |index|
          sql.execute("ALTER TABLE #{table} DROP INDEX #{index[2]};") unless index[2] == 'PRIMARY'
        end
        add_index table.to_sym, [:canonical_id, :version], unique: true
        sql.commit_db_transaction
      end
    end
  end
end