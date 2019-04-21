require 'test_helper'

class VolunteerTest < ActiveSupport::TestCase
   test "the truth" do
     assert true
   end

   test "it should load and run detect seperator" do
        assert_equal ',', ::Volunteer::detectSeperator('test/files/Club-Roster20180402.csv')
    end

   def self.populateDb()
        filePaths = {
            :ti             => "test/files/Club-Roster20180402.csv",
            :freeToastHost  => "test/files/membership-export.csv"
        }
        Volunteer::ToastmastersVolunteer::update_from_csv(filePaths[:ti])
        Volunteer::ToastmastersVolunteer::update_from_csv(filePaths[:freeToastHost])
   end


   test "it loads andrew graham properly" do
        Volunteer::ToastmastersVolunteer::update_from_csv('test/files/membership-export-andrewG.csv')

        assert Volunteer.count > 0, "no volunteers loaded"

        assert_equal 1, Volunteer.where(email: 'andrewgrass@gmail.com').count, "No andrew grass found"
   end


   test "It will report the level of a volunteer with no assignmetn as 0" do
        Volunteer::ToastmastersVolunteer::update_from_csv('test/files/membership-export-andrewG.csv')

        assert Volunteer.count > 0, "no volunteers loaded"

        v = Volunteer.where(email: 'andrewgrass@gmail.com')
        v = v.take

        assert_equal 0, v.level(org: Organization.first), "Level of volunteer #{v.to_s} is not 0"
   end

   test "It will register a volunteer with no assignment as level 2 and report as such" do
        Volunteer::ToastmastersVolunteer::update_from_csv('test/files/membership-export-andrewG.csv')

        v = Volunteer.where(email: 'andrewgrass@gmail.com')
        assert_equal 1, v.count, "No andrew grass found"

        v = v.take

        o = Organization.first
        expectedLevel = 2
        v.register(organization: o, level: expectedLevel)

        assert_equal 1, Registration.where(organization: o, volunteer: v).count , "Did not find 1 registration for volunteer #{v.to_s}, organization #{o.to_s}"

        assert_equal 2, v.level(org: o), "Level of volunteer #{v.to_s} is not #{expectedLevel}"
   end

   test "it can add a mentor tag to a volunteer" do
        self.class.populateDb
        v = Volunteer.order("RANDOM()").first
        v.mentor!
        assert v.mentor?
   end

   test "it should import a csv list of two csv members, sync them together" do

        self.class.populateDb

        member    = Volunteer.find_by_email('gkidstone2@spotify.com')
        guest     = Volunteer.find_by_email('vwoodson34@freewebs.com')
        #executive = Volunteer.find_by_email('bswornc@blogger.com')
        #alumni    = Volunteer.find_by_email('tkopech@constantcontact.com')

        assert_equal 122, Volunteer.count

        assert member.isMember?
        assert guest.isGuest?

   end


   test "it should assign a role to a volunteer for a specified meeting date" do
        Volunteer::ToastmastersVolunteer::update_from_csv("test/files/membership-export.csv")
        member = Volunteer.find_by_email('gkidstone2@spotify.com')

        date = "2018/06/06"

        meeting = Meeting.find_by_date(date)

        role = Role.find_by_short_name("chair")

        assert_not_nil role
        assert_not_nil meeting
        assert_not_nil member


        meeting.assign(member, role)

        skip("Not focussing on role assignment yet")

        assignments = meeting.assignments

        assert_equal "chair", assignments[member].name
   end

   test "it should error nicely" do
        assert_raises (Exception) {Volunteer.import("test/files/nonExistingFile.csv")}
   end


   test "it should suggest timer or role of lowest level for someone who has never done anything" do
        #Volunteer.find_by_sql(

        #r = Volunteer.suggestRoles()

        #r.first(
   end

end
