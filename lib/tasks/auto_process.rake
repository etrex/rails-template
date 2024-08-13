# lib/tasks/auto_process.rake

# heroku logs --tail --app pickupword | grep "scheduler"
namespace :auto do
  # rake auto:process
  # brails auto:process
  desc "auto process"
  task process: :environment do
    puts "== auto process 開始 =="

    # 檢查舊的 batch 是否已完成
    auto_process_count = ENV["AUTO_PROCESS_COUNT"].to_i
    auto_process_count = 10 if auto_process_count == 0 && ENV["AUTO_PROCESS_COUNT"] == nil
    Batchs::Process.run(auto_process_count)

    puts "== auto process 結束 =="
  end
end
