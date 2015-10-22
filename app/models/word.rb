class Word < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :user_words, dependent: :destroy
  accepts_nested_attributes_for :answers, allow_destroy: true
  validates :content_jp, presence: true, length: { maximum: 50 },
                        uniqueness: {case_sensitive: false}
  belongs_to :category
  filterrific available_filters: [:with_category_id]
  scope :with_category_id, lambda { |category_ids|
    where(category_id: [*category_ids])
  }

  scope :learn_category, lambda { |user, category|
      where("id IN (SELECT word_id FROM user_words 
        WHERE user_id = #{user.id.to_s}) 
        AND (category_id = #{category.id.to_s})")
  }

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
