# frozen_string_literal: true

require_relative './file'

module LS
  class Command
    DISPLAY_COLUMN = 3 # 列

    def initialize(options, file_or_dir)
      @options = options
      @current_dir = Dir.pwd
      @file_or_dir = file_or_dir.nil? ? @current_dir : file_or_dir
    end

    def exec
      files = read_files.map { |file| LS::File.new(file) }

      Dir.chdir(@current_dir) # ディレクトリを元に戻す

      files.reverse! if @options.include?('r')

      if @options.include?('l')
        total = LS::File.sum_blocks(files.map(&:blocks))
        files.map!(&:build_detail_info)
        files.unshift("total #{total}")
        files.join("\n")
      else
        generate_formatted_files_from_defined_column(files) # DISPLAY_COLUMN毎の表示
      end
    end

    private

    def read_files
      if ::File.directory?(@file_or_dir)
        Dir.chdir(@file_or_dir)

        if @options.include?('a')
          Dir.glob('*', ::File::FNM_DOTMATCH)
        else
          Dir.glob('*')
        end
      else
        [@file_or_dir]
      end
    end

    def generate_formatted_files_from_defined_column(files)
      row = (files.count.to_f / DISPLAY_COLUMN).ceil  # 行
      sort_files = []

      row.times do |row_index|
        sort_files << []
        DISPLAY_COLUMN.times do |column_index|
          sort_files[row_index] << files[row_index + row * column_index]&.file_name ||= ''
          sort_files[row_index] << "\t"
        end
        sort_files[row_index] << "\n"
      end

      sort_files.join('')
    end
  end
end
