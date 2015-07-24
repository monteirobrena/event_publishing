class GroupEvent < ActiveRecord::Base
  validates :name, :description, :location, :duration, :start_date, :end_date, presence: true
  validates :start_date, date: { after_or_equal_to: Proc.new { Date.today } }
  validates :start_date, date: { before_or_equal_to: :end_date }
  validates :end_date, date: { after_or_equal_to: :start_date }

  after_validation { self.duration    ||= set_duration   if duration.nil?    && start_date.present?  && end_date.present? }
  after_validation { self.start_date  ||= set_start_date if start_date.nil?  && end_date.present?    && duration.present? }
  after_validation { self.end_date    ||= set_end_date   if end_date.nil?    && start_date.present?  && duration.present? }

  before_save :formatting_description

  scope :published, -> (published) { where(published: published) }
  scope :archived,  -> (archived)  { where(archived:  archived) }

  def set_duration
    (end_date - start_date).to_i
  end

  def set_start_date
    self.start_date = end_date.prev_day(duration)
  end

  def set_end_date
    self.end_date = start_date.next_day(duration)
  end

  def archive    
    self.update_attribute(:archived, true)
  end 

  def formatting_description
    self.description = Sanitize.fragment(description, elements: ['b', 'i', 'p'])
  end
end