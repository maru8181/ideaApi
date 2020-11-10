require 'rails_helper'

RSpec.describe Idea, type: :model do
  describe 'idea モデルの作成' do
    let(:idea) { Idea.new(category_id: category_id, body: body) }
    subject { idea.valid? }
    before(:each) do
      @category = create(:category, :a)
    end

    context 'category_id, body を入力する場合、保存できること' do
      let(:category_id) { 1 }
      let(:body) { 'example' }
      it { is_expected.to be_truthy }
    end

    context 'category_id が空の場合、保存できないこと' do
      let(:category_id) { '' }
      let(:body) { 'example' }
      it { is_expected.to be_falsey }
    end

    context 'body が空の場合、保存できないこと' do
      let(:category_id) { 1 }
      let(:body) { '' }
      it { is_expected.to be_falsey }
    end
  end
end
