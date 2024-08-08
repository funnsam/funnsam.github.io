-- This is just https://github.com/funnsam/mw/blob/main/postprocess.lua, with some changes

local function get_rel_path(path)
	return string.sub(path, #project_base + #"/pages/" + 1)
end

local function to_rel_url(url, depth)
	if string.match(url, "^.+://.*") or string.match(url, "^%./.*") or string.match(url, "^/.*") then
		return url
	else
		local url = string.rep("../", depth) .. url
		if #url ~= 0 then
			return url
		else
			return "./"
		end
	end
end


function generate_final_html(path, depth, body, options)
	local title_html = ""
	if options.title ~= nil then
		title_html = string.format("%s", options.title)
	end

	local nb_left = ""
	for item = 1, #navbar.left do
		local item = navbar.left[item]
		if item.md == get_rel_path(path) then
			nb_left = nb_left .. string.format("<a id=\"active\">%s</a>", item.name)
		else
			nb_left = nb_left .. string.format("<a href=\"%s\">%s</a>", to_rel_url(item.url, depth), item.name)
		end
	end

	local nb_right = ""
	for item = 1, #navbar.right do
		local item = navbar.right[item]
		if item.md == get_rel_path(path) then
			nb_right = nb_right .. string.format("<a id=\"active\">%s</a>", item.name)
		else
			nb_right = nb_right .. string.format("<a href=\"%s\">%s</a>", to_rel_url(item.url, depth), item.name)
		end
	end

	return string.format([[
<!DOCTYPE HTML><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.10/dist/katex.min.css" crossorigin="anonymous"><link rel="stylesheet" href="%sstyle.css"><script defer src="%sscript.js"></script><script src="https://funnsam.github.io/twemoji/dist/twemoji.min.js" crossorigin="anonymous"></script><title>%s</title></head><body><nav><div id="navham"><button id="hamburger">More</button></div><div id="navinner"><span id="nav_left">%s</span><span id="nav_right">%s</span></div></nav><div id="page_content">%s</div></body></html>
]], string.rep("../", depth), string.rep("../", depth), title_html, nb_left, nb_right, body)
end
