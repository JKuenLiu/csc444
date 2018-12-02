require 'rails_helper'
describe ItemsController, type: :controller do
  describe 'listing items' do
    it 'list your items' do
      subject.class.skip_before_action :num_of_notifications
      setUpUserAndItems
      get :index, params: {:your_items => 'true'}
      expect(assigns(:show_your_items)).to eq ("true")
      expect(assigns(:user_items)).to eq (@fake_user_items)
    end
    it 'list borrowed items' do
      setUpUserAndItems
      get :index, params: {:your_items => 'false'}
      expect(assigns(:show_your_items)).to eq ("false")
      expect(assigns(:user_items)).to eq (@fake_borrowed_items)
    end
  end
end



def setUpUserAndItems
  setUpUserAndAuthenticate
  @fake_person = instance_double("Person", :fname => "Fred")
  @fake_user_items = [instance_double("Item", :name => "Basketball")]
  @fake_borrowed_item = instance_double("Item", :name => "Soccer Ball")
  @fake_borrowed_items = [@fake_borrowed_item]
  allow(@fake_person).to receive(:id).and_return(99)
  allow(@fake_user).to receive(:id).and_return(99)
  allow(@fake_borrowed_item).to receive(:id).and_return(12345)
  allow(@fake_person).to receive(:items).and_return(@fake_user_items)
  allow(Item).to receive(:where).with({:current_holder=>99}).and_return(@fake_borrowed_items)
  allow(Person).to receive(:find_by_user_id).and_return(@fake_person)

end