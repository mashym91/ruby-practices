# frozen_string_literal: true

require 'etc'

class LsCommand
  DISPLAY_ROW = 3

  def initialize(options, file_or_dir)
    @options = options
    @current_dir = Dir.pwd
    @file_or_dir = file_or_dir.nil? ? @current_dir : file_or_dir
  end

  def exec
    files = read_files

    if @options.include?('l')
      files.map! do |file|
        generate_formatted_l_option(file)
      end
    end

    Dir.chdir(@current_dir) # ディレクトリを元に戻す

    files.reverse! if @options.include?('r')

    if @options.include?('l')
      files.join("\n")
    else
      generate_formatted_files_from_defined_row(files) # DISPLAY_ROW毎の表示
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

  def generate_formatted_l_option(file)
    file_info = ''
    stat = File.stat(file)
    mode = stat.mode.to_s(8)
    file_info += File.directory?(file) ? 'd' : '-' # ファイルタイプ
    file_info += "#{convert_permission_to_str(mode)}  " # パーミション
    file_info += "#{stat.nlink} " # ハードリンクの数（2桁スペース埋め）
    file_info += "#{Etc.getpwuid(stat.uid).name}  " # オーナー名
    file_info += "#{Etc.getgrgid(stat.gid).name}  " # グループ名
    file_info += "#{stat.size}  " # バイトサイズ（5桁スペース埋め）
    file_info += "#{stat.mtime.strftime('%-m %d %H:%M')} " # タイムスタンプ
    file_info + file # ファイル名
  end

  def convert_permission_to_str(mode)
    permissions = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }

    # 末尾から3文字取得して表記変換して結合
    mode.slice(-3..-1).chars.map { |item| permissions[item] }.join
  end

  def generate_formatted_files_from_defined_row(files)
    line = (files.count.to_f / DISPLAY_ROW).ceil
    sort_files = []
    line.times { sort_files << [] }

    line.times do |line_index|
      DISPLAY_ROW.times do |row_index|
        sort_files[line_index] << files[line_index + line * row_index] ||= ''
        sort_files[line_index] << "\t"
      end
      sort_files[line_index] << "\n"
    end

    sort_files.join('')
  end
end
