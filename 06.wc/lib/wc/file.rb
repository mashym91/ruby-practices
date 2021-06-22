# frozen_string_literal: true

module WC
  class File
    attr_reader :file, :lines, :words, :bytes

    def initialize(file)
      str = ::File.read(file)
      @file = file
      @lines = str.lines.count
      @words = str.split(/\s+/).count
      @bytes = ::File.size(file)
    end
  end
end
