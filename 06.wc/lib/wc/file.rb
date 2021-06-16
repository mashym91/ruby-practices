# frozen_string_literal: true

module WC
  class File
    attr_reader :lines, :words, :bytes

    def initialize(file)
      str = ::File.read(file)
      @lines = str.lines.count
      @words = str.split(/\s+/).count
      @bytes = ::File.size(file)
    end
  end
end
