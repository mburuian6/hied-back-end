# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    user ||= User.new

    can %i[read], AcceptedBid, user_id: user.id
    can %i[read], RejectedBid, user_id: user.id
    can :all_notifications, Notification, user_id: user.id
    can :post, PostLink
    can %i[create update destroy], Bid, user_id: user.id
    can :open_post_bids, Bid
    can :accept_bid, Bid, post: { user_id: user.id }
    can %i[update destroy], Post, user_id: user.id
    can %i[read create], Post


    # can :upload_signed_loan_form, LoanApplication,
    #     status: :approved, business: { user_id: user.id }
  end
end
