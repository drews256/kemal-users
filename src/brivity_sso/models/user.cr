module BrivitySso
  module Models
    class User < Crecto::Model
      schema "users" do
        field :username, String # or use `PkeyValue` alias: `field :age, PkeyValue`
        field :encrypted_password, String
        field :uuid, String
        field :deleted_at, Time
        field :archived, Bool
      end
    end
  end
end
