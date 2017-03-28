require 'rails_helper'

describe LinksController, type: :controller do
  describe '#POST create' do
    let(:link_params) { { url: 'http://example.com' } }
    let(:body) { JSON.parse(response.body) }

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
end
