#--
# Copyright (c) 2007 François VAUX
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

module RZen#:nodoc:

  # This is the default class, parent of all RZen dialogs. It includes
  # the common methods and attributes of RZen dialogs objects.
  # You SHOULD NOT use this class. Anyways, it will crash.
  class Dialog
    attr_accessor :title, :width, :height, :window_icon
    
    def run
      %x(#{commandline}).chomp
    end

    alias_method :show,     :run
    alias_method :get,      :run
    alias_method :orig_run, :run
    private :orig_run

    def initialize(opts={})
      opts.each do |k,v|
        instance_variable_set("@#{k}", v)
      end
    end
    
    class << self
      def get(a={})
        new(a).run
      end
      alias_method :show, :get
    end
    
    private
    
    def build_options
      options = ''
      instance_variables.each do |opt|
        value = instance_variable_get(opt)
        if value.is_a?(TrueClass)
          options += "--#{opt.gsub('_', '-')[1..-1]} "
        else
          options += "--#{opt.gsub('_', '-')[1..-1]} #{value.inspect} "
        end
      end
      options
    end

    def dialog_type
      self.class.to_s.gsub(/^rzen::/i,'').gsub(/([A-Z])/, '-\1').downcase
    end

    def commandline
      "zenity --#{dialog_type} #{build_options}"
    end
    
  end

  class Entry < Dialog
    attr_accessor :text, :entry_text, :hide_text
  end
  
  class Calendar < Dialog
    attr_accessor :text, :day, :month, :year, :date_format
  end
  
  class Message < Dialog
    attr_accessor :text, :no_wrap
    def run; super; nil end
  end
  
  class Error   < Message; end
  class Info    < Message; end
  class Warning < Message; end

  class Question < Message
    def run; system(commandline) end
  end
  
  class FileSelection < Dialog
    attr_accessor :filename, :multiple, :directory, :save, :separator, 
                  :confirm_overwrite
    
    def run
      @separator ||= '|'
      if @multiple then orig_run.split(@separator) else super end
    end
  end
  
  class Notification < Dialog
    attr_accessor :text, :listen
  end
  
  class List < Dialog
    attr_accessor :columns, :editable, :separator, :print_column, 
                  :hide_column, :items
    
    def build_options
      options = ''
      instance_variables.each do |opt|
        value = instance_variable_get opt
        next if opt == "@items"
        if value.is_a?(TrueClass)
          options += "--#{opt.gsub('_', '-')[1..-1]} "
        elsif opt == "@columns"
          value.each do |val|
            options += "--column #{val.inspect} "
          end
        else
          options += "--#{opt.gsub('_', '-')[1..-1]} #{value.inspect} "
        end
      end 
      unless @items.nil?
        options += @items.flatten.collect{|i| i.inspect}.join(' ')
      end
      options
    end
  end
  
    
  class Radiolist < List
    def initialize(opts={})
      opts[:list]    = true
      opts[:columns] = [''] + opts[:columns]
      opts[:items].map! {|item| item = ['', [item]].flatten }
      super
    end  
  end

  class Checklist < Radiolist
    def run
      @separator ||= '|'
      orig_run.split(@separator) 
    end
  end

  class Scale < Dialog
    attr_accessor :text, :value, :min_value, :max_value, :step, 
                  :print_partial, :hide_value
    
    def run; orig_run.to_i end
  end

end
