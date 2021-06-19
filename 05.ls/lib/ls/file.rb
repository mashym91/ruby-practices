# frozen_string_literal: true

require 'etc'

module LS
  class File
    attr_reader :file_name, :blocks, :permission, :owner_name, :group_name

    def initialize(file)
      stat = ::File.stat(file)
      mode = stat.mode.to_s(8)

      @file_name = file
      @file_type = stat.ftype
      @permission = convert_permission_to_symbolic_notation(mode)
      @link_count = stat.nlink
      @owner_name = Etc.getpwuid(stat.uid).name
      @group_name = Etc.getgrgid(stat.gid).name
      @size = stat.size
      @mtime = stat.mtime
      @blocks = stat.blocks
    end

    def self.sum_blocks(files)
      files.inject(0) { |result, file| result + file.blocks.to_i }
    end

    def build_detail_info
      file_info = ''
      file_info += @file_type == 'directory' ? 'd' : '-' # ファイルタイプ
      file_info += "#{permission}  " # パーミション
      file_info += "#{@link_count} " # ハードリンクの数
      file_info += "#{owner_name}  " # オーナー名
      file_info += "#{group_name}  " # グループ名
      file_info += "#{@size}  " # バイトサイズ
      file_info += "#{timestamp} " # タイムスタンプ
      file_info + @file_name # ファイル名
    end

    def timestamp
      @mtime.strftime('%-m %-d %H:%M')
    end

    private

    def convert_permission_to_symbolic_notation(mode)
      permissions = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }

      # 末尾から3文字取得してrwxr-xr-xのように変換
      mode.slice(-3..-1).chars.map { |item| permissions[item] }.join
    end
  end
end
