require 'test_helper'

class VolunteerTest < ActiveSupport::TestCase
   test "the truth" do
     assert true
   end

   test "it should import a csv list of two csv members, sync them together" do
        Volunteer.update_from_csv("test/files/Club-Roster20180402.csv")
        Volunteer.update_from_csv("test/files/membership-export.csv")

        member    = Volunteer.find_by_email('gkidstone2@spotify.com')
        guest     = Volunteer.find_by_email('vwoodson34@freewebs.com')
        #executive = Volunteer.find_by_email('bswornc@blogger.com')
        #alumni    = Volunteer.find_by_email('tkopech@constantcontact.com')

        assert member.isMember?
        assert guest.isGuest?

   end

   test "it should error nicely" do
        Volunteer.import("test/files/nonExistingFile.csv")
   end
end
