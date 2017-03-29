RSpec.configure do |config|
  config.before :each, :sidekiq_inline do
    Sidekiq::Testing.inline!
  end

  config.after :each, :sidekiq_inline do
    Sidekiq::Testing.fake!
  end
end
