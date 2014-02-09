require 'spec_helper'
  
describe Topic do 
  context "when saving nested attributes" do

    it "should be possible to modify an embedded document using 'update_attributes' on the top level parent." do
      question_text = "What is 1 + 1?"
      topic = create_topic("Math", question_text, "18")
      topic.questions[0].question.should eq(question_text) 
      topic.questions[0].answers[0].answer.should eq("18")

      # Now get a Hash of topic attributes, where we modify the answer
      # Ensure this has been updated as we expect in MongoDB
      topic_attrs = get_topic_attributes_1(topic, "99")
      topic.update_attributes(topic_attrs)

      t = Topic.find(topic.id)
      t.questions[0].question.should eq(question_text)
      t.questions[0].answers[0].answer.should eq("99")
    end

    it "should be possible to add an new embedded document to an existing list" do 
      question_text = "What is 1 + 1?"
      topic = create_topic("Math", question_text, "18")
      topic.questions[0].question.should eq(question_text) 
      topic.questions[0].answers[0].answer.should eq("18")

      # Now we want to add a new answer, leaving the existing answer alone.
      # We will have 2 answers to this single question.
      topic_attrs = get_topic_attributes_2(topic, "99")
      topic.update_attributes(topic_attrs)

      t = Topic.find(topic.id)
      t.questions[0].question.should eq(question_text)
      answers = t.questions[0].answers.map { |a| a.answer }
      answers.should =~ ["99", "18"]
    end

    it "should be possible to have a list of embeded documents and be able to modify one while adding a new one." do 
      question_text = "What is 1 + 1?"
      topic = create_topic("Math", question_text, "18")
      topic.questions[0].question.should eq(question_text) 
      topic.questions[0].answers[0].answer.should eq("18")

      # Now we want to modify the existing answer and add a new answer
      # We will have 2 answers to this single question.
      topic_attrs = get_topic_attributes_3(topic, "4000", "5000")
      topic.update_attributes(topic_attrs)

      t = Topic.find(topic.id)
      t.questions[0].question.should eq(question_text)
      answers = t.questions[0].answers.map { |a| a.answer }
      answers.should =~ ["4000", "5000"]
    end

    def create_topic(topic_name, question, answer)
      topic = Topic.new
      topic.name = topic_name
      q1 = Question.new
      q1.question = question
      a1 = Answer.new
      a1.answer = answer
      q1.answers << a1
      topic.questions << q1
      topic.save!
      topic
    end

    # The get_topic_attributes_???  methods are intended to simulate the hash of attributes 
    # we'd receive from processing a form.


    def get_topic_attributes_1(existing_topic, updated_answer_value)
      # Update the existing answer to a new value
      q1 = existing_topic.questions[0]
      a1 = q1.answers[0]
      attrs = {
        "_id"=> existing_topic.id, 
        "name"=> existing_topic.name, 
        "_destroy"=> "false",
        "updated_at"=> existing_topic.updated_at, 
        "created_at"=> existing_topic.created_at, 
        "questions" => 
        {
          "0" => 
          {
            "_id"=> q1.id, 
            "question"=> q1.question,
            "_destroy"=> "false", 
            "answers"=> 
            {
              "0" => 
              {
                "_id"=> a1.id, 
                "answer"=> updated_answer_value,
                "_destroy"=> "false",
              },
            }
          }
        }
      }
    end

    def get_topic_attributes_2(existing_topic, new_answer_value)
      # Add a new answer while leaving the existing answers alone
      q1 = existing_topic.questions[0]
      a1 = q1.answers[0]
      attrs = {
        "_id"=> existing_topic.id, 
        "name"=> existing_topic.name, 
        "_destroy"=> "false",
        "updated_at"=> existing_topic.updated_at, 
        "created_at"=> existing_topic.created_at, 
        "questions" => 
        {
          "0" => 
          {
            "_id"=> q1.id, 
            "question"=> q1.question,
            "_destroy"=> "false", 
            "answers"=> 
            {
              "0" => 
              {
                "_id"=> a1.id, 
                "answer"=> a1.answer,
                "_destroy"=> "false",
              },
              "100" => 
              {
                "answer" => new_answer_value,
                "_destroy"=> "false",
              }
            }
          }
        }
      }
    end

    def get_topic_attributes_3(existing_topic, updated_answer_value, new_answer_value)
      # Add a new answer while also modifying the existing answer
      q1 = existing_topic.questions[0]
      a1 = q1.answers[0]
      attrs = {
        "_id"=> existing_topic.id, 
        "name"=> existing_topic.name, 
        "_destroy"=> "false",
        "updated_at"=> existing_topic.updated_at, 
        "created_at"=> existing_topic.created_at, 
        "questions" => 
        {
          "0" => 
          {
            "_id"=> q1.id, 
            "question"=> q1.question,
            "_destroy"=> "false", 
            "answers"=> 
            {
              "0" => 
              {
                "_id"=> a1.id, 
                "answer"=> updated_answer_value,
                "_destroy"=> "false",
              },
              "100" => 
              {
                "answer" => new_answer_value,
                "_destroy"=> "false",
              }
            }
          }
        }
      }
    end
  end
end
