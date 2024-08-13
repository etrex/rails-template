
# Batchs::Process.run
module Batchs
  class Process
    class << self
      def run(auto_process_count = 10)
        puts "auto_process_count: #{auto_process_count}"
        GptFunction::Batch.process(count: auto_process_count) do |batch|
          puts "batch id: #{batch.id}, status: #{batch.status}, progress: #{batch.request_counts_completed}/#{batch.request_counts_total}"
          process_class = batch.metadata["process_class"].constantize.new

          batch.pairs.each do |input, output|
            # puts "input: #{input}, output: #{output}"
            process_class.process(input, output) rescue nil
          end
        end
      end
    end
  end
end
