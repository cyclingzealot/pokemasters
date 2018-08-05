class VolunteerTag < ApplicationRecord

    has_and_belongs_to_many :volunteer
    #Reading https://stackoverflow.com/questions/2780798/has-and-belongs-to-many-vs-has-many-through#2781049, it seems we need to use a has_many through:
end
