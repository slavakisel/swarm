class LinkIndexer
  attr_reader :link
  private :link

  def initialize(link)
    @link = link
  end

  def call
    Element.import(elements)

    link.update_attributes(
      last_processed_at: DateTime.now,
      last_modified_at: last_modified_at
    )
  end

  private

  def response
    @_response ||= HTTParty.get(link.url)
  end

  def page
    @_page ||= Nokogiri::HTML(response)
  end

  def elements
    link_elements + header_elements
  end

  def link_elements
    page.css('a').map do |ref|
      link.elements.build(tag: 'a', content: ref.text)
    end
  end

  def header_elements
    headers = (1..3).to_a.map do |i|
      tag = "h#{i}"
      page.css(tag).map do |header|
        link.elements.build(tag: tag, content: header.text)
      end
    end
    headers.flatten
  end

  def last_modified_at
    date = response.headers["last-modified"]
    date ? DateTime.parse(response.headers["last-modified"].to_s) : DateTime.now
  rescue ArgumentError
    DateTime.now
  end
end
