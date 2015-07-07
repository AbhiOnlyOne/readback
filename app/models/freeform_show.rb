class FreeformShow < ActiveRecord::Base
  include Show

  belongs_to :semester
  belongs_to :dj
  has_many :episodes, as: :show

  validates :name, :dj, :weekday, presence: true
  validates_time :beginning
  validates_time :ending, after: :beginning

  def default_status
    :normal
  end

  def alternate_host_name
    "guest DJ"
  end
end
