# active_record_auditor
Audit Framework For ActiveRecord

so general idea, is
the project will extend active record
each table, will have a duplicate table, with version name, action, username fields added
once the table is setup, all changes to the table will be wrapped in a transaction
which copies the previous version with the username, an incrementing version number, and the action (create update delete).
as well as making the changes to the specified row
it records all the previous version
there should be a flag that either blocks changes with no user or records them.
and the ability to split the audit tables into a table per monthly tables
so that you can eventually trim tables from older months for size preservation
so if your table name is titles you'll have titles, titles_audit_april_2014, titles_audit_may_2014, etc.
and if you only want to keep record for so long
