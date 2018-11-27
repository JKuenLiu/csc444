require 'rails_helper'

describe HomepageController, type: :controller do
  describe 'searching' do
    it 'find all items by item name' do
      fake_items = [instance_double("Item", :name => "Vacuum Cleaner")]
      expect(Item).to receive(:where).with("name LIKE ?", "%vacuum%").and_return(fake_items)
      get :index, params: {:term => "vacuum"}
      expect(assigns(:all_items)).to eq (fake_items)
    end
    it 'find all items by tag name' do
      fake_sports_tag = instance_double("Tag", :name => "sports")
      fake_tags = [fake_sports_tag]
      fake_items = [instance_double("Item", :name => "Basketball")]
      expect(Tag).to receive(:where).with("name LIKE ?", "%sports%").and_return(fake_tags)
      expect(fake_sports_tag).to receive(:items).and_return(fake_items)
      get :index, params: {:term => "sports"}
      expect(assigns(:all_items)).to eq (fake_items)
    end
    it 'find all items no search query' do
      fake_items = [instance_double("Item", :name => "Basketball")]
      expect(Item).to receive(:all).and_return(fake_items)
      get :index
      expect(assigns(:all_items)).to eq (fake_items)
    end
    it 'test items with same tag and name do not appear twice' do
      fake_sports_tag = instance_double("Tag", :name => "ball")
      fake_tags = [fake_sports_tag]
      fake_items = [instance_double("Item", :name => "ball")]
      expect(Tag).to receive(:where).with("name LIKE ?", "%ball%").and_return(fake_tags)
      expect(fake_sports_tag).to receive(:items).and_return(fake_items)
      expect(Item).to receive(:where).with("name LIKE ?", "%ball%").and_return(fake_items)
      get :index, params: {:term => "ball"}
      expect(assigns(:all_items)).to eq (fake_items)
    end

  end

end
