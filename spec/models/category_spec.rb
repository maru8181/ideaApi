require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'category モデルの作成' do
    let(:category) { Category.new(name: name) }
    subject { category.valid? }
    before(:each) do
      @category = create(:category, :a)
      @idea = create(:idea, :a)
    end

    context 'ユニークな name を入力する場合、保存できること' do
      let(:name) { 'example' }
      it { is_expected.to be_truthy }
    end

    context 'ユニークでない name を入力する場合、保存できないこと' do
      let(:name) { 'money' }
      it { is_expected.to be_falsey }
    end

    context 'name が空の場合は、保存できないこと' do
      let(:name) { '' }
      it { is_expected.to be_falsey }
    end
  end
end
