class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.role == 'admin'
      can :manage, User
      can :manage, :all
    elsif user.role == 'lesen'
      can :read, Post
    elsif user.role == 'author'
      can [:read, :create, :update], Post
    else
      can :read, Post
    end
  end
end
