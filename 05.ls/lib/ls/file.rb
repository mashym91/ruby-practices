# frozen_string_literal: true

require 'etc'

module LS
  class File
    attr_reader :file_name

    def initialize(file)
      stat = ::File.stat(file)
      mode = stat.mode.to_s(8)

      @file_name = file
      @permission = convert_permission_to_symbolic_notation(mode)
      @link_count = stat.nlink
      @owner_name = Etc.getpwuid(stat.uid).name
      @group_name = Etc.getgrgid(stat.gid).name
      @size = stat.size
      @mtime = stat.mtime
    end

    def build_detail_info
      file_info = ''
      file_info += ::File.directory?(@file_name) ? 'd' : '-' # ファイルタイプ
      file_info += "#{@permission}  " # パーミション
      file_info += "#{@link_count} " # ハードリンクの数
      file_info += "#{@owner_name}  " # オーナー名
      file_info += "#{@group_name}  " # グループ名
      file_info += "#{@size}  " # バイトサイズ
      file_info += "#{@mtime.strftime('%-m %d %H:%M')} " # タイムスタンプ
      file_info + @file_name # ファイル名
    end

    private

    def convert_permission_to_symbolic_notation(mode)
      permissions = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }

      # 末尾から3文字取得してrwxr-xr-xのように変換
      mode.slice(-3..-1).chars.map { |item| permissions[item] }.join
    end
  end
end
