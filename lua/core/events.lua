local E = {
	subscriptions = {},
}

function E.notify(key, message)
	E.subscriptions[key] = message
	return message
end

function E.take(key)
	local ret = E.subscriptions[key]
	E.subscriptions[key] = nil
	return ret
end

function E.notifier(key, message)
	return function()
		E.notify(key, message)
	end
end

function E.inspect()
	vim.print(E.subscriptions)
end

return E
