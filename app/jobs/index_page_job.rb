class IndexPageJob < ApplicationJob
  queue_as :default

  def perform(url)
    Link.create(url: url)
  end
end
