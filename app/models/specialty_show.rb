class SpecialtyShow < ActiveRecord::Base
  include Show

  belongs_to :dj, class_name: "Dj", foreign_key: "coordinator_id"
  has_and_belongs_to_many :djs, dependent: :delete_all

  alias_attribute :coordinator, :dj

  def rotating_hosts
    ([coordinator] + djs.sort_by { |dj| dj.try(&:name) }).uniq
  end

  def default_status
    :unassigned
  end

  def dj_id_changed?
    coordinator_id_changed?
  end

  def deal
    hosts = rotating_hosts
    # modify only unassigned or unconfirmed episodes
    unconfirmed_episodes = episodes.reject(&:past?).select do |x|
      x.unassigned? || x.normal?
    end
    unconfirmed_episodes.each_with_index do |ep, inx|
      ep.dj = hosts[inx % hosts.count]
      ep.status = :normal
    end

    transaction do 
      unconfirmed_episodes.each(&:save!)
    end
  end

  def with
    if rotating_hosts.count == 1
      "with #{dj}"
    else
      "#{rotating_hosts.count} #{"DJ".pluralize(rotating_hosts.count)} in rotation"
    end
  end

end
