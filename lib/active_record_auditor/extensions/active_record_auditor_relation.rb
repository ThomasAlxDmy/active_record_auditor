module ActiveRecord
  module ActiveRecordAuditorRelation

    def delete_all(conditions = nil)
      if conditions
        super
      else
        transaction do
          to_a.each {|object| object._delete_relation_record}
          super
        end
      end
    end

    def update_all(updates)
      transaction do
        to_a.each {|object| object._update_relation_record}
        super
      end
    end
  end
end