# frozen_string_literal: true

class EmailValidator < ActiveModel::EachValidator
  FORBIDDEN_SEQUENCE_PATTERN = /\.\./.freeze

  def validate_each(record, attribute, value)
    return if value =~ URI::MailTo::EMAIL_REGEXP && !(value =~ FORBIDDEN_SEQUENCE_PATTERN)

    record.errors.add(attribute)
  end
end
