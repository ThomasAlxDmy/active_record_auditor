require 'active_record'
require 'active_record_auditor/extensions/array'

module ActiveRecord

  module ActiveRecordAuditorPersistence

    extend ActiveRecord::Persistence

    def _update_relation_record
      connection.execute(audit_update_sql) if should_audit?
    end

    def _delete_relation_record
      connection.execute(audit_delete_sql) if should_audit?
    end

    private

    def _create_record(attribute_names = self.attribute_names)
      transaction do 
        super(attribute_names)
        connection.execute(new_record_sql) if should_audit?
      end
    end

    def _update_record(attribute_names = self.attribute_names)
      transaction do
        connection.execute(audit_update_sql) if should_audit?
        super(attribute_names)
      end
    end

    def existing_row
      connection.execute(existing_row_sql).first
    end

    def audit_create_sql
      "INSERT INTO `#{ensure_audit_table}` (#{required_audit_attribute_names.to_sql_columns}) VALUES (#{required_audit_attributes.to_sql_values})"
    end

    def audit_update_sql
      "INSERT INTO `#{ensure_audit_table}` (#{attribute_names.drop(1).to_sql_columns}, #{required_audit_attribute_names.to_sql_columns}) VALUES (#{existing_row.drop(1).to_sql_values}, #{required_audit_attributes.to_sql_values})"
    end

    def audit_delete_sql
      "INSERT INTO `#{ensure_audit_table}` (#{attribute_names.drop(1).to_sql_columns}, #{required_audit_attribute_names.push('__deleted').to_sql_columns}) VALUES (#{existing_row.drop(1).to_sql_values}, #{required_audit_attributes.push(1).to_sql_values})"
    end

    def existing_row_sql
      "SELECT * FROM `#{model.table_name}` where id = #{id} limit 1"
    end

    def version_lookup_sql(audit_date = datetime)
      "SELECT * FROM #{audit_table_name(audit_date)} where __canonical_id=#{id} ORDER BY __created_at DESC"
    end

    def required_audit_attribute_names
      ['__username', '__canonical_id', '__version', '__created_at']
    end

    def required_audit_attributes
      [__username, "#{id}", "#{next_version}", "#{datetime.to_s}"]
    end

    def next_version
      latest_version + 1
    end

    def latest_version
      ensure_audit_table
      latest_update = connection.execute(version_lookup_sql).first
      latest_revision = latest_update[latest_update.length-2] if latest_update
      table_date = datetime - 1.month
      misses = 0
      while latest_revision.nil? && misses < 12
        table_date = table_date - 1.month
        if audit_table_exists?(table_date)
          latest_update = connection.execute(version_lookup_sql(table_date)).first
          latest_revision = latest_update[latest_update.length-2] if latest_update
          misses = 0
        else
          misses += 1
        end
      end
      latest_revision.nil? ? -1 : latest_revision
    end

    def audit_table_name(audit_date = datetime)
      "#{model.table_name}_#{audit_date.month}_#{audit_date.year}"
    end

    def ensure_audit_table
      unless audit_table_exists?
        ActiveRecordAuditor.build_audit_table(model.table_name)
      end
      audit_table_name
    end

    def audit_table_exists?(audit_date = datetime)
      connection.table_exists? audit_table_name(audit_date)
    end

    def datetime
      Time.now
    end

    def should_audit?
      raise NoAuditUser, "Writes are currently disabled without a specified user" if __username.nil? && __user_required
      __username || __log_userless_actions
    end

    def __username
      @__username
    end

    def __log_userless_actions
      model.try(:log_userless_actions) || model.try(:__log_userless_actions)
    end

    def __user_required
      model.try(:user_required) || model.try(:__user_required)
    end

    def model
      self.class
    end

    def connection
      model.connection
    end
  end
end