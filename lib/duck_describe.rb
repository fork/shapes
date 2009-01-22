module DuckDescribe

  require 'active_record'
  require 'duck_describe/container'
  require 'duck_describe/resource'
  require 'duck_describe/primitive'

  IDENT_MATCH = /^[a-zA-Z0-9_-]+$/
  IDENT_MATCH_WARNING = 'Ident must be lowercase and must not contain special characters or spaces.'
  
  FILE_DIR = File.join Rails.public_path, 'duck_describe', 'files'
  FILE_TMP_DIR = File.join RAILS_ROOT, 'tmp', 'duck_describe'
  
  OPT_STRUCT = Struct.new(:name, :id)
  OPT_GROUP_STRUCT = Struct.new(:name, :options)
  
  CACHE_PATH = File.join Rails.public_path, 'duck_describe', 'xml'

  def self.extend_model(base)
    return unless DuckDescribe.config.keys.include?(base.name)
    base.extend ::ActiveRecord::Acts::Duck::ClassMethods
    base.acts_as_duck
  end
end
