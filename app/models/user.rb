class User < Sequel::Model
  plugin :validation_helpers
  plugin :secure_password, include_validations: false

  def validate
    super
    validates_presence [ :username ]
    validates_unique :username

    if password_confirmation.present?
      errors.add :password, "doesn't match confirmation" if password != password_confirmation
    end
  end
end
