require "spec_helper"
require 'securerandom'

RSpec.describe "runbook sshkit integration", type: :aruba do
  let(:config_file) { "runbook_config.rb" }
  let(:config_content) do
    <<-CONFIG
    Runbook.configure do |config|
      config.ssh_kit.use_format :dot
    end
    CONFIG
  end
  let(:runbook_file) { "my_runbook.rb" }
  let(:book_title) { "My Runbook" }
  let(:repo_file) {
    Runbook::Util::Repo._file(book_title)
  }
  let(:stored_pose_file) {
    Runbook::Util::StoredPose._file(book_title)
  }

  around(:all) do |example|
    ports = "-p 10022:22"
    mount = "-v ~/.ssh/id_rsa.pub:/etc/authorized_keys/$USER"
    users = %Q{-e SSH_USERS="$USER:500:500"}
    image = "docker.io/panubo/sshd:1.0.3"
    begin
      @cid = `docker run -d #{ports} #{mount} #{users} #{image}`.strip
      sleep 1
      example.run
    ensure
      `docker stop -t 0 #{@cid}`
      system("docker rm -f #{@cid} 2>&1 1>/dev/null")
    end
  end

  before(:each) { write_file(config_file, config_content) }
  before(:each) { write_file(runbook_file, content) }

  before(:each) do
    FileUtils.rm_f(repo_file)
    FileUtils.rm_f(stored_pose_file)
  end

  before(:each) { run_command(command) }

  describe "sshkit" do
    let(:command) { "runbook exec -P #{runbook_file}" }
    let(:content) do
      <<-RUNBOOK
      SSHKit::Backend::Netssh.configure do |ssh|
        ssh.ssh_options = {
          verify_host_key: :never,
        }
      end

      Runbook.book "#{book_title}" do
        step do
          server "admin@127.0.0.1:10022"

          command "cat /etc/hostname"
        end
      end
      RUNBOOK
    end
    let(:output_lines) {
      [
        /#{@cid[0..11]}/,
      ]
    }

    it "executes remote commands" do
      output_lines.each do |line|
        expect(last_command_started).to have_output(line)
      end
    end
  end
end

