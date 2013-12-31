Authority.configure do |config|
  config.user_method = :current_user
  config.controller_action_map = {
    :index   => 'read',
    :show    => 'read',
    :new     => 'create',
    :create  => 'create',
    :edit    => 'update',
    :update  => 'update',
    :destroy => 'delete'
  }  
  config.abilities =  {
    :create => 'creatable',
    :read   => 'readable',
    :update => 'updatable',
    :delete => 'deletable',
    :comment => 'commentable' 
  }
  config.logger = Rails.logger
end
