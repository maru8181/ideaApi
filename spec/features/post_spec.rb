require 'rails_helper'
require 'spec_helper'

describe 'トップページ', type: :feature do
  it "表示されること" do
    visit root_path
  end
end