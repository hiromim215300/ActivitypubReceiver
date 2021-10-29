class Note < ApplicationRecord
  include Routeable

  validates :content, presence: true
  belongs_to :actor

  has_many :activities, as: :entity, dependent: :destroy

  after_create :create_activity

  def federated_url
    attributes['federated_url'].presence || federation_actor_note_url(actor_id: actor_id, id: id)
  end

  private
  
  def create_activity
    Activity.create! actor: actor, action: 'Create', entity: self
  end   
end