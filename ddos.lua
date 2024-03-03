
text = [[
    d      d       b d s.        d ss    d ss      sSSSs     sss.      sss sssss   sSSSs     sSSSs   d      
    S      S       S S  ~O       S   ~o  S   ~o   S     S  d               S      S     S   S     S  S      
    S      S       S S   `b      S     b S     b S       S Y               S     S       S S       S S      
    S      S       S S sSSO      S     S S     S S       S   ss.           S     S       S S       S S      
    S      S       S S    O      S     P S     P S       S      b          S     S       S S       S S      
    S       S     S  S    O      S    S  S    S   S     S       P          S      S     S   S     S  S      
    P sSSs   "sss"   P    P      P ss"   P ss"     "sss"   ` ss'           P       "sss"     "sss"   P sSSs 
                                                                                                        
]]

additional_text = [[
[$] Made by SDL
[$] /cmd to see commands
]]

help_text = [[
Help:
 /host - Enter the Host Domain or Ip Address
 /port - Enter a custom port if you have one, or just don't use it will use port 80
 /amount - Enter a custom amount of attack, Default 1000
 /start - Will start attacking and display outputs on the console
]]
-- alr its done now, lets test it
function clear_terminal()
    os.execute('cls')
end

function print_centered_colored_text(text, color)
    local term_width, term_height = 110, 24
    local lines = {}
    for line in text:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end

    local max_line_length = 0
    for _, line in ipairs(lines) do
        max_line_length = math.max(max_line_length, line:len())
    end

    for _, line in ipairs(lines) do
        local padding = math.max((term_width - max_line_length) // 2, 0)
        print(color .. (' '):rep(padding) .. line .. "\27[0m")
    end
end

function print_horizontal_line(color, length)
    print(color .. ('-'):rep(math.min(length, 110)) .. "\27[0m")
end

function validate_host(input_str)
    local ip_pattern = "^%d+%.%d+%.%d+%.%d+$"
    local domain_pattern = "^[%w-]+%.[%w-]+$"

    return string.match(input_str, ip_pattern) or string.match(input_str, domain_pattern)
end

function validate_port(input_str)
    local port_pattern = "^%d+$"
    return string.match(input_str, port_pattern)
end

function validate_amount(input_str)
    local amount_pattern = "^%d+$"
    return string.match(input_str, amount_pattern)
end

function ping_host(host, count, delay)
    local command = "ping -n " .. count .. " " .. host  -- Windows için
    print("[+] Starting Ping")

    local handle = io.popen(command)
    local result = handle:read("*a")
    handle:close()

    if result then
        local lines = {}
        for line in result:gmatch("[^\r\n]+") do
            table.insert(lines, line)
        end

        local delaySeconds = delay or 0.1  -- Bekletme süresi (saniye cinsinden), varsayılan 0.1 saniye

        for _, line in ipairs(lines) do
            print(line)
            if string.match(line, "Reply from") and delaySeconds > 0 then
                os.execute("ping -n " .. math.ceil(delaySeconds + 0.1) .. " 127.0.0.1 > nul")  -- Belirli bir süre bekletme
            end
        end
    else
        print("[-] No ping results.")
    end
end




local user_host = nil
local user_amount = "1000"

clear_terminal()

print_centered_colored_text(text, "\27[31m")

print_horizontal_line("\27[37m", 110) 

print_horizontal_line("\27[37m", 110)
print_centered_colored_text(additional_text, "\27[33m")

print_horizontal_line("\27[37m", 110)

while true do
    io.write("\27[34mUser >> \27[0m")
    local user_input = io.read()

    if user_input:lower() == "/cmd" then
        print(help_text)
    elseif user_input:lower():match("^/host ") then
        local host_input = user_input:sub(7)

        if validate_host(host_input) then
            user_host = host_input
            print("[+] Target saved: " .. user_host)
        else
            print("[-] Invalid host: " .. host_input)
        end
    elseif user_input:lower():match("^/port ") then
        local port_input = user_input:sub(7)

        if validate_port(port_input) then
            print("[+] Port saved: " .. port_input)
        else
            print("[-] Invalid port: " .. port_input)
        end
    elseif user_input:lower():match("^/amount ") then
        local amount_input = user_input:sub(9)

        if validate_amount(amount_input) then
            user_amount = amount_input
            print("[+] Amount saved: " .. user_amount)
        else
            print("[-] Invalid amount: " .. amount_input)
        end
    elseif user_input:lower() == "/start" then
        if user_host then
            ping_host(user_host, user_amount)
        else
            print("\27[34m[+] Please enter target host, port, and amount before starting.\27[0m")
        end
    else
        print("[-] Invalid command")
    end
end
