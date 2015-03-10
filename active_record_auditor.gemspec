# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_record_auditor/version'

Gem::Specification.new do |spec|
  spec.name          = "active_record_auditor"
  spec.version       = ActiveRecordAuditor::VERSION
  spec.authors       = ["Nic Wilson"]
  spec.email         = ["wilsonic89@yahoo.com"]

  spec.summary       = "Framework for auditing user actions in ActiveRecord"
  spec.description   = "I should really do this at some point"
  spec.homepage      = "https://github.com/nbwilson/active_record_auditor"
  spec.license       = "MIT"

  spec.files         = ['README.md']

  spec.add_development_dependency "bundler", "~> 1.8"
end
