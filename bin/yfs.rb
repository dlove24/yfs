#!/usr/bin/env ruby

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
### YFS Parser Core. Parses the command line options, and passes control
### to the relevant library.
###

# Add lib to load path
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '/../lib'))

# Make sure we can find the libraries installed by Ruby Gems
require "rubygems"

# Add core and standard library requires
require 'yaml'

# Command line parser
require 'trollop'

# Known sub-commands
require 'command/mount'
require 'command/mount_all'

###
### Main Loop
###

##
## Set-up the command line parser, and parse the global and sub-command
## options
##

# List of known sub-commands
SUB_COMMANDS = %w(new-disk mount)

# Set-up the global options, and tell Trollop to collect them from the
# command line

global_opts = Trollop::options do
  version "yfs 0.1.0 (c) 2013 David Love <david@homeunix.org.uk>"

  banner <<-EOS
    Uses the virtual disk facility of the FreeBSD operating systems to fake a
    virtal network filesystem.
  EOS

  stop_on SUB_COMMANDS

end

# Now work out what the sub-command was, parse both the sub-command
# and its own options

cmd = ARGV.shift

cmd_opts = case cmd
           when "mount"
             Trollop::options do
               opt :all, "Attempt to mount all known sources"
             end

           when "new-disk"
             Trollop::options do
               opt :size, "Specify the size of the new source"
             end

           else
             Trollop::die "Unknown subcommand"
           end

# Find and sanity check the configuration file, and then hand control over 
# to the relevant library

CONFIGURATION_FILE = "/etc/yfs.conf"

if !File.exists?(CONFIGURATION_FILE) then
  Trollop::die "Unable to read /etc/yfs.conf"
  exit
end

case cmd
when "mount"
  if cmd_opts[:all] then
    Command.mount_all(CONFIGURATION_FILE)
  else
    Command.mount(ARGV)
  end
end
