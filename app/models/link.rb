class Link < ApplicationRecord
  validates :url, presence: true, length: { maximum: 2083 }
end
