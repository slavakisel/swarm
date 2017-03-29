require 'rails_helper'

describe LinkIndexer do
  let(:link) { create(:link) }

  before do
    stub_request(:get, link.url).
      to_return(
        body: "<h1>Header 1</h1><h2>Header 2</h2>" +
          "<h3>Header 3</h3><a>Link</a>",
        headers: { 'Last-Modified' => 'Fri, 09 Aug 2013 23:54:35 GMT' }
      )
  end

  def index_link
    described_class.new(link).call
  end

  it 'creates link elements' do
    expect { index_link }.to change { link.elements.count }.by(4)

    expect(link.elements.pluck(:tag)).to match_array(%w(h1 h2 h3 a))
    expect(link.elements.pluck(:content)).to match_array(
      ['Header 1', 'Header 2', 'Header 3', 'Link']
    )
  end

  it 'stores indexed page last modified date' do
    expect { index_link }
      .to change { link.last_modified_at }
      .from(nil)
      .to(DateTime.new(2013, 8, 9, 23, 54, 35))
  end

  it 'marks link as processed' do
    expect(link).not_to be_processed

    index_link

    expect(link).to be_processed
  end
end
