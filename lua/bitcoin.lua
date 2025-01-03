local Bitcoin = {
	bitcoin_price = "00000.00$",
}

function Bitcoin.getBitcoinPrice()
	local url = "https://api.binance.com/api/v3/ticker/price?symbol=BTCUSDT"
	local command = "curl -s '" .. url .. "'"
	vim.fn.jobstart(command, {
		stdout_buffered = true,
		stderr_buffered = true,
		on_stdout = function(_, output)
			local success, data = pcall(vim.fn.json_decode, output)
			if success and data and data.price then
				Bitcoin.bitcoin_price = string.format("%.2f$", data.price)
			end
		end,
	})
end

function Bitcoin.start()
	local interval = 60 * 1000 -- 1 minute
	local timer = vim.loop.new_timer()
	timer:start(0, interval, vim.schedule_wrap(Bitcoin.getBitcoinPrice))
end

function Bitcoin.price()
	return Bitcoin.bitcoin_price
end

return Bitcoin
