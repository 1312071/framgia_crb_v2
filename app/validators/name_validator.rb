class NameValidator < ActiveModel::Validator
  def validate record
    # name may only contain alphanumeric characters or single hyphens, and cannot begin or end with a hyphen
    if !(record.name =~ /^(?!-)(?!.*--)[A-Za-z0-9-]+(?<!-)$/i)
      record.errors[:name] << I18n.t("validator.name.not_valid_format")
    elsif record.name.length > 39
      record.errors[:name] << I18n.t("validator.name.too_length")
    elsif record.new_record? && Person.names.include?(record.name)
      record.errors[:name] << I18n.t("validator.name.is_taken")
    end
  end
end
