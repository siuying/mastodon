# frozen_string_literal: true

class DomainBlock < ApplicationRecord
  enum severity: [:silence, :suspend]

  attr_accessor :retroactive

  validates :domain, presence: true, uniqueness: true

  has_many :accounts, foreign_key: :domain, primary_key: :domain
  delegate :count, to: :accounts, prefix: true

  def self.blocked?(domain)
    where(domain: domain, severity: :suspend).exists?
  end

  before_validation :normalize_domain

  private

  def normalize_domain
    self.domain = TagManager.instance.normalize_domain(domain)
  end
end
