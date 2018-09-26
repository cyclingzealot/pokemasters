namespace :mentoring do
    desc "Print out a list of mentorships"
    task makeList: :environment do
        Mentoring.delete_all
        Mentoring.makeListFromFiles(volunteersList: ["/home/jlam/Dropbox/toastmasters/membershipLists/Club-Roster20180926.csv", "/home/jlam/Dropbox/toastmasters/membershipLists/freeToastHost-membership-export.csv"], mentorEmails: "/home/jlam/Dropbox/toastmasters/membershipLists/mentors.csv")
    end
end
