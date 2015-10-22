class Lesson < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  has_many :word_lessons, dependent: :destroy
  # has_many :words, through: :word_lessons

  accepts_nested_attributes_for :word_lessons

  # before_create :create_word_lessons
  followed_ids = "SELECT followed_id FROM relationships 
                    WHERE follower_id = :user_id"
  scope :filter_lesson, ->(user_id){where "user_id IN (#{followed_ids}) 
                                OR user_id = :user_id", user_id: user_id}
  
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
  private
  def create_word_lessons
    word_ids = category.words.order("RANDOM()").limit(20).map(&:id)
    self.word_ids = word_ids
  end
end
