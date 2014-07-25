module MiniTwitter
  module Marshable
    def marshal! file_path = marshal_file_name()
      File.open( file_path, 'w' ){ |f| f.puts( Marshal.dump( self ) ) }
      file_path
    end

    def unmarshal_latest!
      Marshal.load( File.read( lastest_marshal_version)  )
    end

    def unmarshal!( file_path )
      Marshal.load( File.read( file_path )  )
    end

    def marshal_folder
      File.join( Dir.pwd, 'storage/' )
    end

    def marshal_file_name
      File.join(marshal_folder,  self.class.name + Time.now.utc.iso8601 + '.txt')
    end

    def lastest_marshal_version
       File.join(marshal_folder, Dir.new( marshal_folder ).to_a.last )
    end
  end
end
