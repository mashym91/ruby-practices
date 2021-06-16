# frozen_string_literal: true

require_relative './file'

module WC
  class Command
    def initialize(options, files)
      @options = options
      @files = files
    end

    def exec
      if @files.empty?
        # 入力ファイル名を指定しない場合は標準入力から読み込む
        standard_input = readlines

        if @options.include?('l')
          format('% 8d', standard_input.count).to_s
        else
          convert_to_display_format(standard_input.count, standard_input.join.split(/\s+/).count, standard_input.join.bytesize)
        end
      else
        total_lines = 0
        total_words = 0
        total_bytes = 0
        files_display_info = []
        @files.each do |file|
          wc_file = WC::File.new(file)
          files_display_info << "#{convert_to_display_format(wc_file.lines, wc_file.words, wc_file.bytes)} #{file}"
          total_lines += wc_file.lines
          total_words += wc_file.words
          total_bytes += wc_file.bytes
        end
        files_display_info << "#{convert_to_display_format(total_lines, total_words, total_bytes)} total" if @files.count > 1
        files_display_info.join("\n")
      end
    end

    private

    def convert_to_display_format(lines, words, bytes)
      "#{format('% 8d', lines)}#{format('% 8d', words)}#{format('% 8d', bytes)}"
    end
  end
end
