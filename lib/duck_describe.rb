module DuckDescribe

  IDENT_MATCH = /^[a-zA-Z0-9_-]+$/
  IDENT_MATCH_WARNING = 'Ident must be lowercase and must not contain special characters or spaces.'
  IDENT_UNIQUENESS_WARNING = 'Ident must be unique.'

  # TODO: Should be configurable.
  FILE_DIR = File.join Rails.public_path, 'duck_describe', 'files'
  FILE_TMP_DIR = File.join RAILS_ROOT, 'tmp', 'duck_describe'

  SELECT_OPTION_STRUCT = Struct.new(:name, :id)
  SELECT_OPTION_GROUP_STRUCT = Struct.new(:name, :options)

  CACHE_PATH = File.join Rails.public_path, 'duck_describe', 'xml'

  def self.extend_model(base) #:nodoc:
    if options = DuckDescribe.config[base.name]
      base.extend ::ActiveRecord::Acts::Duck::ClassMethods
      base.acts_as_duck options
    end
  end
end
