class Link < ApplicationRecord
  has_many :elements

  validates :url, presence: true, length: { maximum: 2083 }

  paginates_per 25
  max_paginates_per 50

  scope :processed, -> { where.not(last_processed_at: nil) }

  def processed?
    !!last_processed_at
  end

  def modified?
    return true unless last_modified_at # for new records

    response = HTTParty.head(url)
    page_last_modified = DateTime.parse(response.headers['last-modified'].to_s)
    page_last_modified > last_modified_at
  rescue SocketError, ArgumentError
  end
end
