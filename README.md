mongoid_sample_with_embedded_causes_problem
===========================================

A sample rails app showing a problem in mongoid with embedded documents


Versions:  
-----
 - ruby 1.9.3
 - rails  3.2.13  
 - mongodb  2.4.8
 - mongoid 3.1.6  

 
Create rails app with rspec
---
 
1. Create new rails app defaulting to rspec for tests
	
		rails new mongoid_example -T --skip-active-record
    The -T option tells rails not to include Test::Unit
    --skip-active-record skip ActiveRecord since we plan to use mongoid 
1.  edit 'Gemfile'
	
		gem ‘rspec-rails’
1.  	bundle install
1.  	rails g rspec:install


Setup mongoid
---

1.  edit 'Gemfile'
			
		gem 'mongoid', '>= 3.1.6'
2. 		bundle install
3. 		rails g mongoid:config


Update RSpec to cleanup DB
---

1. edit 'Gemfile'

		gem 'database_cleaner'
1. 		bundle install 
1. edit 'spec/spec_helper.rb'
	1.	Comment out 'config.use_transactional_fixtures' and 'config.fixture_path'
		
			#config.use_transactional_fixtures = true 
			#config.fixture_path = "#{::Rails.root}/spec/fixtures"
	1.  Add DatabaseCleaner calls
	
	 		config.before(:suite) do
    			DatabaseCleaner[:mongoid].strategy = :truncation
  			end

  			config.before(:each) do
    			DatabaseCleaner[:mongoid].start
  			end

  			config.after(:each) do
    			DatabaseCleaner[:mongoid].clean
  			end




