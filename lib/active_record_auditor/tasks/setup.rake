require 'active_record'

#Can't wrap these requests in a ActiveRecord Transaction, because DDL commands can not be rolled back per MySQL documentation
namespace :db do
  namespace :audit do
    task :create_audit_tables do
      ActiveRecord::Base.connection.tables.each do |table|
        next if table == "schema_migrations"
        ActiveRecordAuditor.build_audit_table(table)
      end
    end
  end
end