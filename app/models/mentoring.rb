class Mentoring < ApplicationRecord
  belongs_to :mentor, class_name: "Volunteer"
  belongs_to :mentee, class_name: "Volunteer"
  belongs_to :mentoring_cycle


  def self.assign(mentor:, mentee:)
    mc = MentoringCycle.current_or_create
    m = Mentoring.new(mentor: mentor, mentee: mentee, mentoring_cycle: mc)
    m.save!
    return m
  end
end
