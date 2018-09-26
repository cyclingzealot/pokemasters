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


  def self.makeListFromFiles(volunteersList:, mentorEmails: )
    volunteersList.each {|filePath|
        puts "Loading from #{filePath}"
        Volunteer::ToastmastersVolunteer::update_from_csv(filePath)
    }

    raise "No volunteer loaded" if Volunteer.count == 0

    CSV.foreach(mentorEmails) do |row|
        email = row[0]
        v = Volunteer.find_by_email(email)

        if v.nil?
            $stderr.puts "No volunteer found for #{email}"
            byebug if Rails.env.development?
            next
        end

        v.mentor!
    end


    [1,2].each{|i|
        Volunteer.all.each{|mentee|
            mentor = Volunteer.next_mentor
            Mentoring.assign(mentor:mentor, mentee:mentee)
        }
    }

    mc = MentoringCycle.current

    Mentoring.select(:mentor_id).where(mentoring_cycle: mc).distinct.each{|mentoring_mentor|
        mentor = mentoring_mentor.mentor
        puts "#{mentor.to_s} has:\n"

        Mentoring.where(mentor: mentor, mentoring_cycle: mc).each{|mentoring|
            puts mentoring.mentee.to_s
        }

        puts "\n"
    }
  end

  def to_s
    "#{mentee.to_s} is assigned to #{mentor.to_s}"
  end
end
