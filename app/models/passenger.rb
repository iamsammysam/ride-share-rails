class Passenger < ApplicationRecord
  has_many :trips, dependent: :nullify
  
  validates :name, presence: true
  validates :phone_num, presence: true
  
  def total_amount_charged  
    sum = 0  
    self.trips.each do |trip|
      if trip.cost.nil?
        sum += 0
        return
      else
        sum += trip.cost
      end
      return sum/100.0
    end  
  end 
end 

