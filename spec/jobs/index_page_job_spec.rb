require 'rails_helper'

describe IndexPageJob, :sidekiq_inline do
  let(:url) { 'http://example.com' }

  context 'when link does not exists' do
    it 'creates and indexes link' do
      expect_any_instance_of(LinkIndexer).to receive(:call)
      expect { IndexPageJob.perform_now(url) }.to change { Link.count }.by(1)
    end
  end

  context 'when link exists' do
    context 'and link is not processed' do
      let!(:link) { create(:link, url: url) }

      it 'does nothing' do
        expect_any_instance_of(LinkIndexer).not_to receive(:call)
        expect { IndexPageJob.perform_now(url) }.not_to change { Link.count }
      end
    end

    context 'and link is processed' do
      context 'and link has not been modified' do
        let(:link) do
          create(:link, url: url, last_processed_at: DateTime.now, last_modified_at: 1.day.ago)
        end

        before do
          stub_request(:head, link.url).
            to_return(headers: { 'Last-Modified' => 'Fri, 09 Aug 2013 GMT' })
        end

        it 'does nothing' do
          expect_any_instance_of(LinkIndexer).not_to receive(:call)
          expect { IndexPageJob.perform_now(url) }.not_to change { Link.count }
        end
      end

      context 'and link has been modified' do
        let(:link) do
          create(:link, url: url, last_processed_at: DateTime.now, last_modified_at: 1.day.ago)
        end

        before do
          stub_request(:head, link.url).
            to_return(headers: { 'Last-Modified' => DateTime.now.to_s })
        end

        it 'reindexes link' do
          expect_any_instance_of(LinkIndexer).to receive(:call)
          expect { IndexPageJob.perform_now(url) }.not_to change { Link.count }
        end
      end
    end
  end
end
