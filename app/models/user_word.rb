class UserWord < ActiveRecord::Base
  belongs_to :user
  belongs_to :word
  validates :user_id, presence: true
  validates :word_id, presence: true
  class << self
    def to_csv(options = {})
      CSV.generate(options) do |csv|
        csv << column_names
        all.each do |product|
          csv << product.attributes.values_at(*column_names)
        end
      end
    end
  end
end
