require "kemal"
require "pg"
require "crecto"
require "json"

require "./brivity_sso/*"
require "./brivity_sso/models/*"

module BrivitySso

  before_post "/users" do |env|
    env.set "new_user_uuid", "generate_uuid"
  end

  get "/users" do
    Repo.all(Models::User)
  end

  post "/users" do |env|
    user = Models::User.new
    user.uuid = env.get("new_user_uuid").as(String)
    next halt(env, 404, "no uuid for new user") if user.uuid.nil?
    user.username = env.params.json["username"].as(String)
    changeset = Repo.insert(user)
    changeset.changes.to_json
  end

  put "/users/:id" do |env|
    user = Repo.get(Models::User, env.params.url["id"].to_i)
    next halt(env, 401, "User with id #{env.params.url["id"].to_i} not found") if user.nil?
    user.as(Models::User)

    change_hash = {} of String => String
    change_hash.merge!({"username" => env.params.json["username"].as(String)}) unless env.params.json["username"]?.nil?
    change_hash.merge!({"uuid" => env.params.json["uuid"].as(String)}) unless env.params.json["uuid"]?.nil?
    change_hash.merge!({"archived" => env.params.json["archived"].as(String)}) unless env.params.json["archived"]?.nil?

    user.update_from_hash(change_hash)
    changeset = Repo.update(user)
    changeset.changes.to_json
  end

  delete "/users/:id" do |env|
    id = env.params.url["id"].to_i
    user = Repo.get(Models::User, id)
    next halt(env, 401, "user with id #{id} not found") if user.nil?
    user.as(Models::User)
    user.archived = true
    user.deleted_at = Time.now
    changeset = Repo.update(user)
    changeset.changes.to_json
  end

  post "/session" do |env|
  end
end

Kemal.config.port = 9091
Kemal.run
