local M = {}

function M.setup(options)
	M.ops = require("kanban.ops").get_ops(options)
	M.state = require("kanban.state").init(M)
	M.fn = require("kanban.fn")
	vim.api.nvim_create_user_command("KanbanOpen", M.kanban_open, {})
end

function M.kanban_open()
	M.items = {}
	M.items.kwindow = {}
	M.markdown = require("kanban.markdown")
	-- for i in pairs(M.ops.kanban_md_path) do
	-- 	print("[" .. i .. "] " .. M.ops.kanban_md_path[i])
	-- end
	-- local md_path_index = vim.fn.input("Select -> ")
	-- if not M.ops.kanban_md_path[md_path_index] then
	-- 	md_path_index = 1
	-- end
	local md_path_index = 1
	M.kanban_md_path = M.ops.kanban_md_path[md_path_index]
	local md = M.markdown.reader.read(M, M.kanban_md_path)

	-- create window panel
	M.fn.kwindow.add(M)

	-- create list panel
	M.items.lists = {}
	for i in pairs(md.lists) do
		M.fn.lists.add(M, md.lists[i].title)
	end

	-- create task panel
	for i in pairs(md.lists) do
		local list = md.lists[i]
		for j in pairs(list.tasks) do
			local task = list.tasks[j]
			local open_bool = j <= M.state.max_task_show_int
			M.fn.tasks.add(M, i, task, "bottom", open_bool)
		end
	end
	-- if #M.items.lists > 0 then
		-- vim.fn.win_gotoid(M.items.lists[1].tasks[1].win_id)
	-- end
end

return M
