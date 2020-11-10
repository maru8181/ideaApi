require 'rails_helper'

RSpec.describe 'Apis', type: :request do
  describe 'GET /' do
    context 'データが登録されていない時' do
      it '404を返すこと' do
        get root_path
        json = JSON.parse(response.body)
        expect(json['status']).to eq('error')
        expect(json['code']).to eq('404')
      end
    end

    context 'データが登録されている時' do
      before(:each) do
        @category = create(:category, :a)
        @idea = create(:idea, :a)
      end

      it '登録データを返すこと' do
        get root_path
        json = JSON.parse(response.body)
        expect(json['data'][0]['id']).to eq(1)
        expect(json['data'][0]['category']).to eq('money')
        expect(json['data'][0]['body']).to eq('work')
      end
    end
  end

  describe 'GET /:category_name' do
    context 'リクエストの category_name が登録されていないカテゴリーの場合' do
      it '404を返すこと' do
        get '/example'
        json = JSON.parse(response.body)
        expect(json['status']).to eq('error')
        expect(json['code']).to eq('404')
      end
    end

    context 'リクエストの category_name が登録されているカテゴリーの場合' do
      before(:each) do
        @category_a = create(:category, :a)
        @category_b = create(:category, :b)
        @idea_a = create(:idea, :a)
        @idea_b = create(:idea, :b)
        @idea_c = create(:idea, :c)
      end

      it 'リクエストの category_name が money の時、カテゴリーが money のアイディア一覧を返却' do
        get '/money'
        json = JSON.parse(response.body)
        expect(json['data'][0]['id']).to eq(1)
        expect(json['data'][0]['category']).to eq('money')
        expect(json['data'][0]['body']).to eq('work')
      end

      it 'リクエストの category_name が sports の時、カテゴリーが sports のアイディア一覧を返却' do
        get '/sports'
        json = JSON.parse(response.body)
        expect(json['data'][0]['id']).to eq(2)
        expect(json['data'][0]['category']).to eq('sports')
        expect(json['data'][0]['body']).to eq('run')
        expect(json['data'][1]['id']).to eq(3)
        expect(json['data'][1]['category']).to eq('sports')
        expect(json['data'][1]['body']).to eq('walk')
      end
    end
  end

  describe 'GET /:category_name/:body' do
    before(:each) do
      @category_a = create(:category, :a)
      @category_b = create(:category, :b)
      @idea_a = create(:idea, :a)
      @idea_b = create(:idea, :b)
      @idea_c = create(:idea, :c)
    end

    context 'リクエストの category_name が categories テーブルの name に存在しない場合' do
      it '登録成功の場合、201を返すこと' do
        get '/eat/breakfast'
        json = JSON.parse(response.body)
        expect(json['status']).to eq('success')
        expect(json['code']).to eq('201')
      end

      it '登録成功の場合、新たな category として categories テーブルに登録し、ideas テーブルに登録すること' do
        get '/eat/breakfast'
        new_category = Category.find(3)
        new_category.present?
        expect(new_category.name).to eq('eat')
        new_idea = Idea.find(4)
        new_idea.present?
        expect(new_idea.category_id).to eq(3)
        expect(new_idea.body).to eq('breakfast')
        expect(Category.all.count).to eq(3)
        expect(Idea.all.count).to eq(4)
      end
    end

    context 'リクエストの category_name が categories テーブルの name に存在する場合' do
      it '登録成功の場合、201を返すこと' do
        get '/sports/soccer'
        json = JSON.parse(response.body)
        expect(json['status']).to eq('success')
        expect(json['code']).to eq('201')
      end

      it '登録成功の場合、category の id を category_id として categories テーブルに登録し、ideas テーブルに登録すること' do
        get '/sports/soccer'
        new_idea = Idea.find(4)
        new_idea.present?
        expect(new_idea.category_id).to eq(2)
        expect(new_idea.body).to eq('soccer')
        expect(Category.all.count).to eq(2)
        expect(Idea.all.count).to eq(4)
      end
    end

    context 'リクエストの category_name が空の場合' do
      it '登録失敗し、422を返すこと' do
        get '/%20/example'
        json = JSON.parse(response.body)
        expect(json['status']).to eq('error')
        expect(json['code']).to eq('422')
      end

      it '登録失敗し、categories、ideas テーブルに登録されていないこと' do
        get '/%20/example'
        Category.find_by(name: '').nil?
        Idea.find_by(body: 'example').nil?
        expect(Category.all.count).to eq(2)
        expect(Idea.all.count).to eq(3)
      end
    end

    context 'リクエストの body が空の場合' do
      it '登録失敗し、422を返すこと' do
        get '/money/%20'
        json = JSON.parse(response.body)
        expect(json['status']).to eq('error')
        expect(json['code']).to eq('422')
      end

      it '登録失敗し、categories、ideas テーブルに登録されていないこと' do
        get '/eat/%20'
        Category.find_by(name: 'eat').nil?
        Idea.find_by(body: '').nil?
        expect(Category.all.count).to eq(2)
        expect(Idea.all.count).to eq(3)
      end
    end
  end

  describe '指定外のリクエストがあった時' do
    it '/ にリダイレクトすること' do
      get '/example/aaa/bbb/ccc'
      expect(response).to redirect_to('/')
    end
  end
  
end
