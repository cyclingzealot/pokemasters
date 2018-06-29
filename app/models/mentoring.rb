class Mentoring < ApplicationRecord
  belongs_to :mentor, class_name: "Volunteer"
  belongs_to :mentee, class_name: "Volunteer"
  belongs_to :mentoring_cycle
end
