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
        # ファイル名を指定しない場合は標準入力から読み込む
        stdin = $stdin.readlines
        generate_one_line_for_display(stdin.count, stdin.join.split(/\s+/).count, stdin.join.bytesize)
      else
        wc_files = target_files
        files_display_info = wc_files.map { |wc_f| generate_one_line_for_display(wc_f.lines, wc_f.words, wc_f.bytes, " #{wc_f.file}") }
        total_lines = wc_files.sum(&:lines)
        total_words = wc_files.sum(&:words)
        total_bytes = wc_files.sum(&:bytes)
        files_display_info << generate_one_line_for_display(total_lines, total_words, total_bytes, ' total') if @files.count > 1
        files_display_info.join("\n")
      end
    end

    private

    def target_files
      @files.map { |file| WC::File.new(file) }
    end

    def generate_one_line_for_display(lines, words, bytes, suffix_str = nil)
      if @options.include?('l')
        "#{convert_to_display_format(lines)}#{suffix_str}"
      else
        "#{convert_to_display_format(lines)}#{convert_to_display_format(words)}#{convert_to_display_format(bytes)}#{suffix_str}"
      end
    end

    def convert_to_display_format(item)
      format('% 8d', item)
    end
  end
end
