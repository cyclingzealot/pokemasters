class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true


  def self.random(amount = nil)
    stuff = self.where('1=1').order("RANDOM()")

    return stuff.take if amount.nil?
    return stuff.limit(amount) if amount != :all
    return stuff
  end


    def load_from_csv(model = self, filepath)
      CSV.open filepath, 'rb', headers: :first_row, encoding: 'UTF-8' do |csv|
        csv.each do |row|
          model.create! row.to_hash
        end
      end
    end

end
