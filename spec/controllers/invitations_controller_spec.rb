require "rails_helper"
require "devise"

RSpec.describe InvitationsController, type: :controller do
  before do
    sign_in user
  end

  describe "GET #show" do
    let(:organization){FactoryGirl.create :organization, creator_id: user.id, slug: 1}
    let(:user){FactoryGirl.create :user, slug: 1}
    it "get show success" do
      get :show, params: {organization_id: organization.id}
      expect(assigns(:user_org)).to be_truthy
    end
    it "not found" do
      get :show, params: {organization_id: organization.id}
      expect(assigns(:user_org)).to be_nil
      expect(controller).to set_flash[:notice].to("Not found")
      expect(response).to redirect_to root_path
    end
  end

  describe "GET #edit" do
    let(:user){FactoryGirl.create :user, slug: 3}
    let(:organization){FactoryGirl.create :organization, creator_id: user.id, slug: 3}
    it "render template edit" do
      get :edit, params: {id: user.id, organization_id: organization.id}
      expect(assigns(:user_org)).to be_truthy
      expect(response).to render_template(:edit)
    end
  end

  describe "POST #create" do
    let(:user){FactoryGirl.create :user, slug: 4}
    let(:user1){FactoryGirl.create :user, slug: 5}
    let(:organization){FactoryGirl.create :organization, creator_id: user.id, slug: 4}
    context "success" do
      it "create success" do
        expect do
          post :create, params: {organization_id: organization.id,
            user_organization: {organization_id: organization.id, user_id: user1.id, status: :waiting}}
          expect(controller).to set_flash[:success].to(I18n.t "invitations.create.success")
        end.to change(UserOrganization, :count).by 2
      end
    end
  end

  describe "PATCH #update" do
    context "success" do
      let(:user){FactoryGirl.create :user, slug: 6}
      let(:organization){FactoryGirl.create :organization, creator_id: user.id, slug: 5}
      it "update succes" do
        user_organization = UserOrganization.find_by(user_id: user.id,
          organization_id: organization.id)
        expect do
          patch :update, params: {organization_id: organization.id,
            id: user_organization.id, user_organization: {status: :waiting}}
          expect(controller).to set_flash[:success].to(I18n.t "invitations.update.success")
          expect(response).to redirect_to root_path
        end
      end
    end
    context "failed" do
      let(:user){FactoryGirl.create :user, slug: 7}
      let(:organization){FactoryGirl.create :organization, creator_id: user.id, slug: 6}
      it "update failed" do
        user_organization = UserOrganization.find_by(user_id: user.id,
          organization_id: organization.id)
        expect do
          allow(UserOrganization).to receive(:find).with(user_organization.id.to_s)
            .and_return(user_organization)
          allow(user_organization).to receive(:update_attributes).and_return(false)
          patch :update, params: {organization_id: organization.id,
            id: user_organization.id,
            user_organization: {organization_id: organization.id, user_id: user.id, status: :waiting}}
          expect(response).to redirect_to root_path
        end.to change(UserOrganization, :count).by 0
      end

      it "not found" do
        user_organization = UserOrganization.find_by(user_id: user.id,
          organization_id: organization.id)
        expect do
          patch :update, params: {organization_id: organization.id,
            id: user_organization.id,
            user_organization: {organization_id: organization.id, user_id: user.id, status: :waiting}}
          expect(controller).to set_flash[:notice].to("Not found")
          expect(response).to redirect_to root_path
        end.to change(UserOrganization, :count).by 0
      end
    end
  end

  describe "DELETE #destroy" do
    let(:user){FactoryGirl.create :user, slug: 6}
    let(:organization){FactoryGirl.create :organization, creator_id: user.id, slug: 6}
    it "delete success" do
      user_organization = UserOrganization.find_by(user_id: user.id,
        organization_id: organization.id)
      expect do
        delete :destroy, params: {organization_id: organization.id, id: user_organization.id}
        expect(controller).to set_flash[:success].to(I18n.t "invitations.destroy.cancel_success")
      end
    end
    it "delete failed" do
      user_organization = UserOrganization.find_by(user_id: user.id,
        organization_id: organization.id)
      expect do
        allow(UserOrganization).to receive(:find).with(user_organization.id.to_s)
          .and_return(user_organization)
        allow(user_organization).to receive(:destroy).and_return(false)
        delete :destroy, params: {organization_id: organization.id,
          id: user_organization.id}
        expect(controller).to set_flash[:notice].to("Not found")
      end.to change(UserOrganization, :count).by 0
    end
  end
end
