class HeroUserRepository
  include Datamappify::Repository

  for_entity HeroUser
  default_provider :ActiveRecord

  map_attribute :first_name, :to => 'HeroUser#first_name'

  group :provider => :Sequel do
    map_attribute :last_name, :to => 'HeroUserLastName#last_name'
    map_attribute :gender,    :to => 'HeroUserLastName#gender'
  end

  before_init    :action_before_init
  before_load    :action_before_load
  before_find    :action_before_find
  before_create  :action_before_create
  before_create  :action_before_create_2
  before_create  { |entity| performed(:before_create_block, entity); true }
  before_update  :action_before_update
  before_save    :action_before_save
  before_destroy :action_before_destroy

  after_init     :action_after_init
  after_load     :action_after_load
  after_find     :action_after_find
  after_create   :action_after_create
  after_update   :action_after_update
  after_save     :action_after_save
  after_destroy  :action_after_destroy

  private

  def action_before_init    (entity); performed(:before_init,     entity); true; end
  def action_before_load    (entity); performed(:before_load,     entity); true; end
  def action_before_find    (entity); performed(:before_find,     entity); true; end
  def action_before_create  (entity); performed(:before_create,   entity); true; end
  def action_before_create_2(entity); performed(:before_create_2, entity); true; end
  def action_before_update  (entity); performed(:before_update,   entity); true; end
  def action_before_save    (entity); performed(:before_save,     entity); true; end
  def action_before_destroy (entity); performed(:before_destroy,  entity); true; end

  def action_after_init     (entity); performed(:after_init,      entity); true; end
  def action_after_load     (entity); performed(:after_load,      entity); true; end
  def action_after_find     (entity); performed(:after_find,      entity); true; end
  def action_after_create   (entity); performed(:after_create,    entity); true; end
  def action_after_update   (entity); performed(:after_update,    entity); true; end
  def action_after_save     (entity); performed(:after_save,      entity); true; end
  def action_after_destroy  (entity); performed(:after_destroy,   entity); true; end

  def performed(*args)
    true
  end
end
