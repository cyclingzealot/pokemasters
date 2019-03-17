require 'test_helper'

class RequestTest < ActiveSupport::TestCase
  test "the truth" do
     assert true
  end

  def self.populateDb()
      Role::update_from_csv('test/files/roles.csv')
  end

  test "It can determine the next volunteer for a role (more volunteers then roles)" do
=begin
    What is a good scenario here?  How to mituclouisy test 'oh you got the right role'?  Well, there are two possible state:
    1. We have an equal amount of roles and volunteers, or fewer volunteers then roles
    2. We have more volunteers then roles
=end

    self.class.populateDb()

    m = Meeting.new("2019/03/13 18:55", "Robertson 607")

    assignments = {
        "ge": "lskillman0@eepurl.com",
        "chair": "dcaddan6@washington.edu",
        "word": "bsoppethb@qq.com",
        "quote": "bdjuricicf@newyorker.com",
        "toast": "mjaheri@netlog.com",
        "joke": "agallemoret@npr.org",
        "timer": "rreeksz@sogou.com",
        "gram": "dferencowicz14@indiegogo.com",
        "speaker": "mpolfer11@house.gov",
        "tt": "jattenburrow19@odnoklassniki.ru",
        "eval": "dpray1h@myspace.com",
    }


    assert_operator Role.count, :>, 10

    # It will offer the role of timer to a new volunteer
    v1s = Role.find_by_sname('timer').suggestVolunteers

    # It will offer the role of chair to someone who has yet to do the job and who is a member
    v2s = Role.find_by_sname('chair').suggestVolunteers



    # All volunteers for chair should be
    v2s.each { assert_true v2s.is_member?, "#{v2s.to_s} is not a member"}


  end




end
