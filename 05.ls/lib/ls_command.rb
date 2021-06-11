# frozen_string_literal: true

class LsCommand
  DISPLAY_ROW = 3

  def initialize(options, file_or_dir)
    @options = options
    @current_dir = Dir.pwd
    @file_or_dir = file_or_dir.nil? ? @current_dir : file_or_dir
  end

  def exec
    files = read_files
    Dir.chdir(@current_dir) # ディレクトリを元に戻す

    if @options.include?('l')
      files.map! do |file|
        generate_l_command_format(file)
      end
    end

    files.reverse! if @options.include?('r')

    if @options.include?('l')
      files.join("\n")
    else
      generate_column_format(files) # DISPLAY_ROW毎の表示
    end
  end

  private

  def read_files
    if File.directory?(@file_or_dir)
      Dir.chdir(@file_or_dir)

      if @options.include?('a')
        Dir.glob('*', File::FNM_DOTMATCH)
      else
        Dir.glob('*')
      end
    else
      [@file_or_dir]
    end
  end

  def generate_l_command_format(file)
    file_info = ''
    stat = File.lstat(file)
    mode = stat.mode.to_s(8)
    file_info += File.directory?(file) ? 'd' : '-'
    file_info += convert_permission_to_str(mode)
    file_info
  end

  def convert_permission_to_str(mode)
    permissions = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'w--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }

    # 末尾から3文字取得
    mode.slice(-3..-1).chars.map { |item| permissions[item] }.join
  end

  def generate_column_format(files)
    column = (files.count.to_f / DISPLAY_ROW).ceil
    sort_files = []
    column.times { sort_files << [] }

    column.times do |column_index|
      DISPLAY_ROW.times do |row_index|
        sort_files[column_index] << files[column_index + column * row_index] ||= ''
        sort_files[column_index] << "\t"
      end
      sort_files[column_index] << "\n"
    end

    sort_files.join('')
  end
end
