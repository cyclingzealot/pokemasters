require 'test_helper'

class VolunteerTest < ActiveSupport::TestCase
   test "the truth" do
     assert true
   end

   test "it should load and run detect seperator" do
        assert_equal ',', ::Volunteer::detectSeperator('test/files/Club-Roster20180402.csv')
    end

   test "it should import a csv list of two csv members, sync them together" do
        filePaths = {
            :ti             => "test/files/Club-Roster20180402.csv",
            :freeToastHost  => "test/files/membership-export.csv"
        }
        Volunteer::ToastmastersVolunteer::update_from_csv(filePaths[:ti])
        Volunteer::ToastmastersVolunteer::update_from_csv(filePaths[:freeToastHost])

        member    = Volunteer.find_by_email('gkidstone2@spotify.com')
        guest     = Volunteer.find_by_email('vwoodson34@freewebs.com')
        #executive = Volunteer.find_by_email('bswornc@blogger.com')
        #alumni    = Volunteer.find_by_email('tkopech@constantcontact.com')

        assert_equal 121, Volunteer.count

        assert member.isMember?
        assert guest.isGuest?

   end


   test "it should assign a role to a volunteer for a specified meeting date" do
        member = Volunteer.find_by_email('gkidstone2@spotify.com')

        date = "2018/04/04"

        meeting = Meeting.findByDate(date)

        role = Role.findByShortName("Chair")

        meeting.assign(member, role)

        assignments = meeting.assignments

        assert_equal "Chair", assignments[member].name
   end

   test "it should error nicely" do
        assert_raises (Exception) {Volunteer.import("test/files/nonExistingFile.csv")}
   end
end
