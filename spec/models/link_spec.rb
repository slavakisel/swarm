require 'rails_helper'

describe Link, type: :model do
  subject(:link) { build(:link) }

  describe '#processed?' do
    it { is_expected.not_to be_processed }

    context 'when processed date present' do
      subject(:link) { build(:link, last_processed_at: DateTime.now) }

      it { is_expected.to be_processed }
    end
  end

  describe '#modified?' do
    it { is_expected.to be_modified }

    context 'when modified date goes after stored date' do
      before do
        stub_request(:head, link.url).
          to_return(headers: { 'Last-Modified' => DateTime.now.to_s })
      end

      subject(:link) { build(:link, last_modified_at: 1.day.ago) }

      it { is_expected.to be_modified }
    end

    context 'when modified date goes before stored date' do
      before do
        stub_request(:head, link.url).
          to_return(headers: { 'Last-Modified' => 2.days.ago.to_s })
      end

      subject(:link) { build(:link, last_modified_at: 1.day.ago) }

      it { is_expected.not_to be_modified }
    end
  end
end
