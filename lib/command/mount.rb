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
  def Command.mount(config_file, mount_name)
    # Parse the configuration file
    config = YAML.load(File.open(config_file))
    
    # Extract, and mount the list of sources
    config.each{|mount_info|
      Command.mount_index(mount_info[1][:md_index],
                          mount_info[1][:source])
    }
  end
  
  # Mount a source by index
  def Command.mount_index(mount_index, mount_source)
    uri = URI(mount_source.to_s)

    # Only do the mount if the source is not yet mounted
    unless File.exists?("/dev/md#{mount_index}")
      # Do the actual mount according to the specified scheme
      case uri.scheme
      when "mdimage"
        %x[mdconfig -a -t vnode -f #{uri.path} -u #{mount_index}]
      end
    end
  end

end
