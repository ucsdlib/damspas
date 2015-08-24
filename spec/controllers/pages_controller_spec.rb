require 'spec_helper'

describe PagesController do

  # This should return the minimal set of attributes required to create a valid
  # Page. As you add validations to Page, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "code" => "page_code", "title" => "Page Title" } }

  describe "public" do

    describe "GET index" do
      it "assigns all pages as @pages" do
        page = Page.create! valid_attributes
        get :index, {}
        assigns(:pages).should eq([page])
      end
    end

    describe "GET show" do
      it "assigns the requested page as @page" do
        page = Page.create! valid_attributes
        get :show, {:id => page.to_param}
        assigns(:page).should eq(page)
      end
    end

    describe "GET view" do
      it "assigns the requested page as @page" do
        page = Page.create! valid_attributes
        get :view, {:id => page.code}
        assigns(:page).should eq(page)
      end
    end

  end

  describe "authenticated" do
    before do
      sign_in User.create!( {:provider => 'developer'} )
    end

    describe "GET new" do
      it "assigns a new page as @page" do
        get :new, {}
        assigns(:page).should be_a_new(Page)
      end
    end
  
    describe "GET edit" do
      it "assigns the requested page as @page" do
        page = Page.create! valid_attributes
        get :edit, {:id => page.to_param}
        assigns(:page).should eq(page)
      end
    end
  
    describe "POST create" do
      describe "with valid params" do
        it "creates a new Page" do
          expect {
            post :create, {:page => valid_attributes}
          }.to change(Page, :count).by(1)
        end
  
        it "assigns a newly created page as @page" do
          post :create, {:page => valid_attributes}
          assigns(:page).should be_a(Page)
          expect(assigns(:page).persisted?).to be_true
        end
  
        it "redirects to the created page" do
          post :create, {:page => valid_attributes}
          response.should redirect_to action: :index
        end
      end
  
      describe "with invalid params" do
        it "assigns a newly created but unsaved page as @page" do
          # Trigger the behavior that occurs when invalid params are submitted
          Page.any_instance.stub(:save).and_return(false)
          post :create, {:page => { "code" => "invalid value" }}
          assigns(:page).should be_a_new(Page)
        end
  
        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Page.any_instance.stub(:save).and_return(false)
          post :create, {:page => { "code" => "invalid value" }}
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested page" do
          page = Page.create! valid_attributes
          # Assuming there are no other pages in the database, this
          # specifies that the Page created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Page.any_instance.should_receive(:update).with({ "code" => "my_code" })
          put :update, {:id => page.to_param, :page => { "code" => "my_code" }}
        end
  
        it "assigns the requested page as @page" do
          page = Page.create! valid_attributes
          put :update, {:id => page.to_param, :page => valid_attributes}
          assigns(:page).should eq(page)
        end
  
        it "redirects to the page" do
          page = Page.create! valid_attributes
          put :update, {:id => page.to_param, :page => valid_attributes}
          response.should redirect_to action: :edit, id: page.id
        end
      end
  
      describe "with invalid params" do
        it "assigns the page as @page" do
          page = Page.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Page.any_instance.stub(:save).and_return(false)
          put :update, {:id => page.to_param, :page => { "code" => "invalid value" }}
          assigns(:page).should eq(page)
        end
  
        it "re-renders the 'edit' template" do
          page = Page.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Page.any_instance.stub(:save).and_return(false)
          put :update, {:id => page.to_param, :page => { "code" => "invalid value" }}
          response.should render_template("edit")
        end
      end
    end
  
    describe "DELETE destroy" do
      it "destroys the requested page" do
        page = Page.create! valid_attributes
        expect {
          delete :destroy, {:id => page.to_param}
        }.to change(Page, :count).by(-1)
      end
  
      it "redirects to the pages list" do
        page = Page.create! valid_attributes
        delete :destroy, {:id => page.to_param}
        response.should redirect_to action: :index
      end
    end

  end

end
