apt_repository 'elasticbeats' do
  uri 'https://artifacts.elastic.co/packages/7.x/apt'
  key 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
  components %w(stable main)
  distribution ''
  action :add
end
