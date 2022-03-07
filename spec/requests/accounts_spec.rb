# frozen_string_literal: true

require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe '/accounts', type: :request do
  # This should return the minimal set of attributes required to create a valid
  # Account. As you add validations to Account, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    { name: 'Test123' }
  end

  let(:invalid_attributes) do
    { name: 'test123' }
  end

  # This should return the minimal set of values that should be in the headers
  # in order to pass any filters (e.g. authentication) defined in
  # AccountsController, or in your router and rack
  # middleware. Be sure to keep this updated too.
  let(:valid_headers) do
    {}
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      Account.create! valid_attributes
      get accounts_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      account = Account.create! valid_attributes
      get account_url(account), as: :json
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Account' do
        expect do
          post accounts_url,
               params: { account: valid_attributes }, headers: valid_headers, as: :json
        end.to change(Account, :count).by(1)
      end

      it 'renders a JSON response with the new account' do
        post accounts_url,
             params: { account: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Account' do
        expect do
          post accounts_url,
               params: { account: invalid_attributes }, as: :json
        end.to change(Account, :count).by(0)
      end

      it 'renders a JSON response with errors for the new account' do
        post accounts_url,
             params: { account: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        { name: 'Test321' }
      end

      it 'updates the requested account' do
        account = Account.create! valid_attributes
        patch account_url(account),
              params: { account: new_attributes }, headers: valid_headers, as: :json
        account.reload
        expect(account.name).to eq('Test321')
      end

      it 'renders a JSON response with the account' do
        account = Account.create! valid_attributes
        patch account_url(account),
              params: { account: new_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      it 'renders a JSON response with errors for the account' do
        account = Account.create! valid_attributes
        patch account_url(account),
              params: { account: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested account' do
      account = Account.create! valid_attributes
      expect do
        delete account_url(account), headers: valid_headers, as: :json
      end.to change(Account.all, :count).by(-1)
    end
  end
end
