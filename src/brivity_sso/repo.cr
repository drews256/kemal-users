module BrivitySso
  module Repo
  	extend Crecto::Repo

  	config do |conf|
  		conf.adapter = Crecto::Adapters::Postgres
  		conf.database = "brivity_sso_development"
  		conf.hostname = "localhost"
  		conf.username = "andrewstuntz"
  	end
  end
end
