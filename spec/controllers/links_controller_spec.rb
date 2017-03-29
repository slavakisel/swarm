require 'rails_helper'

describe LinksController, type: :controller do
  let(:body) { JSON.parse(response.body) }

  describe '#POST create' do
    let(:link_params) { { url: 'http://example.com' } }

    def do_request
      post :create, params: { link: link_params }
    end

    it 'it queues link creation' do
      do_request

      expect(response).to have_http_status(200)
      expect(body['message']).to eq 'Url has been queued for indexing.'
    end

    context 'when url is blank' do
      let(:link_params) { { url: '' } }

      it 'it renders error if url is blank' do
        do_request

        expect(response).to have_http_status(400)
        expect(body['errors']['url']).to include "can't be blank"
      end
    end
  end

  describe '#GET index' do
    let!(:processed) { create(:link, last_processed_at: DateTime.now) }
    let!(:unprocessed) { create(:link) }

    let(:expected_data) do
      [{
        "id" => processed.id.to_s,
        "type" => "links",
        "attributes" => {
          "url" => "http://example.com"
        }
      }]
    end

    def do_request
      get :index
    end

    it 'it renders processed links' do
      do_request

      expect(response).to have_http_status(200)
      expect(body['data']).to eq expected_data
    end
  end
end
