module Shapes
  module Primitives
    class File < Shapes::Primitive

      attr_accessor :value, :file_dir, :tmp_file, :content_type, :width, :height

      def initialize(options = {})
        @file_dir = generate_temp_name
        create_tmp_file options[:value]
        remove_file if options[:remove_file] == '1'
        super
      end

      def node_attributes
        save_file if @tmp_file
        att = {'value' => value.to_s, 'content-type' => content_type}
        width or height and att.merge!({'width' => width, 'height' => height})
        att.merge(super)
      end

      def read_from_node
        @value = @xml_node['value']
        @width = @xml_node['width']
        @height = @xml_node['height']
        @content_type = content_type
        super
      end

      def update_attributes(params)
        create_tmp_file params[:value]
        remove_file if params[:remove_file]
        super
      end

      def destroy
        remove_file
        super
      end

      def relative_path
        ::File.join(Shapes::FILE_DIR, @value)[/\/public(\/.*)/, 1]
      end

      def absolute_path
        ::File.join(Shapes::FILE_DIR, @value)
      end

      def content_type
        type = (value.match(/\.(\w+)$/)[1] rescue 'octet-stream').downcase
        case type
        when %r'jpe?g' then 'image/jpeg'
        when %r'tiff?' then 'image/tiff'
        when %r'png', 'gif', 'bmp' then "image/#{type}"
        when 'txt' then 'text/plain'
        when %r'html?' then 'text/html'
        when 'csv', 'xml', 'css', 'plain', 'html' then "text/#{type}"
        when 'mp3' then 'audio/mpeg'
        when 'mpeg' then 'video/mpeg'
        when 'mov' then 'video/quicktime'
        when 'zip' then 'application/zip'
        when 'flv' then 'video/x-flv'
        when 'srt' then 'text/srt'
        when 'js' then 'text/javascript'
        when 'swf' then 'application/x-shockwave-flash'
        when 'doc' then 'application/msword'
        when 'pdf' then 'application/pdf'
        else "application/x-#{type}"
        end
      end

      protected
      def create_tmp_file(file_obj)
        return unless file_obj.is_a?(ActionController::UploadedTempfile) || file_obj.is_a?(ActionController::UploadedStringIO)
        tmp_file_path = ::File.join Shapes::FILE_TMP_DIR, @file_dir, sanitize_filename(file_obj.original_filename)
        ::FileUtils.mkpath ::File.dirname(tmp_file_path)
        if file_obj.respond_to?(:local_path) and file_obj.local_path and ::File.exists?(file_obj.local_path)
          ::FileUtils.copy_file file_obj.local_path, tmp_file_path
        elsif file_obj.respond_to?(:read)
          ::File.open(tmp_file_path, 'wb') { |f| f.write(file_obj.read) }
        else
          raise ArgumentError.new('Do not know how to handle #{file_obj.inspect}')
        end
        @tmp_file = tmp_file_path
      end

      def save_file
        ::FileUtils.mkpath Shapes::FILE_DIR
        remove_file
        FileUtils.mv ::File.dirname(@tmp_file), Shapes::FILE_DIR
        @value = ::File.join(@file_dir, ::File.basename(@tmp_file))
        @width, @height = dimensions
      end

      def dimensions
        content_type.match(/^image\//) ? read_dimensions : [nil,nil]
      end

      def read_dimensions
        image = ::Magick::Image.read(absolute_path).first
        @width, @height = image.columns.to_i, image.rows.to_i
      end

      def remove_file
        ::FileUtils.rm_rf ::File.join(Shapes::FILE_DIR, ::File.dirname(@value)) unless @value.blank?
        @value = nil
      end

      def generate_temp_name
        now = Time.now
        "#{now.to_i}.#{now.usec}.#{Process.pid}"
      end

      def sanitize_filename(filename)
        filename = ::File.basename(filename.gsub('\\', '/')) # work-around for IE
        filename.gsub!(/[^a-zA-Z0-9\.\-\+_]/,'_')
        filename = '_#{filename}' if filename =~ /^\.+$/
        filename = 'undefined' if filename.size == 0
        filename
      end
    end
  end
end

