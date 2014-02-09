class Topic
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String

  embeds_many :questions
  accepts_nested_attributes_for :questions, :allow_destroy => true
end

class Question
  include Mongoid::Document
  include Mongoid::Timestamps
  field :question, type: String

  embedded_in :topic, :inverse_of => :questions
  embeds_many :answers
  accepts_nested_attributes_for :answers, :allow_destroy => true
end

class Answer
  include Mongoid::Document
  include Mongoid::Timestamps
  field :answer, type: String

  embedded_in :quesion, :inverse_of => :answers
end
