# access_log_apiで取得したデータを抽出・整形するクラス

require Rails.root.join('app', 'lib', 'api', 'access_log_api')

module Api
  class AccessLog

      def self.all(*paths)
        Api::AccessLogApi.get(*paths)
      end

    def has_error?
      status.to_s.match?(/^[45]/)
    end
  end

end