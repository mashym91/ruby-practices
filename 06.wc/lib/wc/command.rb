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
        standard_input = $stdin.readlines
        generate_display_format(standard_input.count, standard_input.join.split(/\s+/).count, standard_input.join.bytesize)
      else
        total_lines = 0
        total_words = 0
        total_bytes = 0
        files_display_info = []
        @files.each do |file|
          wc_file = WC::File.new(file)
          files_display_info << generate_display_format(wc_file.lines, wc_file.words, wc_file.bytes, " #{file}")
          total_lines += wc_file.lines
          total_words += wc_file.words
          total_bytes += wc_file.bytes
        end
        files_display_info << generate_display_format(total_lines, total_words, total_bytes, ' total') if @files.count > 1
        files_display_info.join("\n")
      end
    end

    private

    def generate_display_format(lines, words, bytes, suffix_str = nil)
      if @options.include?('l')
        "#{convert_to_display_format(lines)}#{suffix_str}"
      else
        "#{convert_to_display_format(lines)}#{convert_to_display_format(words)}#{convert_to_display_format(bytes)}#{suffix_str}"
      end
    end

    def convert_to_display_format(item)
      format('% 8d', item).to_s
    end
  end
end
