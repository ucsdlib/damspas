require 'spec_helper'

RSpec.describe Aeon::QueuesController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Aeon::Queue. As you add validations to Aeon::Queue, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Aeon::QueuesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      queue = Aeon::Queue.create! valid_attributes
      get :index, {}, valid_session
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      queue = Aeon::Queue.create! valid_attributes
      get :show, {:id => queue.to_param}, valid_session
      expect(response).to be_success
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, {}, valid_session
      expect(response).to be_success
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      queue = Aeon::Queue.create! valid_attributes
      get :edit, {:id => queue.to_param}, valid_session
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Aeon::Queue" do
        expect {
          post :create, {:aeon_queue => valid_attributes}, valid_session
        }.to change(Aeon::Queue, :count).by(1)
      end

      it "redirects to the created aeon_queue" do
        post :create, {:aeon_queue => valid_attributes}, valid_session
        expect(response).to redirect_to(Aeon::Queue.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, {:aeon_queue => invalid_attributes}, valid_session
        expect(response).to be_success
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested aeon_queue" do
        queue = Aeon::Queue.create! valid_attributes
        put :update, {:id => queue.to_param, :aeon_queue => new_attributes}, valid_session
        queue.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the aeon_queue" do
        queue = Aeon::Queue.create! valid_attributes
        put :update, {:id => queue.to_param, :aeon_queue => valid_attributes}, valid_session
        expect(response).to redirect_to(queue)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        queue = Aeon::Queue.create! valid_attributes
        put :update, {:id => queue.to_param, :aeon_queue => invalid_attributes}, valid_session
        expect(response).to be_success
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested aeon_queue" do
      queue = Aeon::Queue.create! valid_attributes
      expect {
        delete :destroy, {:id => queue.to_param}, valid_session
      }.to change(Aeon::Queue, :count).by(-1)
    end

    it "redirects to the aeon_queues list" do
      queue = Aeon::Queue.create! valid_attributes
      delete :destroy, {:id => queue.to_param}, valid_session
      expect(response).to redirect_to(aeon_queues_url)
    end
  end
end
