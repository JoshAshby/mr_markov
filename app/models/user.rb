class User < Sequel::Model
  include GlobalID::Identification

  plugin :validation_helpers
  plugin :secure_password, include_validations: false

  one_to_many :stacks

  def validate
    super
    validates_presence [ :username ]
    validates_unique :username

    if password_confirmation.present?
      errors.add :password, "doesn't match confirmation" if password != password_confirmation
    end
  end
end
