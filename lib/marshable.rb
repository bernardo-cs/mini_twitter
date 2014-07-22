module MiniTwitter
  module Marshable
    def marshal! file_path = report_file_name()
      File.open( file_path, 'w' ){ |f| f.puts( Marshal.dump( self ) ) }
      file_path
    end

    def unmarshal!( file_path )
      Marshal.load( File.read( file_path )  )
    end

    def report_folder
      File.join( Dir.pwd, 'storage/' )
    end

    def report_file_name
      File.join(report_folder,  self.class.name + Time.now.utc.iso8601 + '.txt')
    end
  end
end
