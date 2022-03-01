# frozen_string_literal: true

class AddUserToAccount
  include Interactor

  before do
    unless context.user.is_a?(User)
      context.fail!(error: 'User should be of type User')
      return
    end

    unless context.account.is_a?(Account)
      context.fail!(error: 'Account should be of type Account')
      return
    end

    unless User.find_by_id(context.user.id)
      context.fail!(error: 'The specified user does not exist')
      return
    end
    unless Account.find_by_id(context.account.id)
      context.fail!(error: 'The specified account does not exist')
      return
    end
  end

  before do
    context.wallet = nil
  end

  def call
    context.wallet = Wallet.find_by(user_id: context.user.id, account_id: context.account.id)
    if context.wallet
      if context.wallet.active
        context.fail!(error: 'User account association already exists')
      else
        context.wallet.active = true
        context.wallet.save!
      end
      return
    end

    context.wallet = Wallet.create!(user_id: context.user.id, account_id: context.account.id)
  end
end