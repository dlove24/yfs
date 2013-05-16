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
### Mounts all known sources.
###

require 'uri'

module Command 

  def Command.mount_all(config_file)

    # Parse the configuration file                                                              
    config = YAML.load(File.open(config_file))                                                  
                                                                                                
    # Find the named mount, extract the sink, source and options                                
    # and then do the mount                                                                     
    config.each{|mount_info|                                                                    
      source = URI(mount_info[1]["source"].to_s)
      sink = URI(mount_info[1]["sink"].to_s)

      source_options = mount_info[1]["source_options"]
      sink_options = mount_info[1]["sink_options"]
      
      Command.mount(source, source_options, sink, sink_options)                               
    }                                                                                           
  end

end
