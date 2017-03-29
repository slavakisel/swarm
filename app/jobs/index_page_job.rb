class IndexPageJob < ApplicationJob
  queue_as :default

  def perform(url)
    link = Link.find_by(url: url)

    if link.present?
      # index only processed links in order to fetch url
      # only onece when the same url is queued multiple times
      index_link(link) if link.processed? && link.modified?
    else
      link = Link.create(url: url)
      index_link(link)
    end
  end

  private

  def index_link(link)
    LinkIndexer.new(link).call
  end
end
