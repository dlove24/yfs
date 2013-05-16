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

module Command 

  def Command.mount_all(config_file)

    # Parse the configuration file
    config = YAML.load(File.open(config_file))

    ggated_list = Array.new
    
    config.each{|mount_info|

      puts mount_info
      
      # Extract, and mount the list of sources 
      source = mount_info[1]["source"]
      sink = mount_info[1]["sink"]
      Command.mount(mount_info[1]["source"],
                    mount_info[1]["sink"])

      # Next make the mount available through the stated
      # export mechanisms (if supplied)
      
      unless mount_info[1]["export"].nil? or mount_info[1]["export"].empty? then

        mount_info[1]["export"].each{|export|

          case export[0]
          when "ggated"
            ggated_list << "#{export[1]["networks"]} RW /dev/md#{mount_info[1]["md_index"]}a"
          end
        }

      end

    }
    
    # Write the mount files
    File.open("/etc/gg.exports", 'w') {|file| 
      ggated_list.each{|line|
        file.puts line
      } 
    }

  end

end
