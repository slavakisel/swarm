require 'rails_helper'

describe IndexPageJob, :sidekiq_inline do
  let(:url) { 'http://example.com' }

  it 'creates link' do
    expect { IndexPageJob.perform_now(url) }.to change { Link.count }.by(1)
  end
end
