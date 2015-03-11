require 'spec_helper'

describe ActiveRecordAuditor do
  it 'has a version number' do
    expect(ActiveRecordAuditor::VERSION).not_to be nil
  end

  it 'builds the appropriate audit table' do
    expect(false).to eq(true)
  end
end
