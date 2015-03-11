require "active_record_auditor/extensions/active_record_auditor_persistence"
require "active_record_auditor/extensions/active_record_auditor_relation"

module ActiveRecord
  module Persistence
    prepend ActiveRecordAuditorPersistence
  end

  class Relation
    prepend ActiveRecordAuditorRelation
  end

  class NoAuditUser < ActiveRecordError
  end
end