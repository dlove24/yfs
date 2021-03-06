### Copyright (c) 2013 David Love <david@homeunix.org.uk>
###
### Permission to use, copy, modify, and/or distribute this software for
### any purpose with or without fee is hereby granted, provided that the
### above copyright notice and this permission notice appear in all copies.
###
### THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
### WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
### MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
### ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
### WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
### ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
### OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
###

### @author David Love
###
### Mounts a defined source, by name or index
###

require 'uri'

module Command 

  # Mount a source by name
  def Command.mount_by_name(config_file, mount_name)
    # Parse the configuration file
    config = YAML.load(File.open(config_file))
    
    # Find the named mount, extract the sink, source and options
    # and then do the mount
    config.each{|mount_info|
      if mount_info == mount_name then
        source = URI(mount_info[1]["source"].to_s)                                                
        sink = URI(mount_info[1]["sink"].to_s)                                                    
                                                                                                
        source_options = mount_info[1]["source_options"].to_s                                     
        sink_options = mount_info[1]["sink_options"].to_s                                         
                                                                                                
        Command.mount(source, source_options, sink, sink_options) 
      end
    }
  end
  
  # Mount a source by index
  def Command.mount(source, source_options, sink, sink_options)
    
    # Do the actual mount according to the specified scheme
    case sink.scheme
    when "mdimage"
      # Only do the mount if the source is not yet mounted
      unless File.exists?(sink.path) then
        %x[mdconfig -a -t vnode -f #{source.path} -u #{sink.path[-1]}]
      end

    when "file"
      # Exactly how we mount the file-system depends on the source
      case source.scheme
      when "ggate"
        index = source.path[-1]
        puts index

        if %x[ggatec create -u #{index} #{source.host} #{source.path}] then
          puts "Error: The mount via ggatec failed. Tried 'gatec create -u #{index} #{source.host} #{source.path}'"
          Trollop::die
        end

        %x[mount_ufs /dev/ggate#{index} #{sink.path}]

      end
    end
  end

end
